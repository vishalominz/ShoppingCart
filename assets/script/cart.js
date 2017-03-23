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
			type: "post",
			url: "/model/Cart.cfc",
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
					
					//show that the product has been added to the cart
					if(objResponse.DATA[2] === true){
						$("#Message").show();
						$('#Message').html("Product Added To Cart");
						var count = objResponse.DATA[1];
						$('#cartItemCount').html(count);
					} else {
						$("#Message").show();
						$('#Message').html("No more product available");
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
	this.Button = $(".removeItem");
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
			url: "/model/Cart.cfc",
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
					$("#"+productId).hide();						
					//update cart count
					var count = parseInt($('#cartItemCount').html())-1;
					$('#cartItemCount').html(count);
					cosole.log($('.productItem'));
					
				
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



///When document is ready
$(
		function(){
			//Create an instance of the Product Items
			var objAddCartItem = new AddToCart();
			var objRemoveCartItem = new DeleteFromCart();
		}
		);