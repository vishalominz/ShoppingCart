<cfparam name="cartListCount" default="#Arraylen(session.cart)#" />
<nav class="navbar navbar-default navbar-fixed-top">
			<div class="container-fluid">
				<div class="navbar-header">
					<a class="navbar-brand" href="/index.cfm">OnlineShop</a>
				</div>
				<div>
				<ul class="nav navbar-nav navbar-right">
					<li>
						<a href="/view/cart.cfm">
						<span class="glyphicon glyphicon-shopping-cart"></span>
						Cart
						<span class="badge" id="cartItemCount"><cfoutput>#cartListCount#</cfoutput></span>
						 </a>
					</li>
				</ul>
				</div>
			  	<form class="navbar-form" id="search" autocomplete="off">
					<div class="input-group" id="searchBox">
						<div class="suggestionBox" id="suggestionBox">
						</div>
						<input type="text" id="searchField" class="form-control" placeholder="Search">
						<div class="input-group-btn">
							<button class="btn btn-default" id="searchButton" type="submit">
								<i class="glyphicon glyphicon-search"></i>
							</button>
						</div>
					</div>


				</form>


			</div>
			<div class="container-fluid">
				<div class="navbar-header">
					<ul class="nav navbar-nav">
						 <cfinclude template="productCategories.cfm" />
					</ul>
					<!--- <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#menu">
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
					</button> --->
				</div>
				<!--- <div class="collapse navbar-collapse" id="menu"> --->
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
						          <li><a id="buyHistory">Buy History</a></li>
						          <li><a id="logout">Log Out</a></li>
						        </ul>
						      </li>
						</cfif>
					</ul>
				  <!--- </div> --->
			</div>
</nav>
<div id="content" class="container">