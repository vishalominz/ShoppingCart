<cfinclude template="view/header.cfm"/>
	<cfinclude template="view/menubar.cfm"/>
		<div id="myCarousel" class="carousel slide" data-ride="carousel">
		  <!-- Indicators -->
		  <ol class="carousel-indicators">
		  	<cfinvoke component="model.Database" method="retrieveProducts" returnvariable="products">
			</cfinvoke>
			<cfset count=1 />
			<cfloop query="#products#">
				<cfoutput>
				<cfif count eq 1>
					<li data-target="##myCarousel" data-slide-to="#count#" class="active"></li>
				<cfelse>
					<li data-target="##myCarousel" data-slide-to="#count#"></li>
				</cfif>
				</cfoutput>
				<cfset count= count + 1 />
			</cfloop>


			</ol>

		  <!-- Wrapper for slides -->
		  <div class="carousel-inner" role="listbox">
		  	<cfset count = 1 />
		  	<cfinvoke component="model.Database" method="retrieveProducts" returnvariable="products">
			</cfinvoke>
		  	<cfloop query="#products#">
		  		<cfoutput>
				<cfif count eq 1>
					 <div class="item active">
					 	  <a href="http://www.shopsworld.net/view/productDetail.cfm?product=#ProductId#">
					      <img class="courselImage" src="/#ProductImageLocation#/default.jpg" alt="#ProductName#">
					      <div class="carousel-caption">
					        <h3>#ProductName#</h3>
					        <p>#ProductDescription#</p>
					      </div>
					      </a>
					  </div>
				<cfelse>
					  <div class="item">
					  	 <a href="http://www.shopsworld.net/view/productDetail.cfm?product=#ProductId#">
					      <img class="courselImage" src="/#ProductImageLocation#/default.jpg" alt="#ProductName#">
					      <div class="carousel-caption">
					        <h3>#ProductName#</h3>
					        <p>#ProductDescription#</p>
					      </div>
					      </a>
					  </div>
				</cfif>
				</cfoutput>
				<cfset count = count + 1 />
			</cfloop>



		  <!-- Left and right controls -->
		  <a class="left carousel-control" href="#myCarousel" role="button" data-slide="prev">
		    <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
		    <span class="sr-only">Previous</span>
		  </a>
		  <a class="right carousel-control" href="#myCarousel" role="button" data-slide="next">
		    <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
		    <span class="sr-only">Next</span>
		  </a>
		</div>

<cfinclude template="view/footer.cfm"/>