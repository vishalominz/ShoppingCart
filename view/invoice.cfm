<cfif structKeyExists(url,"orderId") AND url.orderId neq "">
		
	<cfinvoke component="controller.Controller"
			method="retrieveOrderDetails"
			returnvariable="productDetail">
			<cfinvokeargument name="orderId"
							value="#orderId#" />
	</cfinvoke>

	<cfinclude template="header.cfm"/>
	<cfinclude template="menubar.cfm"/>
	<cfloop from="1" to="#arraylen(productDetail)#" index="location">
	<cfoutput>
		<div class="row invoiceBox" id="invoice#productDetail[location].orderDetailId#">
		  <div class="col-lg-1"></div>
		  <div class="col-lg-10">
		  <div class="invoice invoiceHeading"> Invoice
			<div class="invoice orderNumber"> Order ID : #productDetail[location].orderId# </div>
		 	<div class="invoice orderDate"> Order Date : #DATEFORMAT(productDetail[location].orderDate, "m/d/yyyy")# </div>
		  </div>
		 <div class="invoice contact"> Contact :
			 	<p> #productDetail[location].SellingCompanyName# </p>
		 </div>
		  <div class="invoice userInfo">
				<div class="invoice billTo"><p>Bill To :</p>
						<p>#productDetail[location].addressLine1#</p>
						<p>#productDetail[location].addressLine2#</p>
						<p>#productDetail[location].city#</p>
						<p>#productDetail[location].state# -
						#productDetail[location].pincode#</p>
				</div>
			    <div class="invoice shipTo"><p>Ship To :</p>
						<p>#productDetail[location].addressLine1#</p>
						<p>#productDetail[location].addressLine2#</p>
						<p>#productDetail[location].city#</p>
						<p>#productDetail[location].state# -
						#productDetail[location].pincode#</p>
				</div>
		   </div>
			<div class="invoice">
			  <table class="invoice" id="invoiceContent">
					<tr>
						<td>S.No.</td>
						<td>Item Brand Description</td>
						<td>Unit Price</td>
						<td>Quantity</td>
						<td>Amount</td>
					</tr>
					<cfset sno = 1 />
					<cfset sum=0 />
					<cfloop query="#productDetail[location]#">
						<cfoutput>
							<tr>
								<td>#sno#</td>
								<td>#ProductName#</td>
								<td>#ProductBrand#</td>
								<td>#OrderQuantity#</td>
								<td>#UnitPrice#</td>
							</tr>
						</cfoutput>
						<cfset sum = sum + #UnitPrice# * #OrderQuantity# />
						<cfset sno = sno + 1 />
					</cfloop>
					<tr>
						<td colspan="3"></td>
						<td >Total</td>
						<td>#sum#</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="col-lg-1"></div>
		</div>
	</cfoutput>
	</cfloop>
	<cfinclude template="footer.cfm"/>

</cfif>