function Product(){
	var objSelf = this;
	
	//Get a jQuery reference for search field
	this.searchBox = $("#searchField");
	
	//Bind the search field with key press
	this.searchBox.keyup(function(){
		objSelf.search(this.searchBox);
	});
}

Product.prototype.search = function(searchBox){
	var searchValue = $("#searchField").val();
	if(searchValue.trim() != ""){
		$.ajax({
			url: "http://www.shopsworld.net/controller/controller.cfc",
			type:"get",
			dataType:"json",
			data: {
				method : "searchSuggestion",
				searchItem : searchValue
			},
			success: function( ResponseObj ){
				searchDiv = $("div#suggestionBox");
				if(ResponseObj.SUCCESS){
					var data = ResponseObj.DATA;
					searchDiv.show();
					searchDiv.empty();
					for(var i = 0;i < 5 && i < data.length; i ++){
						searchDiv.append('<li><a href="http://www.shopsworld.net/view/productDetail.cfm?product='+data[i].PRODUCTID+'">'+data[i].PRODUCTNAME+'</a></li>');
					}
				}
				else{
					searchDiv.show();
					searchDiv.empty();
					searchDiv.append('<li>No suggestion available</li>')
				}
			},
			error: function( RequestObj,error){
				console.log( RequestObj);
				alert("error "+error);
			}
		});
	}
	else{
		$("div#suggestionBox").hide();
	}
}

$(document).ready(function(){
	var objProsuct = new Product();
});