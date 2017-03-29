<cfinclude template="header.cfm" />
<cfinclude template="menubar.cfm" />
<cfparam name="product" default=0 />
<cfparam name="productDetail" default={} />
<cfparam name="columnCount" default=0 />
<!--- database Interaction --->
<cfset tableName="Product">
<cfset columns="ProductId,ProductName,ProductBrand,ProductImageLocation,ProductDescription">
<cfset retrieveQuery={ retrieveQuery = "Select #columns# from #tableName# where productId = #product#"}>
<cfinvoke
	component="controller.controller"
	method="retrieveProductDetail"
	returnvariable="product">

	<cfinvokeargument
			name="productId"
			value="#product#">
</cfinvoke>
	<cfloop query="#product#">
		<!--- Retrieval of File list in directory
		<cfdump var="#DirectoryList(ExpandPath("/images/product/"&ProductId) )#">
		--->
		<!--- Create a list to pass to unction --->
		<cfset productDetail = { productId = #ProductId#,
					productName = #ProductName#,
					productBrand = #ProductBrand#,
					productDescription = #ProductDescription#,
					productImageLocation = #ProductImageLocation#
					}/>

		<cfset selectedProduct = "#SerializeJSON(productDetail)#" />
		<cfif columnCount eq 1>
			<div class="row">
		</cfif>
			<cfoutput>
			<div class="col-md-6">
				<img class="productDetailImage" src="/#ProductImageLocation#/default.jpg" alt="#ProductName#" />
			</div>
			<div class="col-md-6">
				<div class="productInfo">
					#ProductName#<br/>
					#ProductBrand#<br/>
					#ProductDescription#<br/>
				</div>

				<div class="paymentMenu">
					<button type="button" name="addToCart" id="addToCart" value="#URLEncodedFormat(SerializeJSON(productDetail))#">
						Add To Cart
					</button>
					<button type="button" name="buyNow" id="buyNow" value="#URLEncodedFormat(SerializeJSON(productDetail))#">Buy</button>
				</div>

				<div >
					<span id="Message"></span>
				</div>
				</cfoutput>
			</div>

			</div><!--- End of row --->

	</cfloop>
<cfinclude template="footer.cfm" />