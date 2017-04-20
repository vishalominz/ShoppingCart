function User(){
	var objSelf= this;
	//Get a jQuery reference to the seller button
	this.userButton = $("span#seller");
	
	//Bind sellerButton on the click
	this.userButton.click(
			function( objEvent ){
				objSelf.switchUser();
				return false;
			});
	//Get a jQuery reference to the button
	this.logInButton = $("form#loginUser");
	
	//Bind the on submit event on the login button
	this.logInButton.submit(
			function( objEvent ){
				$(".error").hide();
				objSelf.LogIn(objSelf); 
				return false;
			}
		);
	
	//Get a jQuery reference for logout link
	this.logOutLink = $("a#logout");
	
	//Bind the logout link to logout function
	this.logOutLink.click(
			function( objEvent ){
				return objSelf.LogOut();
			})
			
	
	//Validation of form data
	objSelf.validateData(objSelf,$("form#registerUser"),objSelf.RegisterUser);
	
	//Get a jQuery reference to Address submit Button
	this.addressButton = $('input#addressSubmit');
	
	//bind the address submit button to addAddress()
	this.addressButton.click(function(){
		var formElement = document.getElementById("addressForm");
		objSelf.addAddress( objSelf );
		return false;
	});
	
	///Get a jQuery reference to select address button
	this.selectAddressButton = $("button.selectAddress");
	
	//bind selectAddressButton to populateAddress()
	this.selectAddressButton.click(function(){
		var address = $(this).parent();
		objSelf.populateAddress( address );
	});
	
	//Get a jQuery reference to remove address button
	this.removeAddressButton = $("button.removeAddress");
	
	//bind removeAddressButton to removeAddres()
	this.removeAddressButton.click(function(){
		var address = $(this).parent();
		objSelf.removeAddress(address);
	})
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
	
	//Get a jQuery reference for invoice link
	this.generateInvoiceLink = $('a.invoice');

	//bind generateInvoiceLink
	this.generateInvoiceLink.click( function( objEvent ){
		var id = $(this).attr('id');
		var url = window.location.origin+"/view/invoice.cfm?orderId="+id;
		$(location).attr('href',url);
	});
	
	//Get a jQuery reference for image change link
	this.changeImage = $("#imageChangeLink");
	
	//bind click to changeImage
	this.changeImage.click(function(){
		$("form#img-upload").show();
		$("p#img-change").hide();
	});
	
}

//Define a method to check logIn credentials
User.prototype.LogIn = function(objSelf){
	var email = $("#email").val();
	var password = $("#password").val();
	var sessionSeller = $("#sellerValue").val();
	var company = sessionSeller == "true" ?  $("#company").val() : "" ;
	var valid = false;
	valid = objSelf.LogInValidate(email,password,company,sessionSeller);
	//Call login controller
	if(valid){
		$.ajax(
			{
			url : "/controller/controller.cfc",		
			type : "post",
			data : {
				method : "logIn",
				email : email,
				password : password,
				company : company
				
			},
			dataType: "json",
			success: function( objResponse ){
				//Check to see if request was successful
				if(objResponse.SUCCESS){
					$(location).attr('href',objResponse.URL);
				}else{
					$("#logInError").text("");
					if(!sessionSeller){
						$("#logInError").text("Invalid email or password.");
					}else {
						$("#logInError").text("Invalid email or password or compnay.");
					}
					$("#logInError").show();
					$("#email").val("");
					$("#password").val("");
					$("#company").val("");
							}
			},
			error: function(objRequest, strError){
				alert("login error  "+strError);
			
			}
		});
	}
}


