<!---
  --- Seller
  --- -----
  ---
  --- author: mindfire
  --- date:   3/17/17
  --->
<cfcomponent extends="BaseAPI"
		accessors="true"
		output="false"
		persistent="false">

<!--- funtion to retrieve Product Category List --->
	<cffunction name="retrieveProductCategory"
				access="public"
				returnformat="json"
				returntype="query"
				hint="Retrieve Product Category List">

			<cfparam name="ProductCategory" default="" />
			<cftry>
				<cfinvoke component="Database"
							method="retrieveProductCategory"
							returnvariable="ProductCategory">
				</cfinvoke>
				<cfset message = "Product Category data retrieved from database." />
				<cfset THIS.log("SUCCESS","Seller",getFunctionCalledName(),message) />
				<cfcatch type="database">
					<cfset message = "Failed to retrieve Product Category data from database." />
					<cfset THIS.log("ERROR","Seller",getFunctionCalledName(),message) />
					<cfrethrow/>
				</cfcatch>
				<cfcatch type="any">
					<cfset message = "Unknown Error Occured." />
					<cfset THIS.log("ERROR","Seller",getFunctionCalledName(),message) />
					<cfrethrow />
				</cfcatch>
			</cftry>
		<cfreturn ProductCategory/>
	</cffunction>

<!--- function to retrieve Product Sub Category list --->
	<cffunction name="retrieveProductSubCategory"
				access="public"
				returnformat="json"
				returntype="query"
				hint="Retrieve Product Sub Category List">
		<cfargument name="productCategoryId"
					required="true"/>
		<cfparam name="ProductSubCategory" default="" />
		<cftry>			
			<cfinvoke component="Database"
						method="retrieveProductSubCategory"
						returnvariable="ProductSubCategory">

					<cfinvokeargument name="productCategoryId"
									value="#ARGUMENTS.productCategoryId#"/>
			</cfinvoke>
			<cfset message = "Product Sub Category data retrieved from database" />
			<cfset THIS.log("SUCCESS","Seller",getFunctionCalledName(),message) />
			<cfcatch type="database">
				<cfset message = "Failed to retrieve Product Sub Category data from database" />
				<cfset THIS.log("ERROR","Seller",getFunctionCalledName(),message) />
			</cfcatch>
			<cfcatch type="any">
				<cfset message = "Unknown Error Occured." />
				<cfset THIS.log("ERROR","Seller",getFunctionCalledName(),message) />
			</cfcatch>
		</cftry>
		<cfreturn  ProductSubCategory/>
	</cffunction>

