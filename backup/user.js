function User(){
	var objSelf= this;
	//Get a jQuery reference to the button
	this.logInButton = $("form#loginUser");
	
	//Bind the on submit event on the login button
	this.logInButton.submit(
			function( objEvent ){
				$(".error").hide();
				var valid = objSelf.LogIn(objSelf);
				if(!valid){
					event.preventDefault();
				}
			}
		);

	//Get a jQuery reference for logout link
	this.logOutLink = $("a#logout");
	
	//Bind the logout link to logout function
	this.logOutLink.click(
			function( objEvent ){
				return objSelf.LogOut();
			})
			
	//Get a jQuery reference for register button
	this.RegisterButton = $("form#registerUser");
	
	//Bind the register button to RegisterUser function
	this.RegisterButton.submit(
			function( objEvent ){
				$(".error").hide();
				var valid = objSelf.RegisterUser(objSelf);
				if(!valid){
					event.preventDefault();
				}
			}
		);
}

//Define a method to check logIn credentials
User.prototype.LogIn = function(objSelf){
	var email = $("#email").val();
	var password = $("#password").val();
	var valid = false;
	
	valid = objSelf.LogInValidate(email,password);
	//Call login controller
	console.log(valid);
	if(valid){
		$.ajax(
			{
			url : "http://www.shopsworld.net/controller/controller.cfc",		
			type : "get",
			async : false,
			data : {
				method : "logIn",
				email : email,
				password : password
			},
			dataType: "json",
			success: function( objResponse ){
				//Check to see if request was successful
				if(objResponse.SUCCESS){
					window.location.replace(objResponse.URL);
				}else{
					valid = false;
				}
			},
			error: function(objRequest, strError){
				
			}
		});
	}
	if(!valid){
		$("#logInError").show();
		$("#email").val("");
		$("#password").val("");
	}

}


//Define logOut function 
User.prototype.LogOut = function(){
	$.ajax(
			{
			url : "http://www.shopsworld.net/controller/controller.cfc",		
			type : "get",
			data : {
				method : "logOut",
			},
			dataType: "json",
			success: function( objResponse ){
				//Check to see if request was successful
				if(objResponse.SUCCESS){
					window.location.replace(objResponse.URL);
				}
			},
			error: function(objRequest, strError){
								
			}
		});
}


User.prototype.LogInValidate = function(email, password){
	var valid = true;
	email = email.trim();	
	//check if email is null
	if(email === ""){
		valid = false;
		$("#logInNameError").show();
	}
	
	//check if password is null
	if(password === ""){
		valid = false;
		$("#logInPasswordError").show();
	}
	
	return valid;
}


//Register user function
User.prototype.RegisterUser = function( objSelf ){
	var email = $("#email").val();
	var password = $("#password").val();
	var name= $("#name").val();
	var mobileNumber = $("#mobileNumber").val();
	var valid = false;
	
	valid = objSelf.userInfoValidate(email, password, name, mobileNumber);
	//Call login controller
	console.log(valid);
	if(valid){
		$.ajax(
			{
			url : "http://www.shopsworld.net/controller/controller.cfc",		
			type : "get",
			async : false,
			dataType: "json",
			data : {
				method : "registerUser",
				email : email,
				password : password,
				name : name,
				mobileNumber : mobileNumber
			},
			
			success: function( objResponse ){
				//Check to see if request was successful
				if(objResponse.SUCCESS){
					window.location.href = objResponse.URL;
				}
					valid = false;
				
			},
			error: function(objRequest, strError){
			
			}
		});
	}
	return valid;
}

//user info validation while registering
User.prototype.userInfoValidate = function(email, password, name, mobileNumber){
	var valid = true;
	if(email.trim() === ""){
		valid = false;
		$("span#email").show();
	}
	if(password === ""){
		valid = false;
		$("span#password").show();
	}
	if(name.trim() === ""){
		valid = false;
		$("span#name").show();
	}
	mobileNumber = Number(mobileNumber);
	if(mobileNumber < 1000000000 || mobileNumber > 9999999999 || isNaN(mobileNumber)){
		valid = false;
		$("span#mobileNumber").show();
	}
	
	return valid;
}



$(document).ready(function(){
	var objUser = new User();		 
 });