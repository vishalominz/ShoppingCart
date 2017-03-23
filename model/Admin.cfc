<!---
  --- Admin
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
						default="/images/product/default.jpg"/>
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

			<cfinvoke component="Database"
						method="insertProduct"
						argumentcollection="#args#">
			</cfinvoke>
</cffunction>


<cffunction name="updateInventory"
			access="public">

</cffunction>

<cffunction name="deleteProduct">


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