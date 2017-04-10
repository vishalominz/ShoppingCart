<cfparam name="cartListCount" default=0 />
<cfloop from="1" to="#ArrayLen(SESSION.cart)#" index="item">
	<cfset cartListCount = cartListCount + Session.cart[item].ProductCount />
</cfloop>
<nav class="navbar navbar-default navbar-fixed-top">
			<div class="container-fluid">
				<div class="navbar-header">
					<cfif !session.isSeller>
						<a class="navbar-brand" href="/index.cfm">OnlineShop</a>
					<cfelseif session.loggedIn>
						<a class="navbar-brand" href="/view/seller.cfm">OnlineShop</a>
					<cfelse>
						<a class="navbar-brand" href="/view/login.cfm">OnlineShop</a>
					</cfif>
					
				</div>
				<div>
				<cfif !session.isSeller>
					<ul class="nav navbar-nav navbar-right">
						<li>
							<a href="/view/cart.cfm">
							<span class="glyphicon glyphicon-shopping-cart"></span>
							Cart
							<span class="badge" id="cartItemCount"><cfoutput>#cartListCount#</cfoutput></span>
							 </a>
						</li>
					</ul>
				</cfif>
				</div>
			  	<form class="navbar-form" id="search" autocomplete="off">
					<div class="input-group" id="searchBox">
						<div class="suggestionBox" id="suggestionBox">
						</div>
						<input type="text" id="searchField" class="form-control" placeholder="Search">
						<div class="input-group-btn">
							<cfif session.isSeller && session.loggedIn>
								<button class="btn btn-default" id="sellerSearchButton" type="submit">
									<i class="glyphicon glyphicon-search"></i>
								</button>
							<cfelse>
								<button class="btn btn-default" id="searchButton" type="submit">
									<i class="glyphicon glyphicon-search"></i>
								</button>
							</cfif>
						</div>
					</div>


				</form>


			</div>
			<div class="container-fluid">
				<div class="navbar-header">
					<ul class="nav navbar-nav">
						<div id="productModalCategories">
						 <cfinclude template="productCategories.cfm" />
						</div>
					</ul>
					<cfoutput>
					 <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="##menu">
					</cfoutput>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
					</button>
				</div>
				<cfif !session.loggedIn>
				 <ul class="nav navbar-nav navbar-left">
					<span id="seller">
						<cfif !session.isSeller>
							<cfoutput>
								Switch to Seller
							</cfoutput>
						<cfelse>
							<cfoutput>
								Switch to Customer
							</cfoutput>
						</cfif>
					</span>
				</ul>
				</cfif>
				<div class="collapse navbar-collapse" id="menu">
					<ul class="nav navbar-nav navbar-right">

					<cfparam name="session.loggedIn" default=false type="boolean" />

						<cfif !session.loggedIn>
							<li><a id="registerButton" href="/view/register.cfm"><span class="glyphicon glyphicon-user"></span>Sign Up </a></li>
							<li><a id="logInButton" href="/view/login.cfm"><span class="glyphicon glyphicon-log-in"></span>Log In </a></li>
						<cfelse>
							<li><img src=<cfoutput></cfoutput>></li>
							 <li class="dropdown">
						        <a class="dropdown-toggle" data-toggle="dropdown" href="#"><cfoutput>#session.user.userName#</cfoutput>
						        <span class="caret"></span></a>
						        <ul class="dropdown-menu">
						          <li><a id="profile">Profile</a></li>
						          <cfif !session.isSeller>
							          <li><a id="buyHistory">Buy History</a></li>
						          </cfif>
						          <li><a id="logout">Log Out</a></li>
						        </ul>
						      </li>
						</cfif>
					</ul>
				  <!--- </div> --->
			</div>
</nav>
<body>
<div id="content" class="container">