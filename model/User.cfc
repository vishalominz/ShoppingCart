<!---
  --- User
  --- ----
  ---
  --- author: mindfire
  --- date:   3/10/17
  --->
<cfcomponent
	extends="BaseAPI"
	accessors="true"
	output="false"
	persistent="false"
	hint="Public API for User.">


<!--- User switchUser() function --->
	<cffunction name="switchUser"
				access="remote"
				returnformat="json"
				returntype="any">
		<!--- Get a new API response --->
		<cfset var LOCAL = {} />

		<!--- Get a new API response --->
		<cfset LOCAL.Response = THIS.GetNewResponse() />
		<cfparam name="link" default="" />

		<cfif !session.loggedIn>
			<cfif session.isSeller>
				<cfset session.isSeller = false />
				<cfset link="http://www.shopsworld.net/index.cfm">
				<cfset message = "Switched to Customer View." />
				<cfset THIS.log("Success","User",getFunctionCalledName(),message) />
			<cfelse>
				<cfset session.isSeller = true />
				<cfset link="http://www.shopsworld.net/view/login.cfm">
				<cfset message = "Switched to Seller View." />
				<cfset THIS.log("Success","User",getFunctionCalledName(),message) />
			</cfif>
		<cfelse>
			<cfset LOCAL.Response.errors = "User is logged in" />
		</cfif>
		<cfset LOCAL.Response.url = link />
		<cfreturn LOCAL.Response />
	</cffunction>

