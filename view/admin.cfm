<cfinclude template="header.cfm"/>
<cfinclude template="menubar.cfm"/>
<cfinvoke component="model.Admin"
			method="retrieveProductCategory"
			returnVariable="ProductCategory">
</cfinvoke>
<div class="row">
	<div class="row" id="admin-menu">
		<ul class="nav nav-tabs">
		  <li class="active"><a id="stats">Stats</a></li>
		  <li class="dropdown">
		    <a class="dropdown-toggle" data-toggle="dropdown" id="produt">Product
		    <span class="caret"></span></a>
		    <ul class="dropdown-menu">
		      <li><a id="insertProduct"href="#">Insert Product</a></li>
		      <li><a id="deleteProduct"href="#">Delete Product</a></li>
		      <li><a id="updateProduct"href="#">Update Product</a></li>
		    </ul>
		  </li>
		</ul>
	</div>
	<div class="row" id="admin-content">
		<div class="row admin-content" id="stats">

		<div class="row admin-content" id="productInsert">
			<div class="col-md-2"></div>
			<div class="col-md-8">
			<form method="post" id="productInsert" action="insertProduct">
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
				</div>
			</form>
			</div>

			<div class="col-md-2"></div>
		</div>

		<div class="row admin-content" id="productDelete">
		</div>

		<div class="row admin-content" id="productUpdate">
		</div>


	</div>

</div>
<!--- admin script --->
<script src="/assets/script/admin.js"></script>
<cfinclude template="footer.cfm"/>