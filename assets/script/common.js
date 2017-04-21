var onResize = function() {
  // apply dynamic padding at the top of the body according to the fixed navbar height
  $("body").css("padding-top", $(".navbar-fixed-top").height());
  $("body").css("padding-bottom", $(".navbar-fixed-bottom").height());
};

// attach the function to the window resize event
$(window).resize(onResize);

// call it also when the page is ready after load or reload
$(function() {
  onResize();
   $("img").on("error", function(){
        $(this).attr('src', '/assets/images/product/default.jpg');
    });
});