<!--- User logIn() function --->
	<cffunction	name="logIn"
			returntype="any"
			access="remote"
			returnformat="JSON"
			output="false"
			hint="Check login information.">

			<cfargument
				name="email"
				type="string"
				required="true"
				hint="Email ID of the user" />

			<cfargument
				name="password"
				type="string"
				required="true"
				hint="Password of the user" />
			<cfargument
				name="company"
				required="false"
				type="string"
				default=""
				hint="Company of the user"/>

			<cfparam
				name="isLoggedIn"
				default="false" />

			<cfparam
				name="isSeller"
				default="#SESSION.isSeller#" />

		<!--- Get a new API response --->
		<cfset var LOCAL = {} />

		<!--- Get a new API response --->
		<cfset LOCAL.Response = THIS.GetNewResponse() />
		<!--- Check to see if all the data is defined. --->
		<cfif NOT Len(ARGUMENTS.email)>
			<cfset ArrayAppend(
				LOCAL.Response.Errors,
				"Email not Found"
				) />
		</cfif>

		<cfif NOT Len(ARGUMENTS.password)>
			<cfset ArrayAppend(
				LOCAL.Response.Errors,
				"Password not Found"
				) />
		</cfif>

		<!--- Check if any error is present --->
		<cfif NOT ArrayLen( LOCAL.Response.Errors)>
			<!--- setting default variables --->
			<cfparam name="isItemPresent" default=false />
			<cfparam name="itemIndex" default=1 />
			<cfset LOCAL.Item = {} />

			<cftry>
				<!--- Call database to retrieve user info --->
				<cfif !isSeller >
					<cfinvoke	component="Database"
						method="retrieveUserInfo"
						returnvariable="userInfo">

						<cfinvokeargument
							name="email"
							value="#ARGUMENTS.email#" />

						<cfinvokeargument
							name="password"
							value="#ARGUMENTS.password#" />
					</cfinvoke>
				<!--- if user is a seller --->
				<cfelse>
					<cfinvoke component="Database"
								method="retrieveSellerInfo"
								returnvariable="userInfo">
							<cfinvokeargument name="email"
									value="#ARGUMENTS.email#" />
							<cfinvokeargument name="password"
									value="#ARGUMENTS.password#" />
							<cfinvokeargument name="company"
									value="#ARGUMENTS.company#" />
					</cfinvoke>
				</cfif>
				<cfset message = "Database Call Success. Retrieved user info." />
				<cfset THIS.log("SUCCESS","User",getFunctionCalledName(),message) />
				<cfcatch type="database">
					<cfset message = "Database Call Failured. Failed to retrieve user info." />
					<cfset THIS.log("ERROR","User",getFunctionCalledName(),message) />
				</cfcatch>
			</cftry>

			<!--- If user is present then perform --->
				<cfif userInfo.recordcount eq 1>
					<cfset session.user.userName = userInfo.CustomerName />
					<cfset session.loggedIn = true />
					<cfset session.user.userId = userInfo.CustomerId />
					<cfset session.user.email = userInfo.Email />
					<cfset session.user.mobileNumber = userInfo.MobileNumber />
					<cfset session.user.userType = userInfo.CustomerType />
					<cfif structKeyExists("#userInfo#","SellingCompanyId")>
						<cfset session.user.SellingCompanyId = userInfo.SellingCompanyId />
					</cfif>
					<cfset isLoggedIn = "true" />
					<cfset LOCAL.Item ={
						username = userInfo.CustomerName,
						userId = userInfo.CustomerId,
						email = userInfo.Email,
						mobileNumber = userInfo.MobileNumber,
						CustomerType = userInfo.CustomerType
					 	} />
					<cfset LOCAL.Response.Data = LOCAL.Item />

					<cfif !isSeller>
						<cftry>
							<cfinvoke
								component="Database"
								method="retrieveCart"
								returnvariable="cart">
									<cfinvokeargument
											name="customerId"
											value="#session.user.userId#"	/>
							</cfinvoke>
							
							<cfif cart.recordcount gt 0>
								<cfloop query="#cart#">
									<cfset cartId = "#CartId#" />
									<cfbreak/>
								</cfloop>

								<cfinvoke
									component="Database"
									method="retrieveCartItemDetail"
									returnvariable="cartItemDetail">

									<cfinvokeargument
											name="cartId"
											value="#cartId#" />
								</cfinvoke>

								<cfloop query="cartItemDetail">
									<cfset LOCAL.product = {
											DISCOUNT = #DiscountPercent#,
											INVENTORYID	= #InventoryId#,
											MAXCOUNT = #AvailableQuantity#,
											PRICE = #SellingPrice#,
											PRODUCTBRAND = #ProductBrand#,
											PRODUCTCOUNT = #Quantiy#,
											PRODUCTDESCRIPTION = #ProductDescription#,
											PRODUCTID = #ProductId#,
											PRODUCTIMAGELOCATION = #ProductImageLocation#,
											PRODUCTNAME	= #ProductName#,
											SELLINGCOMPANYID = #SellingCompanyId#
												} />
									<cfset isPresentInCart = false />
									<cfloop from="1" to="#ArrayLen(session.cart)#"
										index="location">
										<cfif session.cart[location].inventoryId eq
											LOCAL.product.InventoryId>
											<cfif session.cart[location].PRODUCTCOUNT
												lt LOCAL.product.PRODUCTCOUNT>
													<cfset session.cart[location].PRODUCTCOUNT =
															 LOCAL.product.PRODUCTCOUNT />
											</cfif>
											<cfset isPresentInCart = true />
										</cfif>		
									</cfloop>
									<cfif !isPresentInCart>
										<cfset arrayAppend(session.cart,product) />
									</cfif>
									
								</cfloop>
							<!--- Log on successfull retrieval of cartItems --->
								<cfset message = "Database Call Success. User #session.user.userName# saved cart info retrieved." />
								<cfset THIS.log("SUCCESS","User",getFunctionCalledName(),message) />
							</cfif>
							<cfcatch type="database">
								<cfset message = "Database cart info failed to retrieve." />
								<cfset THIS.log("ERROR","User",getFunctionCalledName(),message) />
							</cfcatch>
						</cftry>
					</cfif>
					<cfset message = "User #Session.user.userName# [#SESSION.user.userId#] logged in successfully" />
					<cfset THIS.log("SUCCESS","User",getFunctionCalledName(),message) />
			<!--- else when user is not present --->
				<cfelse>
					<cfset message = "User failed to log In." />
					<cfset THIS.log("Failure","User",getFunctionCalledName(),message) />
					<cfset LOCAL.Response.Success = "false" />
				</cfif>
		</cfif>


		<cfif !isSeller>
			<cfset LOCAL.Response.url = "#SESSION.lastpage#" />
		<cfelse>
			<cfset LOCAL.Response.url = "http://www.shopsworld.net/view/seller.cfm" />
		</cfif>

		<cfreturn LOCAL.Response />
	</cffunction>

