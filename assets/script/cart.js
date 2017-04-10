// Create a Javascript class to handle the Product
function AddToCart(){
	var objSelf = this;
	//Get a jQuery reference to the button
	this.Button = $("#addToCart,#buyNow");
	//Bind the onclick event on the button
	this.Button.click(
		function( objEvent ){
			//Pass the Product details via AJAX
			objSelf.OnClickAdd(this);
		}
	);
}

//Define a method to help display any errors.
AddToCart.prototype.ShowErrors = function( arrErrors ){
	var strError = "Please review the following : \n";
	
	//Loop over each error to build up the error string.
	$.each(
		arrErrors,
		function( intI, strValue ){
			strError += ("\n- " + strValue);
		}
		);
	
	//Alert the error.
	alert( strError );
}


//Define a method to send Product Details via AJAX
AddToCart.prototype.OnClickAdd = function(element){
	var objSelf = this;
	var productDetails=  unescape(element.value);
	//Submit Product Details via AJAX
	$.ajax(
		{
			type: "get",
			url: "/controller/controller.cfc",
			data: {
				method: "AddToCart",
				argumentCollection : productDetails			
					},
			dataType: "json",
			
			//Define request handlers
			success : function(objResponse){
				//Check to see if request was successful
				console.log(objResponse);
				if(objResponse.SUCCESS && element.id === "addToCart"){
					
					var addedMessage = $(element).parent().find("span.Message");
					//show that the product has been added to the cart
					if(objResponse.DATA[2] === true){
						addedMessage.show();
						addedMessage.html("Product Added To Cart");
						var count = objResponse.DATA[1];
						$('#cartItemCount').html(count);
						setTimeout(function() {
					        addedMessage.hide('blind', {}, 500)
					    }, 3000);
					} else {
						$(element).prop('disabled', true);
						addedMessage.show();
						addedMessage.html("No more product available");

					}
				} else if(objResponse.SUCCESS && element.id === "buyNow"){
					var url= "http://www.shopsworld.net/view/cart.cfm";
					$(location).attr('href',url);
				} else{
					//Show error on unsuccessful response
					objSelf.ShowErrors( objResponse.ERRORS );
				}
			},
			error : function( objRequest, strError ){
				objSelf.ShowErrors( [ "An unknow connection error occurred."]);
			}
		}
		);
}



//-------------------------------//
function DeleteFromCart(){
	var objSelf= this;
	//Get a jQuery reference to the button
	this.Button = $("button.removeItem");
	//Bind the onclick event on the button
	this.Button.click(
		function( objEvent ){
			//Pass the Product details via AJAX
			objSelf.OnClickDelete(this.value);
		}
	);
}

//Define a method to help display any errors.
DeleteFromCart.prototype.ShowErrors = function( arrErrors ){
	var strError = "Please review the following : \n";
	
	//Loop over each error to build up the error string.
	$.each(
		arrErrors,
		function( intI, strValue ){
			strError += ("\n- " + strValue);
		}
		);
	
	//Alert the error.
	alert( strError );
}

DeleteFromCart.prototype.OnClickDelete = function(productId){
	var objSelf = this;
	//Submit Product Details via AJAX
	$.ajax(
		{
			type: "get",
			url: "/controller/controller.cfc",
			data: {
				method: "DeleteFromCart",
				ProductId : productId			
					},
			dataType: "json",
			
			//Define request handlers

			success : function(objResponse){
				//Check to see if request was successful
				if(objResponse.SUCCESS){
					
					//show that the product has been deleted from the cart
					this.div = $('.productItem');
					$("#"+productId).remove();						
					//update cart count
					var count = parseInt($('#cartItemCount').html())- this.div.children(".productCount").val();
					$('#cartItemCount').html(count);
					
					var sum = 0;
					$("div.productItem").each( function( index) {
						var tempItemPrice = $(this).children("input.itemPrice").val();
						var tempCount = $(this).children(".productCount").val();
						sum += tempItemPrice * tempCount;
					});
					$("span#totalAmount").html("Total : &#8377; "+sum);
					if(objResponse.DATA.length === 0){
						$("div#proceedToPay").hide();
						$("form#itemsToBuy").html("<span class='alert alert-info'>No Item Present in cart.	 </span>");
					}

				} else {
					//Show error on unsuccessful response
					objSelf.ShowErrors( objResponse.ERRORS );
				}
			},
			error : function( objRequest, strError ){
				objSelf.ShowErrors( [ "An unknow connection error occurred."]);
			}
		}
		);
}

////------------------------------///
function UpdateCart(){
	var objSelf = this;
	//Get a jquery referenct for product Count element
	this.productCount = $(".productCount");
	//Bind the onclick event on click
	this.productCount.click(function(objEvent){
		$(this).parent().children(".updateButton").show();
	});
	//Get a jQuery reference to the update button
	this.updateButton = $(".updateButton");
	//Bind the onclick event on the button
	this.updateButton.click(
		function( objEvent ){
			//Pass the Product details via AJAX
			objSelf.OnClickUpdate($(this).parent());
			return false;
		}
	);
}


UpdateCart.prototype.OnClickUpdate = function( element ){
	var count = $(element).children(".productCount");
	var updateButton = $(element).children(".updateButton");
	var countValue = count.val();
	var productId = $(element).attr('id');
	var error = $(element).children(".error");
	var inventoryId = $(element).children(".inventoryId").val();
	var itemPrice = $(element).children("input.itemPrice").val();
	if(countValue > 0){
		$.ajax({
			url: "/controller/controller.cfc",
			type: "get",
			data: {
				method: "UpdateCartItem",
				countValue: countValue,
				productId: productId,
				inventoryId: inventoryId
			},
			dataType: "json",
			success: function(objResponse){
				if(objResponse.SUCCESS){
					updateButton.hide();
					error.hide();
					$(element).children("p.itemPrice").html("&#8377;"+(itemPrice * countValue));
					var sum = 0;
					var cartCount = 0;
					$("div.productItem").each( function( index) {
						var tempItemPrice = $(this).children("input.itemPrice").val();
						var tempCount = $(this).children(".productCount").val();
						sum += tempItemPrice * tempCount;
						cartCount += tempCount;
					});
					$("span#totalAmount").html("Total : &#8377; "+sum);
					$('#cartItemCount').html(objResponse.DATA);

				}else{
					error.text("Maximum number of item available is "+objResponse.DATA);
					error.show();
				}
			},
			error: function(objRequest, error){
				alert("error "+error);
			}
		});
	}
	else{
		error.text("No of item sholud be more than 0");
					error.show();
	}
}


///When document is ready
$(
		function(){
			//Create an instance of the Product Items
			var objAddCartItem = new AddToCart();
			var objRemoveCartItem = new DeleteFromCart();
			var objUpdateCartItem = new UpdateCart();
		}
		);