<cfparam name="ProductList" default="" />
<cfparam name="saleDate" default="" />
<cfif session.isSeller>
	<cfif saleDate eq "">
		<p class="graphMessage">No date is selected</p>
	<cfelseif ProductList eq "">
		<p class="graphMessage">No Product is selected</p>
	<cfelse>
		<cfinvoke component="model.Database"
				method="retreiveSaleDetail"
				returnvariable="productSale">
			<cfinvokeargument name="sellingCompanyId"
							value="#session.user.sellingCompanyId#" />
			<cfinvokeargument name="ProductList"
							value="#ProductList#" />
			<cfinvokeargument name="saleDate"
							value="#saleDate#" />
								
		</cfinvoke>
		<cfif productSale.recordCount gt 0 >
			<cfchart showborder="no"
				chartheight="300"
				chartwidth="600"
				yaxistitle="Sales" xaxistitle="Product"> 
					<cfchartseries type="bar">	
				 	<cfloop query="#productSale#">	
				 	 					
				   		 <cfchartdata item="#ProductName#" value="#totalSale#">
				    </cfloop> 
				    </cfchartseries>
			</cfchart>
		<cfelse>
			<p class="graphMessage">No selected products were sold on this day.</p>
		</cfif>	
	</cfif>	

</cfif>