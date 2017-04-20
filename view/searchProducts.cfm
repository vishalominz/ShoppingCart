<cfparam name="search" default=""/>
<cfparam name="brandList" default=""/>
<cfparam name="minPrice" default=0 />
<cfparam name="maxPrice" default=100000 />
<cfset columnCount = 1 />
<cfinvoke component="controller.Controller"
			method="searchSuggestion"
			returnvariable="searchItems">

		<cfinvokeargument name="searchItem"
						value="#search#" />
		<cfinvokeargument name="brandList"
						value="#URLDecode(brandList)#" />
		<cfinvokeargument name="minPrice"
						value="#minPrice#" />
		<cfinvokeargument name="maxPrice"
						value="#maxPrice#"	/>		
</cfinvoke>

<cfif arrayLen(#searchItems.DATA#)>		
	<cfloop array="#searchItems.DATA#" index="product">
		<cfif columnCount eq 1>
			<div class="row">
		</cfif>
			<div class="col col-md-3">
				<cfoutput>
					<a href="productDetail.cfm?product=#product.ProductId#">
						<div id="#product.ProductId#" class="product">
						<img class="productDetailImage" src="/#product.ProductImageLocation#/default.jpg" alt="#product.ProductName# image not found" onerror="this.onerror=null;this.src='/assets/images/product/default.jpg';"></br>
						<p>#product.ProductName#</p>
						<p>#product.ProductBrand#</p>
						<p>Selling Price : #NumberFormat(product.ProductSellingPrice,'9,99')#</p>
						<cfif product.DiscountPercent neq "NULL" AND product.DiscountPercent neq 0>
							<p>Discount : #product.DiscountPercent#</p>
							<p>DiscoutPrice : #NumberFormat(product.DiscountPrice,'9,99')#</p>
						</cfif>
						</div>
					</a>
				</cfoutput>
			</div>
			<cfset columnCount = columnCount + 1 />
		<cfif columnCount eq 5>
			</div>
			<cfset columnCount = 1 />
		</cfif>


	</cfloop>
<cfelse>
	<p class="alert alert-info"> No Product Found </p>	
</cfif>
