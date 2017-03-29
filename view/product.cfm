<cfinclude template="header.cfm" />
<cfinclude template="menubar.cfm" />
<cfparam name="productType" default="" />
<cfinvoke
	component="controller.controller"
	method="retrieveProductBySubCategory"
	returnvariable="products">
	<cfinvokeargument
					name="productSubCategoryId"
					value="#productType#">
</cfinvoke>
<cfset columnCount = 1 />
<div class="container-fluid">
	<cfif !products.recordCount>
		<p>Currently no items are available.
		   Please come back later.
		</p>
	</cfif>
	<cfloop query="#products#">
		<cfif columnCount eq 1>
			<div class="row">
		</cfif>
			<div class="col col-md-3">
				<cfoutput>
					<a href="productDetail.cfm?product=#ProductId#">
						<div id="#ProductId#" class="product">
						<img class="productDetailImage" src="/#ProductImageLocation#/default.jpg" alt="#ProductName#"></br>
						<p>#ProductName#</p>
						<p>#ProductBrand#</p>
						<p>Selling Price : #NumberFormat(SellingPrice,'9,99')#</p>
						<cfif DiscountPercent neq "NULL" AND DiscountPercent neq 0>
							<p>Discount : #DiscountPercent#</p>
							<p>DiscoutPrice : #NumberFormat(DiscountPrice,'9,99')#</p>
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

<cfinclude template="footer.cfm" />