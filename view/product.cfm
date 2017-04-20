<cfinclude template="header.cfm" />
<cfinclude template="menubar.cfm" />
<cfparam name="URL.productType" default="" />
<cfparam name="LOCAL.productId" default=0 />
<cfinvoke
	component="controller.controller"
	method="retrieveProductBySubCategory"
	returnvariable="products">
	<cfinvokeargument
					name="productSubCategoryId"
					value="#URL.productType#">
</cfinvoke>
<cfset columnCount = 1 />

	<cfif !products.recordCount>
		<p class="alert alert-info">Currently no items are available.
		   Please come back later.
		</p>
	</cfif>
	<cfloop query="#products#">
		<cfif columnCount eq 1>
			<div class="row">
		</cfif>
			<cfif LOCAL.productId neq #ProductId#>	
				<div class="col col-lg-3">
					<cfoutput>
						<a href="productDetail.cfm?product=#ProductId#">
							<div id="#ProductId#" class="product">
							<img class="productDetailImage" src="/#ProductImageLocation#/default.jpg" alt="Image not found" onerror="this.onerror=null;this.src='/assets/images/product/default.jpg';"></br>
							<p>#ProductName#</p>
							<p>#ProductBrand#</p>
							<p></p>
							<p>Selling Price : #NumberFormat(SellingPrice,'9,99')#</p>
							<cfif DiscountPercent neq "NULL" AND DiscountPercent neq 0>
								<p>Discount : #DiscountPercent#</p>
								<p>DiscoutPrice : #NumberFormat(DiscountPrice,'9,99')#</p>
							</cfif>
							</div>
						</a>
						<cfset LOCAL.productId = #ProductId# />
					</cfoutput>
				</div>
			</cfif>
			<cfset columnCount = columnCount + 1 />
		<cfif columnCount eq 6>
			</div>
			<cfset columnCount = 1 />
		</cfif>
	</cfloop>


<cfinclude template="footer.cfm" />