<cfparam name="search" default=""/>
<cfset columnCount = 1 />
<cfinvoke component="controller.Controller"
			method="searchSuggestion"
			returnvariable="searchItems">

		<cfinvokeargument name="searchItem"
						value="#search#">
</cfinvoke>

<cfinclude template="header.cfm"/>
<body>
	<cfinclude template="menubar.cfm"/>
	<div class="row">
		<div class="col-md-2">
			<cfinclude template="search-filter.cfm" />
		</div>

		<div class="col-md-10">
			<cfloop array="#searchItems.DATA#" index="product">
				<cfif columnCount eq 1>
			<div class="row">
		</cfif>
			<div class="col col-md-3">
				<cfoutput>
					<a href="productDetail.cfm?product=#product.ProductId#">
						<div id="#product.ProductId#" class="product">
						<img class="productDetailImage" src="/assets/#product.ProductImageLocation#" alt="#product.ProductName#"></br>
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
		</div>

	</div>
</body>
<cfinclude template="footer.cfm"/>