//Define logOut function 
User.prototype.LogOut = function(){
	$.ajax(
			{
			url : "/controller/controller.cfc",		
			type : "post",
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


User.prototype.LogInValidate = function(email, password, company, sessionSeller){
	var valid = true;
	var email = email.trim();	
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
	if(sessionSeller == "true"){
		company = company.trim();
		if(company === ""){
			valid = false;
			$("#logInCompanyError").show();
		}
	}
	

	return valid;
}

//input validation for forms
User.prototype.validateData = function(objSelf, formName ,submitAction){
	jQuery.validator.addMethod("fullName", function(value, element) { 
	  		return /^[a-zA-Z]{4,}(?: [a-zA-Z]+){0,2}$/.test(value) && value != ""; 
		}, "Name should be of more than 4 letters");
	
	jQuery.validator.addMethod("noSpace", function(value, element) { 
			return value.indexOf(" ") && value != ""; 
		}, "No space please and don't leave it empty");

	jQuery.validator.addMethod("pincode",function(pincode,element){
		 return /^[1-9]{1}[0-9]{5}$/;
	},"Invalid pincode");

	jQuery.validator.addMethod("password",function(password,element){
		return /^(?=.*[A-Z].*[A-Z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8,}$/.test(password);
	},  "Ensure string has two uppercase letters <br/>Ensure string has one special case letter <br/>Ensure string has two digits <br/>Ensure string has three lowercase letters <br/>Ensure string is of length 8"
	);

	jQuery.validator.addMethod("phoneno", function(phoneNumber, element) {
    	    phoneNumber = phoneNumber.replace(/\s+/g, "");
    	    return this.optional(element) || phoneNumber.length > 9 && 
    	    phoneNumber.match(/^((\+[1-9]{1,4}[ \-]*)|(\([0-9]{2,3}\)[ \-]*)|([0-9]{2,4})[ \-]*)*?[0-9]{3,4}?[ \-]*[0-9]{3,4}?$/);
    	}, "Please specify a valid phone number");
	//form validation
	$(formName).validate({
    // Specify validation rules
    rules: {
      name: {
      	required: true,
      	fullName: true,
      },
      email: {
      required: true,
      noSpace: true,
      email: true
      },
      mobileNumber: {
        required: true,
        number: true,
        phoneno: true
      },
      password: {
      	required: true,
      	password: true
      },
      confirmPassword: {
      	required: true,
      	equalTo: "#password"
      },
      company: {
      	required: true
      },
      addressLine1: {
      	required: true
      },
      city: {
      	required: true
      },
      state: {
      	required: true
      },
      pincode: {
      	required: true,
      	number: true,
      	pincode: true
      },
      addressType: {
      	required: true
      }

    },
    // Specify validation error messages
    messages: {
      name: {
      	required: "Please enter your name"
      },
      mobileNumber: {
      	required: "Please enter your Phone Number"
      },
      email: {
        required: "Please enter Email"
      },
      password: {
      	required: "Please enter Password"
      },
      confirmPassword: {
      	required :"Please confirm Password"
      },
      company: {
      	required: "Please enter company name"
      },
      addressLine1: {
      	required: "Please enter address detail"
      },
      city: {
      	required: "Please enter the city name"
      },
      state: {
      	required: "Please enter the state name"
      },
      pincode: {
      	required: "Please enter the pincode",
      	number : "Only contains number"
      },
      addressType :{
      	required: "Please select an address type"
      }
    },
    submitHandler: function(form) {
      objSelf.RegisterUser();
      return false;
    }
  });
}

//Register user function
User.prototype.RegisterUser = function(){
	var email = $("#email").val();
	var password = $("#password").val();
	var name= $("#name").val();
	var mobileNumber = $("#mobileNumber").val();
	var sessionSeller = $("#sellerValue").val();
	var company = sessionSeller=="true" ? $("#company").val() : "" ;
		$.ajax(
			{
			url : "/controller/controller.cfc",		
			type : "post",
			dataType: "json",
			data : {
				method : "registerUser",
				email : email,
				password : password,
				name : name,
				mobileNumber : mobileNumber,
				company : company
			},
			
			success: function( objResponse ){
				//Check to see if request was successful
				if(objResponse.SUCCESS){
					window.location.href = objResponse.URL;
				}
				else{
					for(var i = 0; i < objResponse.ERRORS.length; i ++){
						var string = objResponse.ERRORS[i];
						var emailResult = string.match(/email/i);
						if(emailResult){
							$(".error#email").show();
							$(".error#email").html(objResponse.ERRORS[0]);
						}
						var mobileNumberResult = string.match(/mobile/i);
						if(mobileNumberResult){
							$(".error#mobileNumber").show();
							$(".error#mobileNumber").html(objResponse.ERRORS[1]);
						}
					}	
				}
				
			},
			error: function(objRequest, error){
				//window.open('http://www.shopsworld.net/view/error.cfm', "_self");
				alert(error);
			}
		});
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
    var addressId = $('[name="addressId"]').val();
    var isUsed = $('[name="isUsed').val()
    var isValid = objSelf.validateAddressData(addressLine1,addressLine2,city,state,addressType,pincode);
    if(isValid && (addressId === "" || isUsed == 1 )){
	    $.ajax( 
	    {
	    	type: "get",
	    	url : "/controller/controller.cfc",
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
	    		alert("addAddress error " +error);
	    	}
	    });
    }
    else if(isValid){
    	 $.ajax( 
	    {
	    	type: "get",
	    	url : "/controller/controller.cfc",
	    	data : {
	    		method : "updateAddress",
	    		addressId : addressId,
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
	    		alert("addAddress error " +error);
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
		url : "/controller/controller.cfc",
		type : "get",
		dataType: "json",
		data : {
			method  : "insertOrderDetail"
		},
		success: function(ResponseObj){
			if(ResponseObj.SUCCESS){
				var url = window.location.origin+"/view/invoice.cfm?orderId="+ResponseObj.DATA;
				$(location).attr('href',url);
			}else{
				var url = window.location.origin+"/view/cart.cfm?error="+JSON.stringify(ResponseObj.error);
				$(location).attr('href',url);
			}
		},
		error: function(RequestObj, error){
			alert("insertOrderDetail error "+error);
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

User.prototype.populateAddress = function(address){
	var addressLine1 = $(address).find(".addressLine1").text();
	var addressLine2 = $(address).find(".addressLine2").text();
	var city= $(address).find(".city").text();
	var state= $(address).find(".state").text();
	var pincode=  $(address).find(".pincode").text();
	var addressType= $(address).find(".addressType").text();
	var addressId = $(address).find(".addressId").text();
	var isUsed = $(address).find(".isUsed").text();
	$("textarea#addressLine1").val(addressLine1);
	$("textarea#addressLine2").val(addressLine2);
	$("input#city").val(city);
	$("input#state").val(city);
	$("input#pincode").val(pincode);
	$("input#addressType").val(addressType);
	$("input#addressId").val(addressId);
	$("input#isUsed").val(isUsed);
}


User.prototype.removeAddress = function(address){
	var addressId= $(address).find(".addressId").text();
	
	$.ajax({
		url: "http://www.shopsworld.net/controller/controller.cfc",
		dataType: "json",
		type: "get",
		data :{
			method: "removeAddress",
			addressId : addressId
		},
		success: function(responseObj){
			$(address).hide();
			
		},
		error: function(requestObj, error){
			alert(error);
		}
	});
	
}


User.prototype.switchUser = function(){
	$.ajax({
		url: "http://www.shopsworld.net/controller/controller.cfc",
		dataType: "json",
		type: "get",
		data :{
			method : "switchUser"
		},
		success : function(responseObj){
			if(responseObj.SUCCESS){
				$(location).attr('href',responseObj.URL);
			}
		},
		error : function(requestObj, error){
			alert(error +" switchUser");
		}
	});
}

$(document).ready(function(){
	var objUser = new User();		 
 });
