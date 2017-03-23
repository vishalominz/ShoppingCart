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
				return false;
			}
		);
	
	//Get a jQuery reference to Address submit Button
	this.addressButton = $('input#addressSubmit');
	
	//bind the address submit button to addAddress()
	this.addressButton.click(function(){
		var formElement = document.getElementById("addressForm");
		objSelf.addAddress( objSelf );
		return false;
	});
	
	
	//Get a jQuery reference to product submit Button
	this.productSubmit = $("input#orderProducts");
	
	//bind the product submit to redirect to add address
	this.productSubmit.click(function(){
			var url = window.location.origin+"/view/placeOrder.cfm";
			$(location).attr('href',url);
		});
	
	//Get a jQuery reference for credit card div
	this.creditCardDiv = $('input[value="creditCard"]');
	
	//bind click to show Credit Card div
	this.creditCardDiv.click(function(){
		$("div#creditCard").show();
		$("div#cash").hide();
	});
	
	//Get a jQuery reference for cash div
	this.cashDiv = $('input[value="cash"]');
	
	//bind click to show Cash div
	this.cashDiv.click(function(){
		$("div#creditCard").hide();
		$("div#cash").show();
	});
	
	//Get a jQuery reference for cash pay
	this.cashPayButton = $("#cashPay");
	
	//bind click to cashPayButton
	this.cashPayButton.click(function(){
		objSelf.insertOrderDetail(objSelf);
	});
	
	//Get a jQuery reference for profile
	this.profile = $("#profile");
	
	//bind click to orderHistory 
	this.profile.click(function(){
		var url = window.location.origin+"/view/profile.cfm";
		$(location).attr('href',url);
	});
	//Get a jQuery reference for orderHistoy
	this.orderHistory = $("#buyHistory");
	
	//bind click to orderHistory 
	this.orderHistory.click(function(){
		objSelf.retrieveOrderHistory();
	});
	
	//Get a jQuery reference for image change link
	this.changeImage = $("#imageChangeLink");
	
	//bind click to changeImage
	this.changeImage.click(function(){
		$("form#img-upload").show();
		$("p#img-change").hide();
	});
	
	//Get a jQuery reference for upload image button
	this.uploadImage = $("input#fileUpload");
	
	//bind click to uploadImage
	this.uploadImage.click(function(){
		objSelf.uploadProfileImage();
	});
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
				alert("error  "+strError);
				console.log(objRequest);
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
				console.log(objRequest);
				alert(strError);
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



//addAddress of the user
User.prototype.addAddress = function(objSelf){
	$("span.error").hide();
	var addressLine1 = $('[name="address1"]').val();
	var addressLine2 = $('[name="address2"]').val();
    var city = $('[name="city"]').val();
    var state = $('[name="state"]').val();
    var addressType =  $('[name="adrressType"]').val();
    var pincode =  $('[name="pincode"]').val();
    var isValid = objSelf.validateAddressData(addressLine1,addressLine2,city,state,addressType,pincode);
    if(isValid){
	    $.ajax( 
	    {
	    	type: "get",
	    	url : "http://www.shopsworld.net/controller/controller.cfc",
	    	data : {
	    		method : "insertAddress",
	    		addressLine1 : addressLine1,
	    		addressLine2 : addressLine2,
	    		city : city,
	    		state : state,
	    		addressType : addressType,
	    		pincode : pincode
	    		},
	    	dataType: "json",
	    	success : function(objResponse){  
	    		if(objResponse.SUCCESS){
	    			var url = window.location.origin+"/view/payment.cfm";
	    			$(location).attr('href',url);
	    		}
	    	},    
	    	error : function(objRequest , error){
	    		alert("error " +error);
	    	}
	    });
    }
}

//validate addressInput
User.prototype.validateAddressData =function(addressLine1,addressLine2,city,state,addressType,pincode){
	var valid = true;
	addressLine1 = addressLine1.trim();
	if(addressLine1 === ""){
		$("span#addressLine1").show();
		valid = false;
	}
	city = city.trim();
	if(city === ""){
		$("span#city").show();
		valid = false;
	}
	state = state.trim();
	if(state === ""){
		$("span#state").show();
		valid = false;
	}
	addressType = addressType.trim();
	if(addressType === ""){
		$("span#addressType").show();
		valid = false;
	}
	pincode = parseInt(pincode);
	if((pincode < 10000 || pincode > 1000000) || isNaN(pincode)){
		$("span#pincode").show();
		valid = false;
	}
	return valid;	
}


//insert order details
User.prototype.insertOrderDetail = function(objSelf){
	$.ajax({
		url : "http://www.shopsworld.net/controller/controller.cfc",
		type : "get",
		dataType: "json",
		data : {
			method  : "insertOrderDetail"
		},
		success: function(ResponseObj){
			if(ResponseObj.SUCCESS){
				var url = window.location.origin+"/view/invoice.cfm";
				$(location).attr('href',url);
			}else{
				var url = window.location.origin+"/view/cart.cfm?error="+JSON.stringify(ResponseObj.error);
				$(location).attr('href',url);
			}
		},
		error: function(RequestObj, error){
			alert("error "+error);
			console.log(RequestObj);
		}
	}	
	);
	
}
 

//Retrieve order history
User.prototype.retrieveOrderHistory = function(){
	var url = "http://www.shopsworld.net/view/orderHistory.cfm";
	$(location).attr('href',url);
}

//upload image
User.prototype.uploadProfileImage = function(){
		$.ajax({
			url : "http://www.shopsworld.net/controller/controller.cfc",
			type : "post",
			dataType: "json",
			data : {
				method  : "updateUserProfilePicture"
			},
			success: function(ResponseObj){
				alert(ResponseObj.SUCCESS);
				if(ResponseObj.SUCCESS){
					$("form#img-upload").hide();
					$("p#img-change").show();
					var url = ResponseObj.URL;
					$('#profilePicture').attr('src', url);
				}else{
					
				}
			},
			error: function(RequestObj, error){
				alert("error "+error);
				console.log(RequestObj);
			}
		});
	
}

$(document).ready(function(){
	var objUser = new User();		 
 });