<!--- function to insert Product --->
	<cffunction name="insertProduct"
			access="public"
			returnformat="json"
			returntype="struct"
			hint="Insert's Product in the Database.">
			<cfargument name="productName"
						required ="true"/>
			<cfargument name="productCategoryId"
						required = "true"/>
			<cfargument name="productSubCategoryId"
						required = "true"/>
			<cfargument name="productBrand"
						required="true"/>
			<cfargument name="productDescription"
						required="false"
						default="" />
			<cfargument name="productImageLocation"
						required="false"
						default="assets/images/product/"/>
			<cfargument name="leastPrice"
						required="true"/>

			<!--- Get a new API response --->
			<cfset var LOCAL = {} />

			<!--- Get a new API response --->
			<cfset LOCAL.Response = THIS.GetNewResponse() />
			<cfset LOCAL.Response.Data = {} />
			<cfif NOT LEN(ARGUMENTS.productName)>
				<cfset arrayAppend(LOCAL.Response.Errors,
							"ProductName Required") />
			</cfif>
			<cfif NOT LEN(ARGUMENTS.productCategoryId)>
				<cfset arrayAppend(LOCAL.Response.Errors,
							"Product Category Required") />
			</cfif>
			<cfif NOT LEN(ARGUMENTS.productSubCategoryId)>
				<cfset arrayAppend(LOCAL.Response.Errors,
							"Prduct SubCategory Required") />
			</cfif>
			<cfif NOT LEN(ARGUMENTS.productBrand)>
				<cfset arrayAppend(LOCAL.Response.Errors,
							"Product Brand Required") />
			</cfif>
			<cfif NOT LEN(ARGUMENTS.productDescription)>
				<cfset arrayAppend(LOCAL.Response.Errors,
							"Product Description Required") />
			</cfif>
			<cfset args={
					productName = ARGUMENTS.productName,
					productCategoryId=ARGUMENTS.productCategoryId,
					productSubCategoryId= ARGUMENTS.productSubCategoryId,
					productBrand = ARGUMENTS.productBrand,
					productDescription = ARGUMENTS.productDescription,
					productImageLocation = ARGUMENTS.productImageLocation,
					leastPrice = ARGUMENTS.leastPrice
					} />

		
		    <cfif NOT arrayLen(LOCAL.Response.Errors)>
				<cftry>
					<cfinvoke component="Database"
								method="insertProduct"
								argumentcollection="#args#"
								returnvariable="productId">
					</cfinvoke>

					<cfset LOCAL.Item = {
							productId = "#productId#",
							productName = ARGUMENTS.productName,
							productCategoryId=ARGUMENTS.productCategoryId,
							productSubCategoryId= ARGUMENTS.productSubCategoryId,
							productBrand = ARGUMENTS.productBrand,
							productDescription = ARGUMENTS.productDescription,
							productImageLocation = "#ARGUMENTS.productImageLocation##productId#",
							leastPrice = ARGUMENTS.leastPrice
						}>
					<cfset LOCAL.Response.Data = LOCAL.Item />
					<cfset message = "Product #ARGUMENTS.productName# inserted in database by #session.user.userName#
									[User ID : #session.user.userId#]." />
					<cfset THIS.log("SUCCESS","Seller",getFunctionCalledName(),message) />
					<!--- Catch database error --->
					<cfcatch type = "database">
						<cfset message = "Failed to insert Product #ARGUMENTS.productName# in database by #session.user.userName#
									[User ID : #session.user.userId#]." />
						<cfset THIS.log("ERROR","Seller",getFunctionCalledName(),message) />
						<cfrethrow/>
					</cfcatch>
					<!---- Catch other error --->
					<cfcatch type="any">
						<cfset message = "Unknown Error Occured." />
						<cfset THIS.log("ERROR","Seller",getFunctionCalledName(),message) />
						<cfrethrow />
					</cfcatch>
				</cftry>		
		    </cfif>	
		<cfreturn LOCAL.Response.Data />

	</cffunction>

<!--- function to Update Product In Inventory --->
	<cffunction name="updateProductInInventory"
			access="public"
			returntype="struct"
			returnformat="json"
			hint="Update's Product In Inventory for a seller">
			<cfargument name="sellingPrice"
						required="true" />
			<cfargument name="quantity"
						required="true" />
			<cfargument name="discount"
						required="true" />	
			<cfargument name="inventoryId"
						required="true" />
		
		<!--- Get a new API response --->
		<cfset var LOCAL = {} />

		<!--- Get a new API response --->
		<cfset LOCAL.Response = THIS.GetNewResponse() />

		<cfif NOT Len(ARGUMENTS.sellingPrice)>
			<cfset arrayAppend(LOCAL.Response.errors,
						"Selling Price value Required") />
		</cfif>		
		<cfif NOT Len(ARGUMENTS.quantity)>
			<cfset arrayAppend(LOCAL.Response.errors,
						"Quantity value Required") />
		</cfif>
		<cfif NOT arrayLen(LOCAL.Response.Errors)>
			<cftry>
				<cfinvoke component="Database"
							method="updateProductInInventory"
							returnvariable="updateProducts">
						<cfinvokeargument name="inventoryId"
											value="#ARGUMENTS.inventoryId#" />
						<cfinvokeargument name="sellingPrice"
											value="#ARGUMENTS.sellingPrice#" />
						<cfinvokeargument name="quantity"
											value="#ARGUMENTS.quantity#" />
						<cfinvokeargument name="discount"
											value="#ARGUMENTS.discount#" />
				</cfinvoke>
				<cfset message = "Product [Inventory ID : #ARGUMENTS.inventoryId#] updated in database by #session.user.userName#
									[User ID : #session.user.userId#]." />
				<cfset THIS.log("SUCCESS","Seller",getFunctionCalledName(),message) />
				<cfcatch type="database">
					<cfset message = "Failed to Update Product [Inventory ID : #ARGUMENTS.inventoryId#] in database by #session.user.userName#
									[User ID : #session.user.userId#]." />
					<cfset THIS.log("ERROR","Seller",getFunctionCalledName(),message) />
				</cfcatch>
				<cfcatch type="any">
					<cfset message = "Unknown Error Occurred." />
					<cfset THIS.log("ERROR","Seller",getFunctionCalledName(),message) />
				</cfcatch>
			</cftry>
		</cfif>		

		<cfreturn LOCAL.Response/>
	</cffunction>

<!--- deleteProductFromInventory --->
	<cffunction name="deleteProductFromInventory"
			access="public"
			returnformat="json"
			returntype="struct">
		
		<cfargument name="inventoryId"
					required="true" />
		<!--- Get a new API response --->
		<cfset var LOCAL = {} />

		<!--- Get a new API response --->
		<cfset LOCAL.Response = THIS.GetNewResponse() />
		
		<cftry>
			<cfinvoke component="Database"
					method="deleteProductFromInventory">
					<cfinvokeargument name="inventoryId"
								value="#ARGUMENTS.inventoryId#"/>
			</cfinvoke>
			<cfset message = "Product [Inventory ID : #ARGUMENTS.inventoryId#] deleted in database by #session.user.userName#
								[User ID : #session.user.userId#]." />
			<cfset THIS.log("SUCCESS","Seller",getFunctionCalledName(),message) />
			<cfcatch type="database">
				<cfset message = "Failed to Delete Product [Inventory ID : #ARGUMENTS.inventoryId#] in database by #session.user.userName#
								[User ID : #session.user.userId#]." />
				<cfset THIS.log("ERROR","Seller",getFunctionCalledName(),message) />
			</cfcatch>
			<cfcatch type="any">
				<cfset message = "Unknown Error Occurred." />
				<cfset THIS.log("ERROR","Seller",getFunctionCalledName(),message) />
			</cfcatch>
		</cftry>
		<cfreturn LOCAL.Response />
	</cffunction>

<!---- insertProductInInventory --->
	<cffunction name="insertProductInInventory"
				access="public"
				returntype="struct"
				returnformat="json"
				hint="Insert Product data in inventory for seller.">

		<cfargument name="productId"
					required="true" />
		<cfargument name="availableQuantity"
					required="true" />
		<cfargument name="sellingPrice"
					required="true" />
		<cfargument name="discount"
					required="true" />
		<cfset sellingCompanyId= session.user.sellingCompanyId />
		

		<cfset var LOCAL = {} />

		<!--- Get a new API response --->
		<cfset LOCAL.Response = THIS.GetNewResponse() />
		<cfset LOCAL.Response.Data = {} />
		<cfif NOT LEN(ARGUMENTS.productId)>
			<cfset arrayAppend(LOCAL.Response.Errors,
					"Product ID not found") />
		</cfif>
		<cfif NOT LEN(ARGUMENTS.availableQuantity)>
			<cfset arrayAppend(LOCAL.Response.Errors,
					"Quantity not found") />
		</cfif>
		<cfif NOT LEN(ARGUMENTS.sellingPrice)>
			<cfset arrayAppend(LOCAL.Response.Errors,
					"Selling Price not found") />
		</cfif>
		<cfif NOT LEN(ARGUMENTS.discount)>
			<cfset ARGUMENTS.discount = 0 />
		</cfif>
		<cfset args = {
			sellingCompanyId = sellingCompanyId,
			productId = ARGUMENTS.productId,
			availableQuantity = ARGUMENTS.availableQuantity,
			sellingPrice = ARGUMENTS.sellingPrice,
			discount = ARGUMENTS.discount
		} />
		<cftry>
			<cfinvoke component="Database"
						method="insertProductInInventory"
						returnvariable="inventoryItem"
						argumentcollection="#args#">
			</cfinvoke>

			<cfset LOCAL.Item ={
					inventoryId = inventoryItem,
					sellingCompanyId = sellingCompanyId,
					productId = ARGUMENTS.productId,
					availableQuantity = ARGUMENTS.availableQuantity,
					sellingPrice = ARGUMENTS.sellingPrice,
					discount = ARGUMENTS.discount
			} />
			<cfset LOCAL.Response.Data = LOCAL.Item />
			<cfset message = "Product [Inventory ID : #ARGUMENTS.inventoryId#] inserted in database Inventory by #session.user.userName#
									[User ID : #session.user.userId#]." />
			<cfset THIS.log("SUCCESS","Seller",getFunctionCalledName(),message) />
			<cfcatch type="database">
				<cfset message = "Failed to insert Product [Inventory ID : #ARGUMENTS.inventoryId#] in database Inventory by #session.user.userName#
								[User ID : #session.user.userId#]." />
				<cfset THIS.log("ERROR","Seller",getFunctionCalledName(),message) />
			</cfcatch>
			<cfcatch type="any">
				<cfset message = "Unknown Error Occurred." />
				<cfset THIS.log("ERROR","Seller",getFunctionCalledName(),message) />
			</cfcatch>
		</cftry>
		<cfreturn LOCAL.Response.Data />
	</cffunction>

<!--- function to insert Product Category in database --->
	<cffunction name="insertProductCategory"
			access="public"
			returntype="struct"
			returnformat="json"
			hint="Insert Product Category in Database.">
		<cfargument name="categoryName"
					required="true" />

		<cfset var LOCAL = {} />

		<!--- Get a new API response --->
		<cfset LOCAL.Response = THIS.GetNewResponse() />

		<cftry>
			<cfinvoke component="Database"
						method="insertProductCategory"
						returnvariable="productCategoryId">
				<cfinvokeargument name="categoryName"
							value="#ARGUMENTS.categoryName#"/>
			</cfinvoke>	
			<cfset LOCAL.item = {
				ProductCategory = ARGUMENTS.categoryName,
				ProductCategoryId = '#productCategoryId#'
			} />
			<cfset LOCAL.Response.data = LOCAL.item />
			<cfset message = "Product Category [ID : #productCategoryId#] inserted in database by Seller #session.user.userName#
									[User ID : #session.user.userId#]." />
			<cfset THIS.log("SUCCESS","Seller",getFunctionCalledName(),message) />
			<cfcatch type="database">
				<cfset message = "Failed to insert Product Category in database by Seller #session.user.userName#
								[User ID : #session.user.userId#]." />
				<cfset THIS.log("ERROR","Seller",getFunctionCalledName(),message) />
			</cfcatch>
			<cfcatch type="any">
				<cfset message = "Unknown Error Occurred." />
				<cfset THIS.log("ERROR","Seller",getFunctionCalledName(),message) />
			</cfcatch>
		</cftry>		
		<cfreturn LOCAL.Response />
	</cffunction>

<!--- insert Product Sub Category --->
	<cffunction name="insertProductSubCategory"
			access="public"
			returntype="struct"
			returnformat="json"
			hint="Inset Product Sub Category in Database.">

		<cfargument name="categoryName"
					required="true" />
		<cfargument name="subCategoryName"
					required="true" />		
		<cfset var LOCAL = {} />

		<!--- Get a new API response --->
		<cfset LOCAL.Response = THIS.GetNewResponse() />
		<cftry>
			<cfinvoke component="Database"
						method="insertProductSubCategory"
						returnvariable="productSubCategoryId">
				<cfinvokeargument name="categoryId"
							value="#ARGUMENTS.categoryName#"/>
				<cfinvokeargument name="subCategoryName"
							value="#ARGUMENTS.subCategoryName#" />
			</cfinvoke>	
			<cfset LOCAL.item = {
				ProductSubCategoryName = ARGUMENTS.subCategoryName,
				ProductCategoryId = ARGUMENTS.categoryName,
				ProductSubCategoryId = '#productSubCategoryId#'
			} />
			<cfset LOCAL.Response.data = LOCAL.item />		
			<cfset message = "Product Sub Category [ID : #productSubCategoryId#] inserted in database by #session.user.userName#
									[User ID : #session.user.userId#]." />
				<cfset THIS.log("SUCCESS","Seller",getFunctionCalledName(),message) />
				<cfcatch type="database">
					<cfset message = "Failed to insert Product Sub Category in database by #session.user.userName#
									[User ID : #session.user.userId#]." />
					<cfset THIS.log("ERROR","Seller",getFunctionCalledName(),message) />
				</cfcatch>
				<cfcatch type="any">
					<cfset message = "Unknown Error Occurred." />
					<cfset THIS.log("ERROR","Seller",getFunctionCalledName(),message) />
				</cfcatch>
		</cftry>
		<cfreturn LOCAL.Response />
	</cffunction>

<!--- search Product for seller --->
	<cffunction name="sellerSearchProducts"
				access="public"
				returnformat="json"
				returntype="any">
			<cfargument name="searchValue"
					required="true" />
			
			<cftry>
				<cfinvoke component="Database"
						method="sellerSearchProducts"
						returnvariable="products">
					<cfinvokeargument name="searchValue"
								value="#ARGUMENTS.searchValue#" />	
				</cfinvoke>
				<cfset message = "Search by Seller #session.user.userName#
									[User ID : #session.user.userId#] successfull." />
				<cfset THIS.log("SUCCESS","Seller",getFunctionCalledName(),message) />
				<cfcatch type="database">
					<cfset message = "Search failed by Seller #session.user.userName#
									[User ID : #session.user.userId#]." />
					<cfset THIS.log("ERROR","Seller",getFunctionCalledName(),message) />
				</cfcatch>
				<cfcatch type="any">
					<cfset message = "Unknown Error Occurred." />
					<cfset THIS.log("ERROR","Seller",getFunctionCalledName(),message) />
				</cfcatch>
			</cftry>
			<cfreturn products />					

	</cffunction>

<cffunction name="insertSellerAndShipping">

</cffunction>

<cffunction name="deleteSellerAndShipping">
</cffunction>

<cffunction name="updateSellerAndShipping">
</cffunction>

<cffunction name="insertSellerDetail"
		access="public">
</cffunction>

</cfcomponent>