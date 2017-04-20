<cfparam name="URL.search" default="" />

<cfinclude template="header.cfm"/>
<body>
	<cfinclude template="menubar.cfm"/>
	<div class="row">
		<div class="col-md-2">
			<cfinclude template="search-filter.cfm" />
		</div>

		<div class="col-md-10 searchProducts">
			<cfinclude template="searchProducts.cfm"/>
		</div>

	</div>
</body>
<cfinclude template="footer.cfm"/>

<cfoutput>
	<script>
		$(document).ready(function(){
				$("##searchField").val("#URL.search#");
		});
	</script>
</cfoutput>