<!--- user logOut() function --->
	<cffunction	name="logOut"
			access="public"
			returnformat="json"
			output="false"
			hint="Log out user." >

		<cfset session.log = "#CGI.HTTP_REFERER#" />
		<!--- Get a new API response --->
		<cfset var LOCAL = {} />

		<!--- Get a new API response --->
		<cfset LOCAL.Response = THIS.GetNewResponse() />


		<cfif NOT arrayLen(LOCAL.Response.Errors)>
		<!--- retrieve cart Id for customer --->
			<cftry>
				<cfinvoke
					component="Database"
					method="retrieveCart"
					returnvariable="cart">

					<cfinvokeargument name="customerId"
							value="#SESSION.user.userId#" />
				</cfinvoke>
				<cfset message = "Database cart items retrieve successfully." />
				<cfset THIS.log("SUCCESS","User",getFunctionCalledName(),message) />
				<cfcatch type="database">
					<cfset message = "Database cart items retrieve failed." />
					<cfset THIS.log("ERROR","User",getFunctionCalledName(),message) />
				</cfcatch>
			</cftry>
		<!--- if cart is already present --->
			<cfif cart.recordCount gt 0>
			<!--- retrieve cart Id --->
				<cfloop query="cart">
					<cfset cartId = "#CartId#" />
					<cfbreak />
				</cfloop>

		<!--- if cart is not present --->
			<cfelse>
				<!--- create a cart id --->
				<cftry>
					<cfinvoke
						component="Database"
						method="insertCart"
						returnvariable="cartId">

						<cfinvokeargument name="customerId"
								value="#SESSION.user.userId#" />
					</cfinvoke>

					<cfset message = "Database cart insert success." />
					<cfset THIS.log("SUCCESS","User",getFunctionCalledName(),message) />
					<cfcatch type="database">
						<cfset message = "Database cart insert failed." />
						<cfset THIS.log("ERROR","User",getFunctionCalledName(),message) />
						<cfrethrow />
					</cfcatch>
				</cftry>
			</cfif>

		<!--- delete cart items --->
			<cftry>
				<cfinvoke
					component="Database"
					method="removeCartDetail"
					returnvariable="cartItems">

					<cfinvokeargument name="cartId"
							value="#cartId#" />
				</cfinvoke>
				<cfset message = "Database cart items removed successfully." />
				<cfset THIS.log("SUCCESS","User",getFunctionCalledName(),message) />
				<cfcatch type="database">
					<cfset message = "Database cart items not removed." />
					<cfset THIS.log("ERROR","User",getFunctionCalledName(),message) />
				</cfcatch>
			</cftry>

		<!--- loop through cart and insert in database ---->
			<cfloop from="1" to="#ArrayLen(SESSION.cart)#" index="location">
				<cfset cartItem = {
						cartId="#cartId#",
						inventoryId = "#SESSION.cart[location].inventoryId#",
						quantity = "#SESSION.cart[location].productCount#"
						} />
			<!--- write cart items to database --->
				<cftry>
					<cfinvoke
						component="Database"
						method="insertCartDetail"
						argumentcollection="#cartItem#"
						returnvariable="cartItem">
					</cfinvoke>
					<cfset message = "Database cart details inserted successfully." />
					<cfset THIS.log("SUCCESS","User",getFunctionCalledName(),message) />
					<cfcatch type="database">
						<cfset message = "Database cart details insert failed." />
						<cfset THIS.log("ERROR","User",getFunctionCalledName(),message) />
					</cfcatch>
				</cftry>

			</cfloop>
		</cfif>

	<!--- Log logged out success --->
		<cfset message = "User #Session.user.userName# [#SESSION.user.userId#] logged out successfully" />
		<cfset THIS.log("SUCCESS","User",getFunctionCalledName(),message) />
		
	<!--- delete session variables --->
		<cfset structdelete(session,"user") />
		<cfset session.LoggedIn = false />
		<cfset LOCAL.Response.url = "#CGI.HTTP_REFERER#" />
		<cfset LOCAL.Response.Success = true />
	
		<cfreturn LOCAL.Response />
	</cffunction>

