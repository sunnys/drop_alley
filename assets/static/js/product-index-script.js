$(function(){
    // alert("hahah");
    $('.brand-filter').on('click', function(e){
        var filter_val = "&filters[]=product[brand_contains]&product[brand_contains]=" + $(this).attr("data-val");
        window.location.search = window.location.search + filter_val;
    });
    
    $('.remove-filter').on('click', function(e) {
        var filter_val = "&filters[]=product[" + $(this).attr("data-column") + "_contains]&product[" + $(this).attr("data-column") +"_contains]=" + $(this).attr("data-val");
        console.log(filter_val);
        window.location.search = window.location.search.replace(filter_val, "");
    });
})