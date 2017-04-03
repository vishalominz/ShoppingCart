<cfinvoke component="controller.Controller"
			method="retrieveProductFromInventoryByCompany"
			returnvariable="products">
</cfinvoke>
<cfinvoke component="controller.Controller"
			method="retrieveMostSoldProducts"
			returnvariable="mostSoldProducts">
		<cfinvokeargument name="sellingCompanyId"
					value="#session.user.sellingCompanyId#" />
</cfinvoke>

<cfinclude template="header.cfm" />
<cfinclude template="menubar.cfm" />

	<!--- <input type="date" data-date-inline-picker="true" />
	<cfchart> 
    <cfchartseries type="bar"> 
        <cfchartdata item="New Vehicle Sales" value=500000> 
        <cfchartdata item="Used Vehicle Sales" value=250000> 
        <cfchartdata item="Leasing" value=300000> 
        <cfchartdata item="Service" value=400000> 
    </cfchartseries> 
	</cfchart> --->
	<div class="row sellerStatusContent">
		<div class="col-lg-3">
			<div class="col-md-2">
			</div>
			<div class="col-md-10 popularProducts">
			<p>Popular Products</p>
			<cfloop query="#mostSoldProducts#">
				<cfoutput>
					<li>#ProductName#</li>
				</cfoutput>
			</cfloop>
			</div>
		</div>
		<div class="col-lg-9">
			<div class="row">
				<div class="col-lg-4">
					<input type="text" id="searchSellerProduct" name="searchSellerProduct" placeholder="Search Product"/>
					<select multiple name="productBySeller" id="productBySeller">
					 <cfloop query="#products#">
						 <cfoutput>
						 	<option class="sellerProduct" value="#ProductId#">#ProductName#</option>
						 </cfoutput>
					 </cfloop>
					</select>
				</div>
				<div calss="col-lg-8">
					<div class="row" id="salesChart">
					</div>

					<div class="row saleDateBox" >
						 <label for="getDate">Date :</label>
   						 <input name="saleDate" id="saleDate" class="date-picker" />
					</div>
					
						
					
				
				</div>
			</div>
		</div>
	</div>
	<div class="row">

	</div>

<cfinclude template="footer.cfm" />