<!--- user registerUser() function --->
	<cffunction	name="registerUser"
			access="public"
			returnformat="json"
			output="false"
			returntype="any"
			hint="Register user">

			<cfargument
				name="name"
				type="string"
				required="true"
				hint="Name of the user" />

			<cfargument
				name="email"
				type="string"
				required="true"
				hint="Email Id of the user" />

			<cfargument
				name="password"
				type="string"
				required="true"
				hint="Password of the user" />

			<cfargument
				name="mobileNumber"
				type="numeric"
				required="true"
				hint="Mobile No of the user" />

			<cfargument
				name="company"
				type="string"
				required="true"
				hint="Comapny of a seller" />
		<!--- Get a new API response --->
		<cfset var LOCAL = {} />

		<!--- Get a new API response --->
		<cfset LOCAL.Response = THIS.GetNewResponse() />

		<!--- Check to see if all the data is defined. --->
		<cfif NOT Len(ARGUMENTS.email)>
			<cfset ArrayAppend(
				LOCAL.Response.Errors,
				"Email not Found"
				) />
		</cfif>
		<cfif NOT Len(ARGUMENTS.password)>
			<cfset
			ArrayAppend(
				LOCAL.Response.Errors,
				"Password not Found"
				) />
		</cfif>
		<cfif NOT Len(ARGUMENTS.mobileNumber)>
			<cfset
			ArrayAppend(
				LOCAL.Response.Errors,
				"Mobile Number not Found"
				) />
		</cfif>
		<cfif NOT Len(ARGUMENTS.name)>
			<cfset
			ArrayAppend(
				LOCAL.Response.Errors,
				"Name not Found"
				) />
		</cfif>


		
		<!--- Check if any error is present --->
		<cfif NOT ArrayLen( LOCAL.Response.Errors)>

		<!--- setting default variables --->
			<cfset LOCAL.Item = {} />

		<!--- check if email or mobile number already exists ---->
			<cftry>
				<cfinvoke
					component="Database"
					method="retriveUserEmailMobile"
					returnvariable="userInfo">
					<cfinvokeargument name="email"
									value="#ARGUMENTS.email#" />
					<cfinvokeargument name="mobileNumber"
									value="#ARGUMENTS.mobileNumber#" />
				</cfinvoke>
				<cfset message = "Database user info retrival success." />
				<cfset THIS.log("SUCCESS","User",getFunctionCalledName(),message) />
				<cfcatch>
					<cfset message = "Database user info retrival failed." />
					<cfset THIS.log("ERROR","User",getFunctionCalledName(),message) />
				</cfcatch>
			</cftry>

		<!--- if user info is not available --->
			<cfif userInfo.recordcount gt 0>
				<cfloop query = "#userInfo#">
					<cfif #email# eq ARGUMENTS.email>
						<cfset
							ArrayAppend(
								LOCAL.Response.Errors,
								"Email already Exists"
								) />
					</cfif>
					<cfif #mobileNumber# eq ARGUMENTS.mobileNumber>
						<cfset
							ArrayAppend(
								LOCAL.Response.Errors,
								"Mobile Number already Exists"
								) />
					</cfif>
				</cfloop>
			<cfelse>

			<!--- Call database to write user info --->
				<cftry>
					<cfinvoke
						component="Database"
						method="registerUser"
						returnvariable="userId">

						<cfinvokeargument
							name="email"
							value="#ARGUMENTS.email#" />

						<cfinvokeargument
							name="password"
							value="#ARGUMENTS.password#" />

						<cfinvokeargument
							name="mobileNumber"
							value="#ARGUMENTS.mobileNumber#" />

						<cfinvokeargument
								name="name"
								value="#ARGUMENTS.name#" />
					 </cfinvoke>
					<cfset message = "Database user register success." />
					<cfset THIS.log("SUCCESS","User",getFunctionCalledName(),message) />
					<cfcatch>
						<cfset message = "Database cart insert failed." />
						<cfset THIS.log("ERROR","User",getFunctionCalledName(),message) />
					</cfcatch>
				</cftry>
					 
				<cfif session.isSeller AND ARGUMENTS.company neq "">
						<cfinvoke component="Database"
									method="retrieveSellingCompany"
									returnvariable="sellingCompany">
								<cfinvokeargument name = "companyName"
											value = "#ARGUMENTS.company#" />
						</cfinvoke>

						<cfif sellingCompany.recordcount eq 1>
							<cfloop query = "#sellingCompany#">
								<cfset LOCAL.sellingCompanyId = #sellingCompanyId# />
							</cfloop>
						<cfelse>
							<cfinvoke component="Database"
										method="insertSellingCompany"
										returnvariable="sellingCompanyId">
									<cfinvokeargument name="sellingCompanyName"
												value="#ARGUMENTS.company#" />
									
							</cfinvoke>

							<cfset LOCAL.sellingCompanyId = sellingCompanyId />
						</cfif>

						<cfinvoke component="Database"
									method="insertIntoSeller"
									returnvariable="sellerId">
							<cfinvokeargument name="customerId"
											value="#userId#" />
							<cfinvokeargument name="sellingCompanyId"
											value="#LOCAL.sellingCompanyId#">
						</cfinvoke>
					
				</cfif>
				<cfset LOCAL.Item ={
					name = "#ARGUMENTS.name#",
					email = "#ARGUMENTS.email#",
					mobile = "#ARGUMENTS.mobileNumber#"
					} />

				<cfset LOCAL.Response.Data = LOCAL.Item />
			</cfif>
		</cfif>
		<!--- check if any error is present --->
		<cfif  ArrayLen( LOCAL.Response.Errors)>
			<cfset LOCAL.Response.Success = false />
		</cfif>

		<!--- set return url --->
		<cfset LOCAL.Response.url = "http://www.shopsworld.net/view/login.cfm" />
		<cfset Session.log = "#LOCAL.Response#" />
		<cfreturn LOCAL.Response />

	</cffunction>

