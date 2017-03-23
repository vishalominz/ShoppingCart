function Admin(){
	var objSelf = this;
	
	//Get a jQuery reference to the select option
	this.productCategory = $("select#productCategory");
	
	//on select of productCategory
	this.productCategory.change(function(){
		objSelf.populateProductSubCategory();
	});
}

Admin.prototype.populateProductSubCategory = function(){
	var productCategoryId =  $( "select#productCategory").val();
	if(productCategoryId === "")
		//alert(true);
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
	var objAdmin = new Admin();		 
 });
