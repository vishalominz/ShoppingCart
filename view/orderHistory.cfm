
<cfif Session.loggedIn>
<cfinvoke component="controller.controller"
			method="retrieveOrderHistory"
			returnvariable="orderHistory">
</cfinvoke>

<cfinclude template="header.cfm"/>
<cfinclude template="menubar.cfm"/>


<div>
	<cfloop query="orderHistory">
		<cfoutput>
		<div class="row">
			<div class="row order-header">
				<div class="col-md-2 col-1">
					<span class="span-Label">Order Id</span><br/>
					<span class="span-Value">#orderId#</span>
				</div>
				<div class="col-md-3 col-2">
					<span class="span-Label">Order Date</span><br/>
					<span class="span-Value">#DATEFORMAT(orderDate, "m/d/yyyy")#</span>
				</div>
				<div class="col-md-2 col-3">
					<span class="span-Label">Total </span><br/>
					<span class="span-Value">#Total#</span>
				</div>
				<div class="col-md-2 col-4">
					<span class="span-Label">Ship To </span><br/>
					<span class="span-Value">#Session.user.userName#</span>
				</div>
				<div class="col-md-3 col-5">
					<span class="span-Value">
						<a id="#orderId#" class="invoice">Generate Invoice</a>
					</span>
				</div>

			</div>
			<cfinvoke component="controller.controller"
						method="retrieveOrderHistoryDetail"
						returnvariable="orderItems">
				<cfinvokeargument name="orderId"
							value="#orderId#">
			</cfinvoke>
			<cfset count=1 />
			<div class="row order-content">
			  <div class="row order-sub-header">
				<div class="col-md-1 col-1">
					<span class="">S.No.</span>
				</div>
				<div class="col-md-2 col-2">
				</div>
				<div class="col-md-2 col-3">
					<span class="">Product</span>
				</div>
				<div class="col-md-5 col-3">
					<span class="">Description</span>
				</div>
				<div class="col-md-2 col-4">
					<span class="">Unit Price</span>
				</div>
			  </div>
			<cfloop query="orderItems">
				<div class="row order-content-detail">
					<div class="col-md-1">
						<span class="">#count#</span>
					</div>
					<div class="col-md-2">
						<span class="">
							<img class="purchaseHistory" src="/#ProductImageLocation#/default.jpg">
						</span>
					</div>
					<div class="col-md-2">
						<span class="order-name">#ProductName#</span><br/>
						<span class="order-brand">#ProductBrand#</span>
					</div>
					<div class="col-md-5">
						<span class="">#ProductDescription#</span>
					</div>
					<div class="col-md-2">
						<span class="">#UnitPrice#</span>
					</div>
				</div>
				<cfset count = count+1 />
			</cfloop>
			</div>
		</div>
		</cfoutput>
	</cfloop>
</div>

<cfinclude template="footer.cfm"/>
<cfelse>
	<cflocation url="http://www.shopsworld.net/view/login.cfm">
</cfif>