<!--- insertAddress() function --->
	<cffunction	name="insertAddress"
				access="public"
				returntype="struct"
				returnformat="json"
				output="false"
				hint =" Insert Address in Table">
		<cfargument
			name="customerId"
			required="true" />
		<cfargument
			name="addressLine1"
			required="true" />
		<cfargument
			name="addressLine2"
			required="false"
			default="" />
		<cfargument
			name="city"
			required="true" />
		<cfargument
			name="state"
			required="true" />
		<cfargument
			name="addressType"
			required="true"/>
		<cfargument
			name="pincode"
			required="true" />

		<!--- Get a new API response --->
		<cfset var LOCAL = {} />

		<!--- Get a new API response --->
		<cfset LOCAL.Response = THIS.GetNewResponse() />

		<!--- Check to see if all the data is defined. --->
		<cfif NOT Len(SESSION.user.userId)>
			<cfset ArrayAppend(
				LOCAL.Response.Errors,
				"No ID Found"
				) />
		</cfif>

		<cfif NOT ArrayLen( LOCAL.Response.Errors)>
		<!--- Setting arguments for database call --->
			<cfset addressDetail={
					customerId = "#SESSION.user.userId#",
					addressLine1 = "#ARGUMENTS.addressLine1#",
					addressLine2 = "#ARGUMENTS.addressLine2#",
					city = "#ARGUMENTS.city#",
					state="#ARGUMENTS.state#",
					addressType = "#ARGUMENTS.addressType#",
					pincode = "#ARGUMENTS.pincode#"
					} />

		<!--- database call to insert address--->
		<cftry>
			<cfinvoke
				component="Database"
				method="insertIntoAddress"
				argumentcollection="#addressDetail#">
			</cfinvoke>
			<cfinvoke
				component="Database"
				method="retrieveAddress"
				returnvariable="address" >
					<cfinvokeargument
						name="customerId"
						value="#session.user.userId#" />
			</cfinvoke>
			<cfset message = "Database address insert success." />
			<cfset THIS.log("SUCCESS","User",getFunctionCalledName(),message) />
			<cfcatch>
				<cfset message = "Database address insert failed." />
				<cfset THIS.log("ERROR","User",getFunctionCalledName(),message) />
			</cfcatch>
		</cftry>
		<cfloop query="#address#">
			<cfset addressDetail.addressId = "#AddressId#" />
			<cfbreak />
		</cfloop>
		<cfset LOCAL.Response.Success = true />
		<cfset Session.address = addressDetail />
		<cfset LOCAL.Response.Data = addressDetail />
		</cfif>

		<cfreturn LOCAL.Response />
	</cffunction>

