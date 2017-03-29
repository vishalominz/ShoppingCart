<cfif session.isSeller AND session.loggedIn>
	<cfset lastPage = "#CGI.HTTP_REFERER#" />
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

			}>
	<cflocation url="#lastPage#?product=insert" />
<cfelse>

</cfif>

<!--- <cfparam name="fileUpload" default="">
<cfoutput>
<cfdump var="#form.fileUpload#">
</cfoutput>
<cfif len(trim(form.fileUpload))>
	<cffile action="upload"
			destination="C:\upload"
			fileField="fileUpload"
			nameconflict="overwrite">
</cfif>
<cfoutput>

</cfoutput> --->
