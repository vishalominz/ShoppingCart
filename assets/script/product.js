function Product(){
	var objSelf = this;
	
	//Get a jQuery reference for search field
	this.searchBox = $("#searchField");
	
	//Bind the search field with key press
	this.searchBox.keyup(function(){
		objSelf.search(this.searchBox);
	});
	
	//Get a jQuery refernce for the images of product
	this.imageIcon = $("img.thumbnails");

	//Bin imageIcon to click
	this.imageIcon.click( function(){
		var imageLocation = $(this).attr('src');
		$("img#productDetailImage").attr('src',imageLocation);
	})

	//Bind search items - binding dynamically
	$('div#suggestionBox').on('click', 'li', function() {
	    $("input#searchField").val($(this).text());
	    $('div#suggestionBox').hide();
	});
	
	//Bind search button
	this.searchButton = $("#searchButton");
	this.searchButton.click(function(){
		var url = "http://www.shopsworld.net/view/search.cfm?search="+$("#searchField").val();
		$(location).attr('href',url);
		return false;
	});
	
	//Get a jQuery reference for brand checkbox
	this.brandCheckbox = $("#brand-search input");

	//on check marked call function
	this.brandCheckbox.click( function(){
		objSelf.getSelectedValues();
	})

	//Get a jQuery reference for search-price slider
	this.searchPriceSlider = $("#search-slider");
	
	 this.searchPriceSlider.slider({
			range: true,
			min: 0,
			max: 100000,
			values: [ 0, 100000 ],
			step: 50,
			slide: function( event, ui ) {
				$( "#price" ).val( "₹" + ui.values[ 0 ] +
						"- ₹" + ui.values[ 1 ] );
				$("input#minPrice").val(ui.values[0]);
				$("input#maxPrice").val(ui.values[1]);
				objSelf.getSelectedValues();
			}
		});
	  $( "#price" ).val( "₹" + $( "#search-slider" ).slider( "values", 0 ) + 
				"- ₹" + $( "#search-slider" ).slider( "values", 1 ));
	
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
				searchItem : searchValue,
				minPrice : 0,
				maxPrice : 100000
			},
			success: function( ResponseObj ){
				searchDiv = $("div#suggestionBox");
				if(ResponseObj.SUCCESS){
					var data = ResponseObj.DATA;
					searchDiv.show();
					searchDiv.empty();
					for(var i = 0;i < 5 && i < data.length; i ++){
						searchDiv.append('<li id = '+data[i].PRODUCTID+'>'+data[i].PRODUCTNAME+'</li>');
						
					}
				}
				else{
					searchDiv.show();
					searchDiv.empty();
					searchDiv.append('<p>No suggestion available</p>')
				}
			},
			error: function( RequestObj,error){
				window.open('http://www.shopsworld.net/view/error.cfm', "_self");
			}
		});
	}
	else{
		$("div#suggestionBox").hide();
	}
}

Product.prototype.getSelectedValues = function(){
	var allCheckedVals = [];
	var searchValue = $("#searchField").val();
	var minPrice = $("input#minPrice").val();
	var maxPrice = $("input#maxPrice").val();
     $('#brand-search :checked').each(function() {
       allCheckedVals.push($(this).val());
     });
   	 var list = "";
   	 if(allCheckedVals.length > 0){
   	 	list = "'"+allCheckedVals[0]+"'";
   	 	for( val in allCheckedVals){
     		list = list + ",'"+allCheckedVals[val]+"'";
     }
   	 }
   	 
 	var url = "http://www.shopsworld.net/view/searchProducts.cfm?search="+searchValue+"&brandList="+list+"&minPrice="+minPrice+"&maxPrice="+maxPrice;
 	$.get( url, function( data ) {
			$( "div.searchProducts" ).html( data );  		
	});
     
}


$(document).ready(function(){
	var objProsuct = new Product();
});