<!---- updateAddress() function --->
	<cffunction name="updateAddress"
				access="public"
				returntype="struct"
				returnformat="json"
				output="false"
				hint =" Insert Address in Table">
		<cfargument 
			name="addressId"
			required="true" />
		<cfargument
			name="customerId"
			required="true" />
		<cfargument
			name="addressLine1"
			required="true" />
		<cfargument
			name="addressLine2"
			required="false"
			default="" />
		<cfargument
			name="city"
			required="true" />
		<cfargument
			name="state"
			required="true" />
		<cfargument
			name="addressType"
			required="true"/>
		<cfargument
			name="pincode"
			required="true" />

		<!--- Get a new API response --->
		<cfset var LOCAL = {} />

		<!--- Get a new API response --->
		<cfset LOCAL.Response = THIS.GetNewResponse() />

		<!--- Check to see if all the data is defined. --->
		<cfif NOT Len(SESSION.user.userId)>
			<cfset ArrayAppend(
				LOCAL.Response.Errors,
				"No ID Found"
				) />
		</cfif>

		<cfif NOT ArrayLen( LOCAL.Response.Errors)>
		<!--- Setting arguments for database call --->
			<cfset addressDetail={
					addressId = "#ARGUMENTS.addressId#",
					customerId = "#SESSION.user.userId#",
					addressLine1 = "#ARGUMENTS.addressLine1#",
					addressLine2 = "#ARGUMENTS.addressLine2#",
					city = "#ARGUMENTS.city#",
					state="#ARGUMENTS.state#",
					addressType = "#ARGUMENTS.addressType#",
					pincode = "#ARGUMENTS.pincode#"
					} />

		<!--- database call to update address--->
			<cftry>
				<cfinvoke
					component="Database"
					method="updateAddress"
					argumentcollection="#addressDetail#">
				</cfinvoke>
				<cfset message = "Database cart insert success." />
				<cfset THIS.log("SUCCESS","User",getFunctionCalledName(),message) />
				<cfcatch>
					<cfset message = "Database cart insert failed." />
					<cfset THIS.log("ERROR","User",getFunctionCalledName(),message) />
				</cfcatch>
			</cftry>
		<cfset LOCAL.Response.Success = true />
		<cfset Session.address = addressDetail />
		<cfset LOCAL.Response.Data = addressDetail />
		</cfif>

		<cfreturn LOCAL.Response />
	</cffunction>

<!--- retrieveAddress() function --->
	<cffunction name="retrieveAddress"
			access="public"
			returnformat="json"
			returntype="any">

			<cfset customerId = "#SESSION.user.userId#" />

		<!--- retrieval of address from database --->
		 	<cfparam name="address" default="" />
			<cftry>
				<cfinvoke
					component="Database"
					method="retrieveAddress"
					returnvariable="address">
					<cfinvokeargument
							name="customerId"
							value="#customerId#" />
				</cfinvoke>
				<cfset message = "Database address retrieval success." />
				<cfset THIS.log("SUCCESS","User",getFunctionCalledName(),message) />
				<cfcatch>
					<cfset message = "Database address retrieval failed." />
					<cfset THIS.log("ERROR","User",getFunctionCalledName(),message) />
				</cfcatch>
			</cftry>
			<cfreturn address />
	</cffunction>

