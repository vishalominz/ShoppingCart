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

<cffunction name="insertSellerDetail"
		access="public">

</cffunction>

<cffunction name="retrieveProductCategory"
			access="public"
			returnformat="json"
			returntype="any">

		<cfinvoke component="Database"
					method="retrieveProductCategory"
					returnvariable="ProductCategory">
		</cfinvoke>
	<cfreturn ProductCategory/>
</cffunction>

<cffunction name="retrieveProductSubCategory"
			access="public"
			returnformat="json"
			returntype="any">
	<cfargument name="productCategoryId"
				required="true"/>

	<cfinvoke component="Database"
					method="retrieveProductSubCategory"
					returnvariable="ProductSubCategory">

				<cfinvokeargument name="productCategoryId"
								value="#ARGUMENTS.productCategoryId#"/>
	</cfinvoke>
	<cfreturn  ProductSubCategory/>
</cffunction>


<cffunction name="insertProduct"
			access="remote"
			returnformat="json"
			returntype="any">
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
			<cfset args={
					productName = ARGUMENTS.productName,
					productCategoryId=ARGUMENTS.productCategoryId,
					productSubCategoryId= ARGUMENTS.productSubCategoryId,
					productBrand = ARGUMENTS.productBrand,
					productDescription = ARGUMENTS.productDescription,
					productImageLocation = ARGUMENTS.productImageLocation,
					leastPrice = ARGUMENTS.leastPrice
					} />

		<!--- Get a new API response --->
		<cfset var LOCAL = {} />

		<!--- Get a new API response --->
		<cfset LOCAL.Response = THIS.GetNewResponse() />

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

		<cfreturn LOCAL.Response.Data />

</cffunction>

<!--- updateProductInInventory --->
<cffunction name="updateProductInInventory"
			access="public"
			returntype="any"
			returnformat="json">
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

		<cfif NOT Len(sellingPrice)>
			arrayAppend(LOCAL.Response.errors,
						"No selling Price");
		</cfif>		
		<cfif NOT arrayLen(LOCAL.Response.Errors)>
									
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
		</cfif>		

		<cfreturn LOCAL.Response/>
</cffunction>

<!--- deleteProductFromInventory --->
<cffunction name="deleteProductFromInventory"
			access="public"
			returnformat="json"
			returntype="any">
		<cfargument name="inventoryId"
					required="true" />

		<!--- Get a new API response --->
		<cfset var LOCAL = {} />

		<!--- Get a new API response --->
		<cfset LOCAL.Response = THIS.GetNewResponse() />

		<cfinvoke component="Database"
					method="deleteProductFromInventory">
				<cfinvokeargument name="inventoryId"
								value="#ARGUMENTS.inventoryId#"/>
		</cfinvoke>

		<cfreturn LOCAL.Response />
</cffunction>

<cffunction name="insertProductCategory">

</cffunction>

<cffunction name="insertProductSubCategory">

</cffunction>

<cffunction name="insertSellerAndShipping">

</cffunction>

<cffunction name="deleteSellerAndShipping">
</cffunction>

<cffunction name="updateSellerAndShipping">
</cffunction>

</cfcomponent>