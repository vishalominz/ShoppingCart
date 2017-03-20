<!--- Button to trigger modal --->
<button type="button" class="btn btn-info  btn-md" data-toggle="modal" data-target="#productModal">
	Products By Category</button>

<!--- Product Modal --->
<div id="productModal" class="modal fade" role="dialog">
	<div class="modal-dialog">

	<!--- Modal --->
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
       			 <h4 class="modal-title">Product By Category</h4>
			</div>
			<div class="modal-body">
				<cfset columnCount = 1 />
				<cfinvoke
					component="controller.controller"
					method="retrieveProductCategory"
					returnvariable="productListByCategory">
				</cfinvoke>

				<cfloop query="#productListbyCategory#">
					<cfif columnCount eq 1>
						<div class="row">
					</cfif>
					<cfinvoke
						component="controller.controller"
						method="retrieveProductSubCategory"
						returnvariable="productSubCategoryList">
							<cfinvokeargument
								name="productCategoryId"
								value="#ProductCategoryId#">
					</cfinvoke>

					<div class="col-md-4">
					<cfoutput >#ProductCategory#</cfoutput>
					<cfloop query="productSubCategoryList">
						<cfoutput>
							<li>
								<a href="/view/product.cfm?productType=#ProductSubCategoryId#">
									#ProductSubCategoryName#
								</a>
							</li>
						</cfoutput>
					</cfloop>
					</div>
					<cfset columnCount = columnCount + 1 />
					<cfif columnCount eq 4>
						</div>
						<cfset columnCount = 1 />
					</cfif>
				</cfloop>

			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
</div>