<!--- removeAddress --->
	<cffunction name="removeAddress"
				access="public"
				returntype="any"
				returnformat="json">
			<cfargument name="addressId"
						required="true"/>


		<!--- Get a new API response --->
		<cfset var LOCAL = {} />

		<!--- Get a new API response --->
		<cfset LOCAL.Response = THIS.GetNewResponse() />

		<!--- Check to see if all the data is defined. --->
		<cfif NOT Len(SESSION.user.userId)>
			<cfset ArrayAppend(
				LOCAL.Response.Errors,
				"No ID Found"
				) />
		</cfif>

		<cfif NOT Len(ARGUMENTS.addressId)>
			<cfset ArrayAppend(
				LOCAL.Response.Errors,
				"No Address ID Found"
				) />
		</cfif>

		<cfif NOT ArrayLen(LOCAL.Response.Errors)>
			<cftry>
				<cfinvoke component="Database"
							method="removeAddress">
						<cfinvokeargument name="addressId"
										value="#ARGUMENTS.addressId#"/>
				</cfinvoke>
				<cfset message = "Database address remove success." />
				<cfset THIS.log("SUCCESS","User",getFunctionCalledName(),message) />
				<cfcatch>
					<cfset message = "Database address remove failed." />
					<cfset THIS.log("ERROR","User",getFunctionCalledName(),message) />
				</cfcatch>
			</cftry>
		</cfif>
		<cfif ArrayLen(LOCAL.Response.Errors)>
			<cfset LOCAL.Response.Success = false />
		</cfif>

		<cfreturn LOCAL.Response/>
	</cffunction>

<!--- retrieveOrderDetails() function --->
	<cffunction name="retrieveOrderDetails"
			access="public"
			returnformat="json"
			returntype="any">
			<cfargument name="orderId"
						required="true" />
			<cfset invoiceDetail=[] />

			<cftry>
				<cfinvoke component="Database"
				method="retrieveSellingCompanyForOrder"
				returnvariable = "sellingCompanyId">
					<cfinvokeargument name="orderId"
								value="#OrderId#" />
				</cfinvoke>
				<cfset message = "Database  selling company Id retrieval success." />
				<cfset THIS.log("SUCCESS","User",getFunctionCalledName(),message) />
				<cfcatch>
					<cfset message = "Database selling Company Id retrieval failed." />
					<cfset THIS.log("ERROR","User",getFunctionCalledName(),message) />
				</cfcatch>
			</cftry>
			
		<!--- retrieve order details for a order id --->
			<cfloop query="sellingCompanyId">
				<cftry>
					<cfinvoke component="Database"
							method="retrieveOrderDetails"
							returnvariable="orderDetails">

						<cfinvokeargument name="userId"
								value="#SESSION.user.userId#"/>

						<cfinvokeargument name="orderId"
								value="#orderId#" />

						<cfinvokeargument name="sellingCompanyId"
								value="#sellingCompanyId#" />
					</cfinvoke>
					<cfset message = "Database odrer details retrieval successfull." />
					<cfset THIS.log("SUCCESS","User",getFunctionCalledName(),message) />
					<cfcatch>
						<cfset message = "Database order details retrieval failed." />
						<cfset THIS.log("ERROR","User",getFunctionCalledName(),message) />
					</cfcatch>
				</cftry>
				<cfset arrayAppend(invoiceDetail,orderDetails) />
			</cfloop>

			<cfreturn invoiceDetail />
	</cffunction>

