<cfparam name="search" default=""/>
<cfset columnCount = 1 />
<cfinvoke component="controller.Controller"
			method="sellerSearchProducts"
			returnvariable="products">

		<cfinvokeargument name="searchValue"
						value="#search#">
</cfinvoke>


<cfinclude template="header.cfm"/>
<body>
	<cfinclude template="menubar.cfm"/>
		<div class="row seller-content" id="">
					  <div class="row editSellerheader">
					  		<div class="col-lg-1"></div>
							<div class="col-lg-2">
								Product
							</div>
							<div class="col-lg-2">
							</div>
							<div class="col-lg-2">
								Selling Price
							</div>
							<div class="col-lg-1">
								Discount
							</div>
							<div class="col-lg-2">
								Product Category
							</div>
							<div class="col-lg-2"></div>
					 </div>
				<cfloop query="#products#">
					<cfoutput>
						<cfif #SellingCompanyId# neq "">		
							<div class="row sellerProduct">
								<div class="col-lg-2">
									<img src="/#ProductImageLocation#/default.jpg" class="sellerProductImage">
								</div>
								<div class="col-lg-1">
									<p>#ProductName#</p>
									<p>#ProductBrand#</p>
								</div>
								<div class="col-lg-2">
									<span class="insert-quantity">#AvailableQuantity#</span>
									<input type="number" class="insert-quantity" name="insert-quantity"	/>
								</div>
								<div class="col-lg-2">
									<span class="insert-price">#SellingPrice#</span>
									<input type="number" class="insert-price" name="insert-price"/>
								</div>
								<div class="col-lg-1">
									
									<span class="insert-discount">#DiscountPercent#</span>
									<input type="number" class="insert-discount" name="insert-discount"	/> %
								</div>
								<div class="col-lg-2">
									<p>#ProductCategory#</p>
									<p>#ProductSubCategoryName#</p>
								</div>
								<div class="col-lg-2">
									<a class="editProduct">Edit</a>
									<a class="deleteProduct">Delete</a>
									<a class="updateProduct">update</a>
								</div>
								<input type="hidden" class="inventoryId" name="inventoryId" value="#InventoryId#" />
								<div id="dialog-confirm" title="Delete Product?">
								  <p class="dialog-message"><span class="ui-icon ui-icon-alert" style="float:left; margin:12px 12px 20px 0;"></span>Are you sure you want to Delete Product #ProductName#?</p>
								</div>
							</div>
						<cfelse>
							<div class="row sellerProduct">
								<cfset productDetail = {
										productId = #ProductId#,
										leastPrice = #LeastPrice#,
										productCategoryId = #ProductCategoryId#,
										productName= #ProductName#,
										productBrand= #ProductBrand#,
										productSubCategoryId= #productSubCategoryId#,
										productDescription= #productDescription#,
										ProductSubCategoryName= #ProductSubCategoryName#,
										ProductImageLocation = #ProductImageLocation#
									} />
								<div class="col-lg-2">
									<img src="/#ProductImageLocation#/default.jpg" class="sellerProductImage">
								</div>
								<div class="col-lg-1">
									<p>#ProductName#</p>
									<p>#ProductBrand#</p>
								</div>
								<div class="col-lg-2">
								</div>
								<div class="col-lg-2">
								</div>
								<div class="col-lg-1">
								</div>
								<div class="col-lg-2">
									<p>#ProductCategory#</p>
									<p>#ProductSubCategoryName#</p>
								</div>
								<div class="col-lg-2">
									<button class="addProduct" value="#URLEncodedFormat(SerializeJSON(productDetail))#">Add To Inventory</a>
								</div>
							</div>
						</cfif>
					</cfoutput>
				</cfloop>
			</div>
</body>
<cfinclude template="footer.cfm"/>