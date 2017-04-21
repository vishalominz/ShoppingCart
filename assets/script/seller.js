function Seller(){
	var objSelf = this;

	$('.date-picker').datepicker( {
		 changeMonth: true,
        changeYear: true,
        showButtonPanel: true,
        dateFormat: 'yy-mm-dd',
        onClose: function(dateText, inst) { 
            $(this).datepicker('setDate', new Date(inst.selectedYear, inst.selectedMonth, inst.selectedDay));
        }
    });


	objSelf.validateData(objSelf, $("form#productInsert"));
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
	
	//Get a jQuery reference for stats
	this.stats = $("a#stats");

	//staus click action
	this.stats.click(function( objEven){
		$("li").removeClass("active");
		$("div#productUpdateDelete").hide(); 
		$("div#productInsert").hide();
		$("div#categoryInsert").hide();
		$("div#stats").show();
		$("a#stats").parent().addClass("active");
	});

	//insertProductLink click action
	this.insertProductLink.click(function( objEvent ){
		$("li").removeClass("active");
		$("div#productUpdateDelete").hide(); 
		$("div#productInsert").show();
		$("div#categoryInsert").hide();
		$("div#stats").hide();
		$("a#insertProduct").parent().parent().parent().addClass("active");
	});
	
	//updateDeleteProductLink click action
	this.updateDeleteProductLink.click(function( objEvent ){
		$("li").removeClass("active");
		 $("div#productInsert").hide();
		 $("div#productUpdateDelete").show();
		 $("div#categoryInsert").hide();
		 $("div#stats").hide();
		 $("a#updatedeleteProduct").parent().parent().parent().addClass("active");
	});

	//Get a jQuery reference for editProduct
	this.editProductLink = $("a.editProduct");
	
	//Get a jQuery reference for deleteProduct
	this.deleteProductLink = $("a.deleteProduct");
	
	//Get a jQuery reference for updateProduct
	this.updateProductLink	= $("a.updateProduct");
	
	//Get a jQuery reference for insertCategory
	this.insertCategoryLink = $('a#insertCategory');

	//bind click on insertCategoryLink
	this.insertCategoryLink.click(function ( objEvent ){
		$("li").removeClass("active");
		$("div#productUpdateDelete").hide(); 
		$("div#productInsert").hide();
		$("div#categoryInsert").show();
		$("div#stats").hide();
		$(this).parent().addClass("active");
	});

	//Get a jQuery reference for insertProductCategory
	this.insertProductCategoryButton = $("input#insertProductCategoryButton");

	//bind click on insertProductCategoryButton
	this.insertProductCategoryButton.click( function ( objEvent ){
			objSelf.insertProductCategory();
	});

	//Get a jQuery reference for insertProductSubCategoryButton
	this.insertProductSubCategoryButton = $("input#insertProductSubCategoryButton");

	//bind click on insertProductCategoryButton
	this.insertProductSubCategoryButton.click( function ( objEvent ){
			objSelf.insertProductSubCategory();
	});
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

	//get a jQuery reference for sellerSearchButton
	this.sellerSearchButton = $("#sellerSearchButton");

	//sellerSearchButton click action
	this.sellerSearchButton.click(function ( objEvent){
		var url = "http://www.shopsworld.net/view/sellerSearch.cfm?search="+$("#searchField").val();
		$(location).attr('href',url);
		return false;
	});
    
    //get a jQuery reference for sellerSearchProduct 
	this.sellerSearchItem = $("input#searchSellerProduct");

	//sellerSearchItem click action
	this.sellerSearchItem.keyup( function(){
		objSelf.sellerSearchProduct();
	});
	//get a jQuery refenence for file
	this.fileinput = $('input#productImageLocation');

	//change function for fileinput
    this.fileinput.change(function(){
         objSelf.readURL(this);
    });
	//get a jQuery reference for addProduxtToInventory
	this.addProductToInventory = $('button.addProduct');

	//on click event for addProductToInventory
	this.addProductToInventory.click(function(objEvent){
		objSelf.populateInsertProductForm(this);
	});

   //Get a jQuery reference for date
   this.saleDate = $("input#saleDate");

  //Get a jQuery reference for productSelectBox
  this.productBySeller = $("select#productBySeller option");

  //on change of select option in productBySeller
  this.productBySeller.click( function(){
  		objSelf.retrieveSalesDetail();
  });

  //on change of saleDate
  $('.date-picker').on("change", function() {
   	objSelf.retrieveSalesDetail();
  });

}

