<cfinclude template="header.cfm" />
<cfinclude template="menubar.cfm" />
<cfparam name="URL.product" default=0 />
<cfparam name="LOCAL.productDetail" default={} />
<cfparam name="LOCAL.columnCount" default=1 />
<cfset LOCAL.directory = DirectoryList(ExpandPath("/assets/images/product/"&Product),false,"name","*.jpg","" ) />
<cfinvoke
	component="controller.controller"
	method="retrieveProductDetail"
	returnvariable="product">

	<cfinvokeargument
			name="productId"
			value="#product#">
</cfinvoke>

<cfoutput>
	
		<cfloop query="#product#" >
		<!--- Create a list to pass to unction --->
		<cfset LOCAL.productDetail = { productId = #ProductId#,
					productName = #ProductName#,
					productBrand = #ProductBrand#,
					productDescription = #ProductDescription#,
					productImageLocation = #ProductImageLocation#,
					inventoryId = #inventoryId#
					}/>

		<cfset selectedProduct = "#SerializeJSON(LOCAL.productDetail)#" />
		<cfif LOCAL.columnCount eq 1>
			<cfset LOCAL.columnCount = 0 />
			<div class="row">
				<div class="col-md-2">
					<!--- Retrieval of File list in directory --->
					<div id="imageList">
						<cfloop from=1 to="#arrayLen(LOCAL.directory)#" index="imageLocation">
							<img class="thumbnails" src="/assets/images/product/#URL.Product#/#LOCAL.directory[imageLocation]#" />

						</cfloop>
					</div>
				</div>
				<div class="col-md-4">
					<img id="productDetailImage" src="/#ProductImageLocation#/default.jpg" alt="#ProductName#" />
				</div>
				<div class="col-md-6">
					<div class="productInfo">
						#ProductName#<br/>
						#ProductBrand#<br/>
						#ProductDescription#<br/>
						#SellingCompanyName#
					</div>
					<cfif !session.isSeller>
						<div class="paymentMenu">
							<button type="button" name="addToCart" id="addToCart" value="#URLEncodedFormat(SerializeJSON(LOCAL.productDetail))#">
								Add To Cart
							</button>
							<button type="button" name="buyNow" id="buyNow" value="#URLEncodedFormat(SerializeJSON(LOCAL.productDetail))#">Buy</button>
							<div>
								<span class="Message"></span>
							</div>
						</div>
						
					</cfif>

					
						
				
				</div>
			</div><!--- End of row --->
		<cfelse>	
			<div class="row">
				<div class="col-lg-2">
					
				</div>
				<div class="col-lg-8">
					<span id="otherSellersHeader"> Product available by other Sellers </span>
					<div class="row" id="otherSellers">
						<div class="col-lg-2">
							#SellingCompanyName#
						</div>
						<div class="col-lg-2">
						</div>
						<div class="col-lg-2">
							#SellingPrice#
						</div>
						<div class="col-lg-2">
						</div>
						<div class="col-lg-4">
							<cfif !session.isSeller>
								<div class="paymentMenu">
									<button type="button" name="addToCart" id="addToCart" value="#URLEncodedFormat(SerializeJSON(LOCAL.productDetail))#">
										Add To Cart
									</button>
									<button type="button" name="buyNow" id="buyNow" value="#URLEncodedFormat(SerializeJSON(LOCAL.productDetail))#">Buy</button>
									<div>
										<span class="Message"></span>
									</div>
								</div>
							</cfif>
						</div>
					</div>	
				</div>
				<div class="col-lg-2">
				</div>
			</div>
		</cfif>
	</cfloop>
</cfoutput>
<cfinclude template="footer.cfm" />