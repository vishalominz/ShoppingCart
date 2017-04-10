<cfif session.isSeller AND session.loggedIn>
	<cfset lastPage = "#CGI.HTTP_REFERER#" />
	<cfif form.productId eq "">
		<cfif form.leastPrice eq "">
			<cfset form.leastPrice = 0 />
		</cfif>	
		<cfset productDetail = {
					productName = form.productName,
					productBrand = form.productBrand,
				    leastPrice = form.leastPrice,
				    productDescription = form.productDescription,
					productCategory = form.productCategory,
					productSubCategory = form.productSubCategory } />

		<cfinvoke component="controller.Controller"
					method="insertProduct"
					returnvariable="productInfo"
					argumentcollection="#productDetail#">
		</cfinvoke>
		<cfset currentDirectory = "D:/Projects/shoppingCart/#productInfo.PRODUCTIMAGELOCATION#" />
		<cfif NOT DirectoryExists(currentDirectory)>
	    	<cfdirectory action = "create" directory="#currentDirectory#" />
		</cfif>
		<cfif len(trim(form.productImageLocation))>
			<cffile action="upload"
				destination = "#currentDirectory#/default.jpg"
				fileField = "productImageLocation"
				nameconflict="overwrite">
		</cfif>
		<cfset inventoryDetail = {
			productId = productInfo.productId,
			availableQuantity = form.quantity,
			sellingPrice = form.sellingPrice,
			discount = form.discountPercent
		} />
	<cfelse>
		<cfset inventoryDetail = {
			productId = form.productId,
			availableQuantity = form.quantity,
			sellingPrice = form.sellingPrice,
			discount = form.discountPercent
		} />
	</cfif>
		<cfinvoke component="model.Seller"
					method="insertProductInInventory"
					returnvariable="insertedItem"
					argumentcollection="#inventoryDetail#">	
		</cfinvoke>
	<cflocation url="/view/seller.cfm" />
<cfelse>
	<cflocation url="/view/login.cfm" />
</cfif>