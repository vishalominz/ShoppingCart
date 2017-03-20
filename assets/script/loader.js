function Loader(){
	objSelf = this;
	
	//Login button link
	this.logInButton = $("#logInButton");
	//bind LogInButton link
	this.logInButton.click(
			function(){
				objSelf.logInPage(objSelf);
			});
	
	//Register button link
	this.registerButton = $("#registerButton");
	//bind registerButton
	this.registerButton.click(
		function(){
			objSelf.registerPage(objSelf);
		});
}

Loader.prototype.registerPage = function(objSelf){
	
	$.ajax({
		url : "view/register.cfm",
		dataType : "text",
		method : "get",
		data : {},
		success : function( objResponse ){
			$("#content").html(objResponse);
		},
		error : function( objRequest, error){
			alert(error);
			console.log(objResponse);
		}
	});
}

Loader.prototype.logInPage = function( objSelf ){
		
	$.ajax({
		url : "view/login.cfm",
		dataType : "text",
		method : "get",
		data : {},
		success : function( objResponse ){
			$("#content").html(objResponse);
		},
		error : function( objRequest, error){
			alert(error);
			console.log(objResponse);
		}
	});
}


$(document).ready(function(){
	var objUser = new Loader();		 
 });