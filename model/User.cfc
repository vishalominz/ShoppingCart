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
			<cfelse>
				<cfset session.isSeller = true />
				<cfset link="http://www.shopsworld.net/view/login.cfm">
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
								<cfset product = {
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
								<cfset arrayAppend(session.cart,product) />
							</cfloop>
						</cfif>
					</cfif>
			<!--- else when user is not present --->
				<cfelse>
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
			<cfinvoke
				component="Database"
				method="retrieveCart"
				returnvariable="cart">

				<cfinvokeargument name="customerId"
						value="#SESSION.user.userId#" />
			</cfinvoke>

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
				<cfinvoke
					component="Database"
					method="insertCart"
					returnvariable="cart">

					<cfinvokeargument name="customerId"
							value="#SESSION.user.userId#" />
				</cfinvoke>

			<!--- retrieve cart Id --->
				<cfinvoke
					component="Database"
					method="retrieveCart"
					returnvariable="cart">

					<cfinvokeargument name="customerId"
							value="#SESSION.user.userId#" />
				</cfinvoke>

				<cfquery name="cart">
					<cfset cartId = #cartId# />
					<cfbreak />
				</cfquery>

			</cfif>

		<!--- delete cart items --->
				<cfinvoke
					component="Database"
					method="removeCartDetail"
					returnvariable="cartItems">

					<cfinvokeargument name="cartId"
							value="#cartId#" />
				</cfinvoke>


		<!--- loop through cart and insert in database ---->
			<cfloop from="1" to="#ArrayLen(SESSION.cart)#" index="location">
				<cfset cartItem = {
						cartId="#cartId#",
						inventoryId = "#SESSION.cart[location].inventoryId#",
						quantity = "#SESSION.cart[location].productCount#"
						} />
			<!--- write cart items to database --->
				<cfinvoke
					component="Database"
					method="insertCardDetail"
					argumentcollection="#cartItem#"
					returnvariable="cartItem">
				</cfinvoke>

			</cfloop>
		</cfif>

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
				hint="Email ID of the user" />

			<cfargument
				name="email"
				type="string"
				required="true"
				hint="Password of the user" />

			<cfargument
				name="password"
				type="string"
				required="true"
				hint="Email ID of the user" />

			<cfargument
				name="mobileNumber"
				type="numeric"
				required="true"
				hint="Password of the user" />


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

		<!--- Call database to write user info --->
			<cfinvoke
				component="Database"
				method="registerUser"
				returnvariable="userInfo">

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

			<cfset LOCAL.Item ={
				name = "#ARGUMENTS.name#",
				email = "#ARGUMENTS.email#",
				mobile = "#ARGUMENTS.mobileNumber#"
				} />
			<cfset LOCAL.Response.Data = LOCAL.Item />
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

		<!--- database call --->
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


<!--- retrieveAddress() function --->
	<cffunction name="retrieveAddress"
			access="public"
			returnformat="json"
			returntype="any">

			<cfset customerId = "#SESSION.user.userId#" />

			<cfinvoke
				component="Database"
				method="retrieveAddress"
				returnvariable="address">

				<cfinvokeargument
						name="customerId"
						value="#customerId#" />
			</cfinvoke>

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
			<cfinvoke component="Database"
						method="removeAddress">
					<cfinvokeargument name="addressId"
									value="#ARGUMENTS.addressId#"/>
			</cfinvoke>
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

			<cfset invoiceDetail=[] />

			<cfinvoke component="Database"
					method="retrieveOrderId"
					returnvariable="order">
					<cfinvokeargument name="customerId"
						value="#session.user.userId#"/>
			</cfinvoke>
			<cfloop query="#order#">
				<cfset orderId="#OrderId#" />
				<cfbreak />
			</cfloop>

			<cfinvoke component="Database"
			method="retrieveSellingCompanyForOrder"
			returnvariable = "sellingCompanyId">
				<cfinvokeargument name="orderId"
							value="#OrderId#" />
			</cfinvoke>


		<!--- retrieve order details for a order id --->
			<cfloop query="sellingCompanyId">

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

		<cfinvoke component="Database"
					method="retrieveOrderHistory"
					returnvariable="orderHistory">
				<cfinvokeargument name="userId"
							value="#userId#" />
		</cfinvoke>

		<cfreturn orderHistory />
	</cffunction>


<!--- retrieveOrderHistoryDetail --->
	<cffunction name="retrieveOrderHistoryDetail"
				access="public"
				returnformat="json"
				returntype="any">

			<cfargument name="orderId"
					required="true" />

			<cfinvoke component="Database"
						method="retrieveOrderHistoryDetail"
						returnvariable="orderItems">
					<cfinvokeargument name="orderId"
									value="#ARGUMENTS.orderid#" />
			</cfinvoke>

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

			<cfinvoke component="Database"
						method="retrieveUserInformation"
						returnvariable="userInformation">
				<cfinvokeargument name="userId"
								value="#ARGUMENTS.userId#" />
			</cfinvoke>
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
		<cfset destination = "/assets/images/Profile/#Session.user.userId#.jpg" />
		<cfif NOT ArrayLen( LOCAL.Response.Errors)>
		<!--- Setting arguments for database call --->
			  <cffile action="upload"
			  			destination= "#destination#"
			  			fileField="#ARGUMENTS.formData#">

		<!--- database call --->
			<cfinvoke component="Database"
					method="updateUserProfilePicture">
					<cfinvokeargument name="pictureLocation"
								value= "#destination#" />
			</cfinvoke>

			<cfset LOCAL.Response.url = destination />
		</cfif>

		<cfif ArrayLen( LOCAL.Response.Errors)>
			<cfset LOCAL.Response.Success = false />
		</cfif>

		<cfreturn LOCAL.Response />
	</cffunction>


</cfcomponent>


