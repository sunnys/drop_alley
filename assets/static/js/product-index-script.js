$(function(){
    $('.brand-filter').on('click', function(e){
        var filter_val = "&filters[]=product[brand_contains]&product[brand_contains]=" + $(this).attr("data-val");
        window.location.search = window.location.search + filter_val;
    });
    
    $('.remove-filter').on('click', function(e) {
        var filter_val = "&filters[]=product[" + $(this).attr("data-column") + "_" + $(this).attr("data-comp") + "]&product[" + $(this).attr("data-column") +"_" + $(this).attr("data-comp") +"]=" + $(this).attr("data-val");
        window.location.search = window.location.search.replace(filter_val, "");
    });

    if ($('#price-range-slider-new').length && typeof Swiper !== 'undefined') {
        var priceRange = document.getElementById('price-range-slider-new');
        noUiSlider.create(priceRange, {
          start: [20, 80],
          connect: true,
          range: {
            'min': 0,
            'max': 100
          }
        });
        priceRange.noUiSlider.on('update', function(values, handle) {
          var value = values[handle];
          handle ? $('#max-price').val(Math.round(value)).attr('value', Math.round(value)) : $('#min-price').val(Math.round(value)).attr('value', Math.round(value));
        });
        priceRange.noUiSlider.on('end', function(values, handle) {
            var value = values[handle];
            handle ? $('#max-price').val(Math.round(value)).attr('value', Math.round(value)) : $('#min-price').val(Math.round(value)).attr('value', Math.round(value));
            var filter_val = "&filters[]=product[price_greater_than]&product[price_greater_than]=" + Math.round(values[0]);
            var filter_less_val = "&filters[]=product[price_less_than]&product[price_less_than]=" + Math.round(values[1]);
            window.location.search = window.location.search + filter_val + filter_less_val;
          });
        $('#max-price').on('change', function() {
          priceRange.noUiSlider.set([null, this.value]);
        });
        $('#min-price').on('change', function() {
          priceRange.noUiSlider.set([this.value, null]);
        });
      }
})