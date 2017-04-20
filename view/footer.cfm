
</div>
<nav class="navbar navbar-inverse navbar-fixed-bottom">
	<div class="container-fluid">
		<div class="navbar-header">
			high
		</div>
		<div>
		<ul class="nav navbar-nav navbar-right">

		</ul>
		</div>


	</div>
</nav>
<cfif isDefined("URL.search")>
	<cfoutput>
		<script>
			$(document).ready(function(){
					$("##searchField").val("#URL.search#");
			});
		</script>
	</cfoutput>	
</cfif>

	<!--- Website scritps js --->
	<!---
	<script src="CGI.HOST_NAME#/assets/script/cart.js"></script>
	<script src="scripts/script.js"></script>
	 --->
	 <script src="/assets/script/common.js"></script>
	 <cfif session.isSeller>
		 <!--- seller script --->
		<script src="/assets/script/seller.js"></script>
	 </cfif>
	<!--- user script --->
	<script src="/assets/script/user.js"></script>
	<!--- cart script --->
	<script src="/assets/script/cart.js"></script>
	<!--- product script --->
	<script src="/assets/script/product.js"></script>
</body>

</html>