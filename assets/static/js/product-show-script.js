$(function(){
    $("#trynbuy").on('click', function(e){
        var product_id = $(this).attr("data-val");
        var size = $("#product-size option:selected").text();
        window.location.href = "/products/" + product_id +"/checkout/" + size;
    });
})