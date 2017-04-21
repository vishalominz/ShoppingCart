<cfif session.isSeller AND session.LoggedIn>
	<cfparam name="product" default="" />
	<cfinclude template="header.cfm"/>
	<cfinclude template="menubar.cfm"/>
	<cfinvoke component="model.Seller"
				method="retrieveProductCategory"
				returnVariable="ProductCategory">
	</cfinvoke>

	<div class="row">
		<div class="col-lg-1"></div>
		<div class="col-lg-10">
			<div class="row" id="seller-menu">
				<ul class="nav nav-tabs">
				  <li class="active"><a id="stats">Stats</a></li>
				  <li class="dropdown">
				    <a class="dropdown-toggle" data-toggle="dropdown" id="produt">Product
				    <span class="caret"></span></a>
				    <ul class="dropdown-menu">
				      <li><a id="insertProduct">Insert Product</a></li>
				      <li><a id="updatedeleteProduct">Update/Delete Product</a></li>
				    </ul>
				  </li>
				  <li><a id="insertCategory">Product Category</a></li>
				</ul>
			</div>
			<div id="dialog-message" title="Update Done">
 			 	<p id="success-message">
   			 		<span class="ui-icon ui-icon-circle-check" style="float:left; margin:0 7px 50px 0;"></span>
    				Update has been done successfully.
  				</p>
			</div>
			<div class="row" id="seller-content">
				<div class="row seller-content" id="stats">
					<cfinclude template="sellerStatus.cfm" />
				</div>
				<div class="row seller-content" id="productInsert">
					<div class="col-md-2"></div>
					<div class="col-md-8">
					<form method="post" id="productInsert" action="insertProduct.cfm" enctype="multipart/form-data">
						<div class="box">
							<select name="productCategory" Id="productCategory">
									  <option value="" selected>Select Category</option>
								<cfloop query="#ProductCategory#">
									<cfoutput>
										<option value="#ProductCategoryId#">#ProductCategory#</option>
									</cfoutput>
								</cfloop>
							</select>

							<select name="productSubCategory" Id="productSubCategory">
								<option value="" selected>Select Sub Category</option>
							</select>
						</div>
						<div class="box insertProduct">
						<label class="insertProduct">Product Name</label>
						<input type="text" name="productName" class="insertProduct" id="productName" />
						</div>
						<div class="box insertProduct">
						<label class="insertProduct">Product Brand</label>
						<input type="text" name="productBrand" class="insertProduct" id="productBrand" />
						</div>
						<div class="box insertProduct">
						<label class="insertProduct">Least Price</label>
						<input type="text" name="leastPrice" class="insertProduct" id="leastPrice" />
						</div>
						<div class="box insertProduct">
						<label class="insertProduct">Selling Price</label>
						<input type="text" name="sellingPrice" class="insertProduct" id="sellingPrice" />
						</div>
						<div class="box insertProduct">
						<label class="insertProduct">Discount Percent</label>
						<input type="text" name="discountPercent" class="insertProduct" id="discountPercent" />
						</div>
						<div class="box insertProduct">
						<label class="insertProduct">Quantity</label>
						<input type="text" name="quantity" class="insertProduct" id="quantity" />
						</div>
						<div class="box insertProduct">
						<label class="insertProduct">Product Description</label>
						<textarea name="productDescription" class="insertProduct" id="productDescription">
						</textarea>
						</div>
						<div class="box insertProduct">
						<label class="insertProduct">Product Image</label>
						<input type="file" name="productImageLocation" class="insertProduct" id="productImageLocation" multiple/>
						</div>
						<div class="box insertProduct">
						<label class="insertProduct"></label>
						<input type="submit" class="insertProduct"  value="Save"/>
						<input type="hidden" id="productId" name="productId" value=""/>
						<img src="" id="insertproductImage" alt="Product Image"/>
						</div>
					</form>
					</div>

				<div class="col-md-2"></div>
			</div>
			<div class="row seller-content" id="productUpdateDelete">
				<cfinvoke component="controller.Controller"
							method="retrieveProductFromInventoryByCompany"
							returnvariable="products">
				</cfinvoke>
					  <div class="row editSellerheader">
					  		<div class="col-lg-1"></div>
							<div class="col-lg-2">Product</div>
							<div class="col-lg-2">Available Quantity</div>
							<div class="col-lg-2">Selling Price
							</div>
							<div class="col-lg-1">Discount</div>
							<div class="col-lg-2">Product Category</div>
							<div class="col-lg-2"></div>
					 </div>
				<cfloop query="#products#">
					<cfoutput>
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
								
								<span class="insert-discount">#DiscountPercent#</p>
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
							  <p class="message"><span class="ui-icon ui-icon-alert" style="float:left; margin:12px 12px 20px 0;"></span>Are you sure you want to Delete Product #ProductName#?</p>
							</div>
						</div>
					</cfoutput>
				</cfloop>
			</div>

			<div class="row seller-content" id="categoryInsert">
				<fieldset class="categoryInsert">
					<legend class="legend">Insert Product Category</legend>
					<div class="box insertCategory">
						<label class="insertCategory">Product Category</label>
						<input type="text" name="insertProductCategory" class="insertCategory" id="insertProductCategory" />
						<input type="button" name="insertProductCategoryButton" class="insertCategoryButton" id="insertProductCategoryButton"  value="Add Category"/>
					</div>
				</fieldset>

				<fieldset class="categoryInsert">
					<legend class="legend">Insert Product Sub Category</legend>
					<select name="productCategorySelect" class="insertCategory" Id="productCategorySelect">
								  <option value="" selected>Select Category</option>
							<cfloop query="#ProductCategory#">
								<cfoutput>
									<option value="#ProductCategoryId#">#ProductCategory#</option>
								</cfoutput>
							</cfloop>
					</select>
					<div class="box insertCategory">
						<label class="insertCategory">Product Sub Category</label>
						<input type="text" name="insertProductSubCategory" class="insertCategory" id="insertProductSubCategory" />
						<input type="button" name="insertProductSubCategoryButton" class="insertCategoryButton" id="insertProductSubCategoryButton" value="Add Sub Category"/>
					</div>
				</fieldset>
				<div id="dialog" title="Category Added">
					  <p class="message">
					  Category Added Successfully.
					 </p>
				</div>
			</div>


		</div>
		</div>
		<div class="col-lg-1"></div>
	</div>
	<cfinclude template="footer.cfm"/>
	<cfif isDefined("URL.product")>
		<cfdump var="#URL.product#"/>
		<cfoutput>
			<script>
				$(document).ready(function(){
					var product = JSON.parse(unescape(getUrlParameter('product')));
					$("div##productUpdateDelete").hide(); 
					$("div##productInsert").show();
					$("div##categoryInsert").hide();
					$("div##stats").hide();
					$("select##productCategory").val(product.PRODUCTCATEGORYID);
					$('select##productCategory option:not(:selected)').prop('disabled', true);
					var obj = new Seller();
					obj.populateProductSubCategory();
					$("select##productSubCategory").val(product.PRODUCTSUBCATEGORYID);
					$('select##productSubCategory option:not(:selected)').prop('disabled', true);
					$("input##productName").val(product.PRODUCTNAME);
					$("input##productName").prop("readonly", true);
					$("input##productBrand").val(product.PRODUCTBRAND);
					$("input##productBrand").prop("readonly", true);
					$("textarea##productDescription").val(product.PRODUCTDESCRIPTION);
					$("textarea##productDescription").prop("readonly", true);
					$("input##productId").val(product.PRODUCTID);
					$("img##insertproductImage").show();
					$("img##insertproductImage").attr('src','/'+product.PRODUCTIMAGELOCATION+'/default.jpg');
					$('input##productImageLocation').prop('disabled', true);
				 });
				 function getUrlParameter(sParam) {
					    var sPageURL = decodeURIComponent(window.location.search.substring(1)),
					        sURLVariables = sPageURL.split('&'),
					        sParameterName,
					        i;

					    for (i = 0; i < sURLVariables.length; i++) {
					        sParameterName = sURLVariables[i].split('=');

					        if (sParameterName[0] === sParam) {
					            return sParameterName[1] === undefined ? true : sParameterName[1];
					        }
					    }
					};	
			</script>
		</cfoutput>

	</cfif>
<cfelse>
	<cflocation url="/index.cfm" addtoken="false" />

</cfif>