<!--- retrieve orderHistory --->
	<cffunction name="retrieveOrderHistory"
			access="public"
			returnformat="json"
			returntype="any">
		<cfset userId = session.user.userId />

		<cftry>
			<cfinvoke component="Database"
						method="retrieveOrderHistory"
						returnvariable="orderHistory">
					<cfinvokeargument name="userId"
								value="#userId#" />
			</cfinvoke>
			<cfset message = "Database order history retrieval success." />
			<cfset THIS.log("SUCCESS","User",getFunctionCalledName(),message) />
			<cfcatch>
				<cfset message = "Database order history retrieval failure." />
				<cfset THIS.log("ERROR","User",getFunctionCalledName(),message) />
			</cfcatch>
		</cftry>
			
		<cfreturn orderHistory />
	</cffunction>

<!--- retrieveOrderHistoryDetail --->
	<cffunction name="retrieveOrderHistoryDetail"
				access="public"
				returnformat="json"
				returntype="any">

			<cfargument name="orderId"
					required="true" />

			<cftry>
				<cfinvoke component="Database"
							method="retrieveOrderHistoryDetail"
							returnvariable="orderItems">
						<cfinvokeargument name="orderId"
										value="#ARGUMENTS.orderid#" />
				</cfinvoke>
				<cfset message = "Database order history detail retrieval success." />
				<cfset THIS.log("SUCCESS","User",getFunctionCalledName(),message) />
				<cfcatch>
					<cfset message = "Database order history detail retrieval failure." />
					<cfset THIS.log("ERROR","User",getFunctionCalledName(),message) />
				</cfcatch>
			</cftry>	
			<cfreturn orderItems />
	</cffunction>

<!--- retrieveUserInformation --->
	<cffunction name="retrieveUserInformation"
				access="public"
				returnformat="json"
				returntype="any">
			<cfargument name="userId"
						required="false"
						default="#Session.user.userId#" />

			<cftry>
				<cfinvoke component="Database"
							method="retrieveUserInformation"
							returnvariable="userInformation">
					<cfinvokeargument name="userId"
									value="#ARGUMENTS.userId#" />
				</cfinvoke>
				<cfset message = "Database user information retrieval success." />
				<cfset THIS.log("SUCCESS","User",getFunctionCalledName(),message) />
				<cfcatch>
					<cfset message = "Database user information retrieval failure." />
					<cfset THIS.log("ERROR","User",getFunctionCalledName(),message) />
				</cfcatch>
			</cftry>
			<cfreturn userInformation />
	</cffunction>


<!--- updateUserProfilePicture --->
	<cffunction name="updateUserProfilePicture"
				access="public"
				returnformat="json"
				returntype="any">

		<cfargument name="formData"
					required="true"/>

	<!--- Get a new API response --->
		<cfset var LOCAL = {} />

		<!--- Get a new API response --->
		<cfset LOCAL.Response = THIS.GetNewResponse() />

		<!--- Check to see if all the data is defined. --->
		<cfif NOT Len(SESSION.user.userId)>
			<cfset ArrayAppend(
				LOCAL.Response.Errors,
				"No ID Found"
				) />
		</cfif>
		<cfset session.form="#ARGUMENTS.formData#">
		<cfif len(trim(ARGUMENTS.formData))>
			<cfset ArrayAppend(
				LOCAL.Response.Errors,
				"File size is 0"
				) />
		</cfif>

	<!--- check if any error is present --->	
		<cfif NOT ArrayLen( LOCAL.Response.Errors)>
			<cftry>
				<cfinvoke component="Database"
					method="updateUserProfilePicture">
					<cfinvokeargument name="pictureLocation"
								value= "#arguments.formData#" />
					<cfinvokeargument name="userId"
								value="#session.user.userId#" />
				</cfinvoke>
				<cfset message = "Database profile picture update success." />
				<cfset THIS.log("SUCCESS","User",getFunctionCalledName(),message) />
				<cfcatch>
					<cfset message = "Database failed to update profile picture." />
					<cfset THIS.log("ERROR","User",getFunctionCalledName(),message) />
				</cfcatch>
			</cftry>
		</cfif>		

		<cfif ArrayLen( LOCAL.Response.Errors)>
			<cfset LOCAL.Response.Success = false />
		</cfif>

		<cfreturn LOCAL.Response />
	</cffunction>


</cfcomponent>


