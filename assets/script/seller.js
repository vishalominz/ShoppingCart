function Seller(){
	var objSelf = this;
	
	//Get a jQuery reference to the select option
	this.productCategory = $("select#productCategory");
	
	//on select of productCategory
	this.productCategory.change(function(){
		objSelf.populateProductSubCategory();
	});
	
	
	//Get a jQuery reference for insertProduct
	this.insertProductLink = $("a#insertProduct");
	
	//Get a jQuery reference for deleteProduct
	this.updateDeleteProductLink = $("a#updatedeleteProduct");
	
	//insertProductLink click action
	this.insertProductLink.click(function( objEvent ){
		$("div#productUpdateDelete").hide(); 
		$("div#productInsert").show();
	});
	
	//updateDeleteProductLink click action
	this.updateDeleteProductLink.click(function( objEvent ){
		 $("div#productInsert").hide();
		 $("div#productUpdateDelete").show();
	});

	//Get a jQuery reference for editProduct
	this.editProductLink = $("a.editProduct");
	
	//Get a jQuery reference for deleteProduct
	this.deleteProductLink = $("a.deleteProduct");
	
	//Get a jQuery reference for updateProduct
	this.updateProductLink	= $("a.updateProduct");
	
	//editProductLink click function
	this.editProductLink.click(function( objEvent ){
		var parent= $(this).parent().parent();
		objSelf.editProduct(parent);
	});

	//updateProduct click function
	this.updateProductLink.click(function ( objEvent ){
		var parent= $(this).parent().parent();
		objSelf.updateProduct(parent);
	});
	//deleteProductLink click function
	this.deleteProductLink.click(function( objEvent ){
			objSelf.deleteProduct($(this).parent().parent());
	});
}

Seller.prototype.updateProduct = function(element){
	var price = element.find("input.insert-price").val();
	var quantity =  element.find("input.insert-quantity").val();
	var discount = element.find("input.insert-discount").val();
	var inventoryId = element.find("input.inventoryId").val();
	alert(price+" d "+discount+" q "+quantity);
	$.ajax({
		url: "http://www.shopsworld.net/controller/controller.cfc",
		dataType: "json",
		method: "get",
		data:{
			method: "updateProductInInventory",
			sellingPrice : price,
			quantity : quantity,
			discount : discount,
			inventoryId : inventoryId
		},
		success: function ( ResponseObj) {
		element.find("span.insert-quantity").show();
		element.find("span.insert-price").show();
		element.find("span.insert-discount").show();

		element.find("span.insert-quantity").text(quantity);
		element.find("span.insert-price").text(price);
		element.find("span.insert-discount").text(discount);

		element.find("input.insert-quantity").hide();
		element.find("input.insert-price").hide();
		element.find("input.insert-discount").hide();

		element.find("a.editProduct").show();
		element.find("a.deleteProduct").show();
		element.find("a.updateProduct").hide();
		$("p#success-message").show();
		$("p#success-message").text("Update has been performed successfully");
		$( "#dialog-message" ).dialog({
		      modal: true,
		      title: 'Update Successfull',
		      buttons: {
		        Ok: function() {
		          $( this ).dialog( "close" );
		        }
		      }
    		});
		},
		error: function( RequestObj , error){
			alert(error + " updateProductInInventory");
		}
	});
}

Seller.prototype.editProduct = function(element){
		element.find("a.editProduct").hide();
		element.find("a.deleteProduct").hide();
		element.find("a.updateProduct").show();

		var quantity =  element.find("span.insert-quantity").text();
		var discount = element.find("span.insert-discount").text();
		var price 	 = element.find("span.insert-price").text();

		alert(quantity+ 'quantity');
		element.find("span.insert-quantity").hide();
		element.find("span.insert-price").hide();
		element.find("span.insert-discount").hide();

		element.find("input.insert-quantity").show();
		element.find("input.insert-price").show();
		element.find("input.insert-discount").show();

		element.find("input.insert-quantity").val(quantity);
		element.find("input.insert-price").val(price);
		element.find("input.insert-discount").val(discount);

}		
Seller.prototype.deleteProduct = function( element ){
	var inventoryId = element.find("input.inventoryId").val();
	element.find("p.dialog-message").show();
	$( "#dialog-confirm" ).dialog({
      resizable: false,
      height: "auto",
      width: 500,
      modal: true,
      buttons: {
        "Delete Product": function() {
         $.ajax({
				url: "http://www.shopsworld.net/controller/controller.cfc",
				dataType : "json",
				data : {
					method : "deleteProductFromInventory",
					inventoryId : inventoryId
				},
				success : function( ResponseObj ){
					element.hide();
					$("p#success-message").show();
					$("p#success-message").text("Product has been removed successfully");
					$( "#dialog-message" ).dialog({
					      modal: true,
					      title: 'Delete Successfull',
					      buttons: {
					        Ok: function() {
					          $( this ).dialog( "close" );
					        }
					      }
			    		});

				},
				error: function( RequestObj, error){
					alert("deleteProductFromInventory " + error);
				}
			});
          $( this ).dialog( "close" );
          element.find("p.dialog-message").hide();
        },
        Cancel: function() {
          $( this ).dialog( "close" );
        }
      }
    });
}

Seller.prototype.populateProductSubCategory = function(){
	var productCategoryId =  $( "select#productCategory").val();
	if(productCategoryId === ""){
		$("select#productSubCategory").html('<option value="" selected>Select Sub Category</option>');
	}
	else{
		$.ajax({
			url: "http://www.shopsworld.net/controller/controller.cfc",
			data:{
				method: "retrieveProductSubCategory",
				productCategoryId : productCategoryId
			},
			dataType:"json",
			success: function(ResponseObj){
				console.log(ResponseObj.DATA);
				$("select#productSubCategory").html('<option value="" selected>Select Sub Category</option>');
				$.each(ResponseObj.DATA, function(k, v) {
					$("select#productSubCategory").append("<option value="+v[0]+">"+v[1]+"</option>");
					});
			},
			error: function(){
				alert("error");
			}
		});
	}
}


$(document).ready(function(){
	var objSeller = new Seller();		 
 });