Seller.prototype.updateProduct = function(element){
	var price = element.find("input.insert-price").val();
	var quantity =  element.find("input.insert-quantity").val();
	var discount = element.find("input.insert-discount").val();
	var inventoryId = element.find("input.inventoryId").val();
	var valid = true;
	if(price < 0){
		$(".error").show();
	}
	if(quantity < 0){
		$(".error").show();
	}
	if(discount < 0 || discount > 100){
		$(".error").show();
	}
	if(valid){
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
			          $(this).find('p').show();
			        }
			      }
	    		});
			},
			error: function( RequestObj , error){
				window.open('http://www.shopsworld.net/view/error.cfm', "_self");
			}
		});
	}
}

Seller.prototype.editProduct = function(element){
		element.find("a.editProduct").hide();
		element.find("a.deleteProduct").hide();
		element.find("a.updateProduct").show();

		var quantity =  element.find("span.insert-quantity").text();
		var discount = element.find("span.insert-discount").text();
		var price 	 = element.find("span.insert-price").text();

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
	element.find("p.message").show();
	$( "#dialog-confirm" ).dialog({
      resizable: false,
      height: "auto",
      width: 500,
      modal: true,
      buttons: {
        "Delete Product": function() {
         $.ajax({
				url: "/controller/controller.cfc",
				dataType : "json",
				type: "post",
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
					window.open('http://www.shopsworld.net/view/error.cfm', "_self");
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
			async: false,
			dataType:"json",
			success: function(ResponseObj){
				$("select#productSubCategory").html('<option value="" selected>Select Sub Category</option>');
				$.each(ResponseObj.DATA, function(k, v) {
					$("select#productSubCategory").append("<option value="+v[0]+">"+v[1]+"</option>");
					});
			},
			error: function(){
				window.open('http://www.shopsworld.net/view/error.cfm', "_self");
			}
		});
	}
}

Seller.prototype.insertProductCategory = function(){
	var categoryName = $("input#insertProductCategory").val();
	if(categoryName != ""){
		$.ajax({
			url: "http://www.shopsworld.net/controller/controller.cfc",
			method: "get",
			dataType: "json",
			data: {
				method: "insertProductCategory",
				categoryName : categoryName
			},
			success: function(){
				var url = "http://www.shopsworld.net/view/productCategories.cfm"
				$.get(url, function( data ){
					$('div#productModalCategories').html(data);
				});
				$(".message").show();
				$( "#dialog-message" ).dialog({
			    			 modal: true,
			     			 buttons: {
			        Ok: function() {
			          $( this ).dialog( "close" );
			        }
			      }
			    });
			},
			error: function(){
				window.open('http://www.shopsworld.net/view/error.cfm', "_self");
			}
		});
	}
}
Seller.prototype.insertProductSubCategory = function(){
	var categoryName = $("select#productCategorySelect").val();
	var subCategoryName = $("input#insertProductSubCategory").val();
	 if(categoryName != "" && subCategoryName.trim() != ""){
		$.ajax({
			url: "http://www.shopsworld.net/controller/controller.cfc",
			method: "get",
			dataType: "json",
			data: {
				method: "insertProductSubCategory",
				categoryName : categoryName,
				subCategoryName : subCategoryName
			},
			success: function( ResponseObj ){
				var url = "http://www.shopsworld.net/view/productCategories.cfm"
				$.get(url, function( data ){
					$('div#productModalCategories').html(data);
				});
				$(".message").show();
				$( "#dialog" ).dialog();

			},
			error: function(RequestObj, error){
				window.open('http://www.shopsworld.net/view/error.cfm', "_self");
			}
		});

	}
}

Seller.prototype.readURL =function(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            
            reader.onload = function (e) {
            	$('#insertproductImage').show();
                $('#insertproductImage').attr('src', e.target.result);
            }
            
            reader.readAsDataURL(input.files[0]);
        }
    }

Seller.prototype.populateInsertProductForm = function( element ){
	var product = $(element).val();
	var url = "http://www.shopsworld.net/view/seller.cfm?product="+product;
	$(location).attr('href',url);

}

Seller.prototype.sellerSearchProduct = function(){
	var searchItem = $("input#searchSellerProduct").val();
	$.ajax({
		url: "http://www.shopsworld.net/controller/controller.cfc",
		method: "get",
		dataType : "json",
		data : {
			method : "sellerSearchProducts",
			searchValue : searchItem
		},
		success : function(ResponseObj){
			$("select#productBySeller option").hide();
			$("select#productBySeller option:selected").show();
			for(obj in ResponseObj.DATA){
					if(ResponseObj.COLUMNS[0] === "PRODUCTID" && ResponseObj.DATA[obj][11] != null){
					$("select#productBySeller option[value="+ResponseObj.DATA[obj][0]+"]").show();
					}
				
			}
		},
		error: function(RequestObj, error){
			window.open('http://www.shopsworld.net/view/error.cfm', "_self");
		}
	})
}


Seller.prototype.retrieveSalesDetail = function(){
	 var productList = "";
	 var saleDate = $("input#saleDate").val();
	 $("select#productBySeller option:selected").each( function(){            
     		productList += $(this).val()+',';       				
     		});
	 productList = productList.substring(0, productList.length - 1);

	 if(productList != "" && saleDate != ""){
	 	var url = "http://www.shopsworld.net/view/salesGraph.cfm?productList="+productList+"&saleDate="+saleDate;
				$.get(url, function( data ){
					$('div#salesChart').html(data);
				});
	 }else{
	 	if(productList === "" && saleDate ===""){
	 		$("div#salesChart").html('<p class="graphMessage">No Product Selected</p><p class="graphMessage">No Date Selected</p>');		
	 	}
	 	else{
	 		if(productList === ""){
	 			$("div#salesChart").html('<p class="graphMessage">No Product Selected</p>');
	 		}
	 		if(saleDate === ""){
	 			$("div#salesChart").html('<p class="graphMessage">No Date Selected</p>');
	 		}
	 	}
	 }
}

Seller.prototype.validateData = function(objSelf,form){

	//form validation
	$(form).validate({
    // Specify validation rules
    rules: {
      productName: {
      	required: true
      },
      productBrand: {
      required: true
      },
      sellingPrice: {
        required: true,
        number: true
      },
      quantity: {
      	required: true,
      	number: true
      },
      productDescription: {
      	required: true
      },
      productCategory: "required",
      productSubCategory: "required",
      email: "required"
    },
    // Specify validation error messages
    messages: {
      productName: {
      	required: "Please enter product name"
      },
      productBrand: {
        required: "Please enter Brand name"
      },
      sellingPrice: {
      	required: "Please enter Selling Price",
      	number : "Can only be numeric value"
      },
      quantity: {
      	required :"Please enter product quantity",
      	number : "Can only be numeric value"
      },
      productDescription: "Please enter description",
      email: "Please enter a valid email address",
       productCategory: "Please select a category",
      productSubCategory: "Please select a subcategory"
    },
    submitHandler: function(form) {
      form.submit();
    }
  });
}

$(document).ready(function(){
	var objSeller = new Seller();		 
 });
