jQuery(function($){
//"use strict";

$("input").attr("autocomplete", (Math.random() * 100000).toString());
$('#tsm-slider').owlCarousel({
  margin:0,
	nav:true,
	slideBy:1,
	singleItem:true,
	autoplay:true,
	pagination: false,
	navigation : true,
	navText:["‹","›"],
	dots: false,
	autoplaySpeed: 3000,
	navSpeed:2500,
	autoplayTimeout:8000,
	center: true,
	responsiveClass:true,	
	responsive:{
		0:{
			items:1,
			nav:false,
			loop:true
		},
		600:{
			items:1,
			nav:true,
			loop:true
		},
		1000:{
			items:1,
			nav:true,
			loop:true
		}
	}
});

$('#tsm-slider-mobile').owlCarousel({
	margin:0,
	nav:true,
	items:1,
	slideBy:1,
	singleItem:true,
	dots: true,
	autoplay:true,
	//navText:["‹","›"],
	autoplaySpeed: 3000,
	navSpeed:2500,
	autoplayTimeout:8000,
	loop:true,
	responsiveClass:false,
	nav:true
});

// Home page Fan Favourite Slider
$('.fan-favourite-slider').owlCarousel({
	margin:0,
	nav:true,
	navigation : true,
	items:3,
	slideBy:1,
	singleItem:true,
	dots: true,
	autoplay:false,
	navText:[" "," "],
	autoplaySpeed: 3000,
	navSpeed:2500,
	autoplayTimeout:8000,
	loop:false,
	responsiveClass:true,
	responsive:{
		0:{
			items:1,
			loop:false,
		},
		600:{
			items:2,
		},
		1000:{
			items:3,
		}
	}
});

$('.specialty-slider').owlCarousel({
	margin:0,
	nav:true,
	navigation : true,
	items:3,
	slideBy:1,
	singleItem:true,
	dots: true,
	autoplay:true,
	navText:[" "," "],
	autoplaySpeed: 3000,
	navSpeed:2500,
	autoplayTimeout:8000,
	loop:false,
	responsiveClass:true,
	responsive:{
		0:{
			items:1,
		},
		600:{
			items:2,
		},
		1000:{
			items:3,
		}
	}
});

$('.gluten-free-slider').owlCarousel({
  margin:0,
	nav:true,
	navigation : true,
	items:3,
	slideBy:1,
	singleItem:true,
	dots: true,
	autoplay:true,
	navText:[" "," "],
	autoplaySpeed: 3000,
	navSpeed:2500,
	autoplayTimeout:8000,
	loop:false,
	responsiveClass:true,
	responsive:{
		0:{
			items:1,
		},
		600:{
			items:2,
		},
		1000:{
			items:3,
		}
	}
});
	
$(window).scroll(function(){
    if ($(this).scrollTop() > 50) {
       $('.navbar').addClass('shadow-sm fix-menu');
    } else {
       $('.navbar').removeClass('shadow-sm fix-menu');
    }
});	
	
 $(".collapse.show").each(function(){
        	$(this).prev(".card-header").find(".fa").addClass("fa-minus").removeClass("fa-plus");
        });        
        // Toggle plus minus icon on show hide of collapse element
        $(".collapse").on('show.bs.collapse', function(){
        	$(this).prev(".card-header").find(".fa").removeClass("fa-plus").addClass("fa-minus");
        }).on('hide.bs.collapse', function(){
        	$(this).prev(".card-header").find(".fa").removeClass("fa-minus").addClass("fa-plus");
        });	
});


// side navbar mobile screen
// function openNav() {
//     //document.getElementById("mySidenav").style.display = "block";
//     //document.getElementById("mySidenav").style.opacity = "1";
//     document.getElementById("mySidenav").style.right = "0px";
//     document.getElementById("mySidenav").style.visibility = "visible";
//   }
  
// function closeNav() {
//     setTimeout(function() {
//         //document.getElementById("mySidenav").style.display = "none";
//     }, 500)
//     document.getElementById("mySidenav").style.opacity = "0";
//     document.getElementById("mySidenav").style.right = "-350px";
// }


function openNav() {
    document.getElementById("mySidenavWrap").style.opacity = "1";
    document.getElementById("mySidenavWrap").style.visibility = "visible";
    // document.getElementById("mySidenavWrap").style.display = "block";
    document.getElementById('mySidenavWrap').classList.add("openWrap");
}

function closeNav() {
    setTimeout(function () {
        //document.getElementById("mySidenav").style.display = "none";
    }, 500)
    document.getElementById("mySidenavWrap").style.opacity = "0";
    document.getElementById("mySidenavWrap").style.visibility = "hidden";
    // document.getElementById("mySidenavWrap").style.display = "none";
    document.getElementById('mySidenavWrap').classList.remove("openWrap");
}

// $('#step2').click(function(){
//     $(this).hide()
//     $('.step2-box').show();
//     $('html, body').animate({
//         scrollTop: $(".step2-box").offset().top-50
//     }, 2000);
//     $('#step3').show();
//     return false
// })
// $('#step3').click(function(){
//     $(this).hide()
//     $('.step3-box').show();
//     $('html, body').animate({
//         scrollTop: $(".step3-box").offset().top-50
//     }, 2000);
//     $('.order-pizza-btn').show();
//     $('.order-update-btn').show();
//     return false
// })

$(document).ready(function () {
    $('#newstores').show();
    $('#newstores-backdrop').show();
    $("#close-btn-newstore-popup").click(function () {
        $('#newstores-backdrop').hide();
    });
});

$('#zero-contact').click(function() {
    $('#pizza-welcome-message').show();
    $('#fvpp-blackout').show();
})

$('#pizza-welcome-message').firstVisitPopup({
    cookieName : 'pizzaiolo-contactless-popup',
    showAgainSelector: '#show-message'
  });
  $(document).ready(function(){
    $(".dropdown-toggle").dropdown();
  });

  $(document).ready(function() {
    // $("form").attr('autocomplete', 'off');
   
    // if($('div').hasClass('scroll-fixed-top')){
    //     $('.order-table-right').css('max-height','200px')
    // }

    $(window).bind("scroll", function() {
        var scrollTop = $(window).scrollTop();
        var searchFilters = $("#order-summary-table");
        if (searchFilters.length) {
        elementOffset = searchFilters.offset().top;
        distance = elementOffset - scrollTop;
            //console.log(distance)
            if (distance < 100) {
                if($('footer').isInViewport()){
                    $("#order-summary-table .summary-container").removeClass("scroll-fixed-top");
                    $("#order-summary-table .summary-container").addClass("scroll-fixed-bottom");
                    
                }else{
                    $("#order-summary-table .summary-container").addClass("scroll-fixed-top");
                    windowHeight = $(window).height();
                    divHeight = windowHeight - (80+100+175+170)
                    $('.summery-table').css('max-height',divHeight+'px')
                    $("#order-summary-table .summary-container").removeClass("scroll-fixed-bottom");
                }
                

            } else {
                $("#order-summary-table .summary-container").removeClass("scroll-fixed-top");
                $("#order-summary-table .summary-container").removeClass("scroll-fixed-bottom");
                
            }
        }
        // console.log(scrollTop)
    });

    if ( $( "#add_product" ).length ) {
        pizza_size_prices_update();   
    }

    $.fn.isInViewport = function() {
        var elementTop = $(this).offset().top;
        var elementBottom = elementTop + $(this).outerHeight();
        var viewportTop = $(window).scrollTop();
        var viewportBottom = viewportTop + $(window).height();
        return elementBottom > viewportTop && elementTop < viewportBottom;
     };
    
    
    $("input[type=radio][name='product[pizza_size]']").change(function() {
        updateToLarge(this.value);
    });
    $('.upsize-btn a').click(function(){
        size = $(this).find('span.size').html()
        currentPizza = $("input[type=radio][name='product[pizza_size]']:checked").val();

        if(size == "LG" && currentPizza=="gluten-free-small"){
            $("#product_pizza_size_gluten-free").prop("checked",true);
            $("#product_pizza_size_gluten-free").trigger("click");
				}
				if(size == "CM" && currentPizza=="cauliflower-s"){
						$("#product_pizza_size_cauliflower-m").prop("checked",true);
						$("#product_pizza_size_cauliflower-m").trigger("click");
				}
        if(size == "M" && currentPizza=="10-inches"){
            $("#product_pizza_size_medium").prop("checked",true);
            $("#product_pizza_size_medium").trigger("click");
        }
        if(size == "LG" && currentPizza=="medium"){
            $("#product_pizza_size_large").prop("checked",true);
            $("#product_pizza_size_large").trigger("click");
        }
        if(size == "XL" && currentPizza=="large"){
            $("#product_pizza_size_xlarge").prop("checked",true);
            $("#product_pizza_size_xlarge").trigger("click");
        }
        if(size == "PARTY" && currentPizza=="xlarge"){
            $("#product_pizza_size_party").prop("checked",true);
            $("#product_pizza_size_party").trigger("click");
        }
        currentPizza = $("input[type=radio][name='product[pizza_size]']:checked").val();
        updateToLarge(currentPizza)
        updateToDown(currentPizza,size)
    }) 

    $('a#downSize').click(function(){

        currentPizza = $("input[type=radio][name='product[pizza_size]']:checked").val();
        //console.log(currentPizza)
        if(currentPizza=="gluten-free"){
            $("#product_pizza_size_gluten-free-small").prop("checked",true);
            $("#product_pizza_size_gluten-free-small").trigger("click");
            $('a#downSize').hide()
        }else if(currentPizza=="large"){
            $("#product_pizza_size_medium").prop("checked",true);
            $("#product_pizza_size_medium").trigger("click");
            $('a#downSize').hide()
        }else if(currentPizza=="xlarge"){
            $("#product_pizza_size_large").prop("checked",true);
            $("#product_pizza_size_large").trigger("click");
            $('a#downSize').show()
        }else if(currentPizza=="party"){
            $("#product_pizza_size_xlarge").prop("checked",true);
            $("#product_pizza_size_xlarge").trigger("click");
            $('a#downSize').show()
        }else{
            $('a#downSize').hide()
        }
        currentPizza = $("input[type=radio][name='product[pizza_size]']:checked").val();
        updateToLarge(currentPizza)
    }) 


    
}); 

function pizza_size_prices_update(){
    var pizza_pre_id = $('#add_product input[name="product[pizza_preset_id]"]').val()
    order_item = $('form#add_product').serializeArray();
    if(order_item.length > 0) {
        var loadPrice = $.ajax({
            type: 'POST',
            url: "/order_items/pizza_size_prices",
            data: order_item,
            success: function(data) { 
                if(data['10_inches'] > 0){
                  $('input[value="10-inches"]').parent().find('span.size_price').html('$'+data['10_inches'].toFixed(2))
                  $('input[value="10-inches"]').attr('upsize-price', data['10_inches'].toFixed(2))
                }

                $('input[value="gluten-free-small"]').parent().find('span.size_price').html('$'+data.gluten_free_small.toFixed(2))
                $('input[value="gluten-free-small"]').attr('upsize-price', data.gluten_free_small.toFixed(2))

                $('input[value="gluten-free"]').parent().find('span.size_price').html('$'+data.gluten_free.toFixed(2))
                $('input[value="gluten-free"]').attr('upsize-price', data.gluten_free.toFixed(2))

                $('input[value="cauliflower-s"]').parent().find('span.size_price').html('$'+data.cauliflower_s.toFixed(2))
                $('input[value="cauliflower-s"]').attr('upsize-price', data.cauliflower_s.toFixed(2))

                $('input[value="cauliflower-m"]').parent().find('span.size_price').html('$'+data.cauliflower_m.toFixed(2))
                $('input[value="cauliflower-m"]').attr('upsize-price', data.cauliflower_m.toFixed(2))


                
                $('input[value="medium"]').parent().find('span.size_price').html('$'+data.medium.toFixed(2))
                $('input[value="medium"]').attr('upsize-price', data.medium.toFixed(2))


                $('input[value="large"]').parent().find('span.size_price').html('$'+data.large.toFixed(2))
                $('input[value="large"]').attr('upsize-price', data.large.toFixed(2))


                $('input[value="xlarge"]').parent().find('span.size_price').html('$'+data.xlarge.toFixed(2))
                $('input[value="xlarge"]').attr('upsize-price', data.xlarge.toFixed(2))

                
                $('input[value="party"]').parent().find('span.size_price').html('$'+data.party.toFixed(2))  
                $('input[value="party"]').attr('upsize-price', data.party.toFixed(2))  

                currentPizza = $('input[type=radio][name="product[pizza_size]"]:checked').val();

                if(currentPizza){
                    updateToLarge(currentPizza)
                }
            }
        });
    }
    
}

function updateToDown(currentPizza,size){

    //console.log(currentPizza + "_____"+size)
    if(size == "LG" && currentPizza=="gluten-free"){
        $('a#downSize').show()  
    }else if(size == "LG" && currentPizza=="large"){
        $('a#downSize').show()  
    }
    else if(size == "XL" && currentPizza=="xlarge"){
        $('a#downSize').show()  
    }
    else if(size == "PARTY" && currentPizza=="party"){
        $('a#downSize').show()  
    }else{
        $('a#downSize').hide() 
    }

}
function updateToLarge(currentPizza){

    if(currentPizza == "gluten-free-small"){
        $('a#downSize').hide() 
        $('.upsize-btn').show() 
        $('.upsize-btn a span.size').html("LG")    
        price = $("#product_pizza_size_gluten-free").attr("topping-price");
        $('.upsize-btn a span.price-dff').html(price)  

        price = parseFloat($("#product_pizza_size_gluten-free").attr("upsize-price"))-parseFloat($("#product_pizza_size_gluten-free-small").attr("upsize-price"));
        $('.upsize-btn a span.price-dff').html(price.toFixed(2)) 
    }else if(currentPizza == "gluten-free"){
        $('.upsize-btn').hide() 
    }else if(currentPizza == "cauliflower-s"){
				$('a#downSize').hide() 
        $('.upsize-btn').show() 
        $('.upsize-btn a span.size').html("CM")    
        price = $("#product_pizza_size_cauliflower-m").attr("topping-price");
        $('.upsize-btn a span.price-dff').html(price)  

				price = parseFloat($("#product_pizza_size_cauliflower-m").attr("upsize-price"))-parseFloat($("#product_pizza_size_cauliflower-s").attr("upsize-price"));
        $('.upsize-btn a span.price-dff').html(price.toFixed(2)) 
		}else if(currentPizza == "cauliflower-m"){
			$('.upsize-btn').hide() 
		}else if(currentPizza == "10-inches"){
        $('a#downSize').hide()
        $('.upsize-btn').show() 
        $('.upsize-btn a span.size').html("M") 
        price = parseFloat($("#product_pizza_size_medium").attr("upsize-price"))-parseFloat($("#product_pizza_size_10-inches").attr("upsize-price"));
        $('.upsize-btn a span.price-dff').html(price.toFixed(2)) 
    }else if(currentPizza == "medium"){
        $('a#downSize').hide()
        $('.upsize-btn').show() 
        $('.upsize-btn a span.size').html("LG") 
        price = parseFloat($("#product_pizza_size_large").attr("upsize-price"))-parseFloat($("#product_pizza_size_medium").attr("upsize-price"));
        $('.upsize-btn a span.price-dff').html(price.toFixed(2))  
    }else if(currentPizza == "large"){
        $('.upsize-btn').show() 
        $('.upsize-btn a span.size').html("XL") 
        price = parseFloat($("#product_pizza_size_xlarge").attr("upsize-price"))-parseFloat($("#product_pizza_size_large").attr("upsize-price"));
        $('.upsize-btn a span.price-dff').html(price.toFixed(2))    
    }else if(currentPizza == "xlarge"){
        $('.upsize-btn').show() 
        $('.upsize-btn a span.size').html("PARTY") 
        price = parseFloat($("#product_pizza_size_party").attr("upsize-price"))-parseFloat($("#product_pizza_size_xlarge").attr("upsize-price"));
        $('.upsize-btn a span.price-dff').html(price.toFixed(2)) 
    }else{
        $('.upsize-btn').hide() 
    }
}

$(".single-contests .button").on('click', function() {
    pizzaName = 	$(this).attr('data-pizza-name');
    $('#pizza_contest_vote_first_name').val('')
    $('#pizza_contest_vote_last_name').val('')
    $('#pizza_contest_vote_email').val('')
    $('#pizza_contest_vote_phone').val('')
    $('#pizza_contest_vote_pizza_name').val(pizzaName)

	$('#contestsModal').modal('show');
});
$("#cancelContests").on('click', function() {
	$('#contestsModal').modal('hide')
	$('#contestsModal').hide()
	$('body').removeClass('modal-open')
})

$(document).ready(function() {
    // Handles on Page load
	if ($('#franchise_location_enable_online_payments').is(':checked')) {
		$('.bambora_dev').show()
		$('.bambora_pro').show()
	} else {
		$('.bambora_dev').hide()
		$('.bambora_pro').hide()
	}

	// Handles on Click event
	$('#franchise_location_enable_online_payments').click(function(){
		if($(this).is(":checked")){
            $('.bambora_dev').show()
            $('.bambora_pro').show()
		}
		else if($(this).is(":not(:checked)")){
            $('.bambora_dev').hide()
            $('.bambora_pro').hide()
		}
    });
    
    

}); 

$(document).ready(function() {
    // Handle on page load
    payment_method = $('#order_method_of_payment_id').val();
    var order_id = $('#order_id').val();

    if(payment_method === "4") {
        $('.place-order-box').addClass('hide')
        $('.payment-box').removeClass('pay-hide')
        $('.tip-summary').removeClass('tip-hide')
				// setting default tip
				$.ajax({
					type: 'POST',
					url: "/orders/set_percentage_tip",
					data: {id: order_id, percentage: 15, tip_type: "percentage"}, // hard coded default to 15%
					success: function(response) { 
							if(response) {
								$(".tip_dollar_value").html(response.tip_amount)
								$(".total_amount_afer_discount").html(response.order_total)
								$(".tip-option-button").removeClass("active")
								$("#15_percent_tip").addClass("active")
							}
					}
				});
    } else {
        $('.payment-box').addClass('pay-hide')
        $('.place-order-box').removeClass('hide')
        $('.tip-summary').addClass('tip-hide')
        // clearing tip data
        $.ajax({
            type: 'POST',
            url: "/orders/clear_tip",
            data: {id: order_id},
            success: function(response) { 
                if(response) {
                   $(".tip_dollar_value").html(response.tip_amount)
                   $(".total_amount_afer_discount").html(response.order_total)
                   $("#30_percent_tip").removeClass("active")
                   $("#15_percent_tip").removeClass("active")
                   $("#20_percent_tip").removeClass("active")
                   $("#25_percent_tip").removeClass("active")
                   $("#10_percent_tip").removeClass("active")
                }
            }
        });
    }

    // $("#order_method_of_payment_id").change(function() {
    //     method_of_payment = $('#order_method_of_payment_id').val();
    //     //TODO: needs to create a slug in place of id
    //     if(method_of_payment === "4") {
    //         $('.place-order-box').addClass('hide')
    //         $('.payment-box').removeClass('pay-hide')
    //         $('.tip-summary').removeClass('tip-hide')
    //     } else {
    //         $('.payment-box').addClass('pay-hide')
    //         $('.place-order-box').removeClass('hide')
    //         $('.tip-summary').addClass('tip-hide')
    //         // clearing tip data
    //         $.ajax({
    //             type: 'POST',
    //             url: "/orders/clear_tip",
    //             data: {id: order_id},
    //             success: function(response) { 
    //                 if(response) {
    //                    $(".tip_dollar_value").html(response.tip_amount)
    //                    $("#30_percent_tip").removeClass("active")
    //                    $("#15_percent_tip").removeClass("active")
    //                    $("#20_percent_tip").removeClass("active")
    //                    $("#25_percent_tip").removeClass("active")
    //                    $("#10_percent_tip").removeClass("active")
    //                 }
    //             }
    //         });
    //     }
    // })

    $(".payment_type .pay_type").click(function() {
        var method_of_payment = $(this).attr('data-pay_id');
				var order_id = $('#order_id').val();
        //TODO: needs to create a slug in place of id
        $(".pay_type").removeClass('selected')
        $(this).addClass('selected')
        //alert(method_of_payment)
        $('#order_method_of_payment_id option[value="'+method_of_payment+'"]').prop('selected', true)
       
        if(method_of_payment === "4") {
            $('.place-order-box').addClass('hide')
            $('.payment-box').removeClass('pay-hide')
            $('.tip-summary').removeClass('tip-hide') 
            // setting default tip
            $.ajax({
                type: 'POST',
                url: "/orders/set_percentage_tip",
                data: {id: order_id, percentage: 15, tip_type: "percentage"}, // hard coded default to 15%
                success: function(response) { 
                    if(response) {
                        $(".tip_dollar_value").html(response.tip_amount)
                        $(".total_amount_afer_discount").html(response.order_total)
                        $(".tip-option-button").removeClass("active")
                        $("#15_percent_tip").addClass("active")
                    }
                }
            });
        } else {
            $('.payment-box').addClass('pay-hide')
            $('.place-order-box').removeClass('hide')
            $('.tip-summary').addClass('tip-hide')
            // clearing tip data
            $.ajax({
                type: 'POST',
                url: "/orders/clear_tip",
                data: {id: order_id},
                success: function(response) { 
                    if(response) {
											$(".tip_dollar_value").html(response.tip_amount)
											if(response.order_total !== "$0.00") {
												$(".total_amount_afer_discount").html(response.order_total)
											}
											$("#30_percent_tip").removeClass("active")
											$("#15_percent_tip").removeClass("active")
											$("#20_percent_tip").removeClass("active")
											$("#25_percent_tip").removeClass("active")
											$("#10_percent_tip").removeClass("active")
                    }
                }
            });
        }
    })

});

$(document).ready(function() {
    setTimeout(function() {
        $('#billing_address_as_shipping_address').trigger('click');
    }, 100);
    $('#billing_address_as_shipping_address').change(function() {
        if($(this).is(':checked')) {
            data = $('#billing_address_as_shipping_address').data('order_attributes')
            $('#bambora_name').val(data.first_name + " " + data.last_name);
            $('#bambora_email').val(data.email);
            $('#bambora_address_line1').val(data.address_1);
            $('#bambora_address_line2').val(data.address_2);
            $('#bambora_city').val(data.city);
            $('#bambora_postal_code').val(data.postal_code);
            $('#bambora_phone_number').val(data.phone_number);
            $('#bambora_province').val(data.province || "ON").prop('selected', true);
            $('#bambora_country').val(data.country || "CA").prop('selected', true);
        } else {
            $('#bambora_name').val("");
            $('#bambora_email').val("");
            $('#bambora_address_line1').val("");
            $('#bambora_address_line2').val("");
            $('#bambora_city').val("");
            $('#bambora_postal_code').val("");
        }
    })

});

$(document).ready(function() {

    var tip_percentage_value = $("#tip_percentage_value").val()
    
    switch(tip_percentage_value) {
        case "10": 
            $("#10_percent_tip").addClass("active")
            break;
        case "15": 
            $("#15_percent_tip").addClass("active")
            break;
        case "20": 
            $("#20_percent_tip").addClass("active")
            break;
        case "25": 
            $("#25_percent_tip").addClass("active")
            break;
        case "0": 
            $("#custom-tip").addClass("active")
            $("#custom-tip-wrapper").removeClass("hide")
            break;
        default:
            $("#custom-tip").addClass("active")
            $("#custom-tip-wrapper").removeClass("hide")
            break;
    }

    $(".tip-option-button").click(function() {
        var percentage = parseFloat($(this).attr('data-percentage'));
        var div_id = $(this).attr('id');
        var order_id = $('#order_id').val();
        var url = ""
        var tip_type = ""
        if(percentage >= 0) {
            url = "/orders/set_percentage_tip"
            tip_type = "percentage"
            $.ajax({
                type: 'POST',
                url: url,
                data: {id: order_id, percentage: percentage, tip_type: tip_type},
                success: function(response) { 
                    if(response) {
                        $(".tip_dollar_value").html(response.tip_amount)
                        $(".total_amount_afer_discount").html(response.order_total)
                        $(".tip-option-button").removeClass("active")
                        $("#"+div_id).addClass("active")
                        
                        if(div_id == "custom-tip") {
                            $("#custom-tip-wrapper").removeClass("hide")
                        } else {
                            $("#custom-tip-wrapper").addClass("hide")
                        }
                    }
                }
            });
        }
        
    })

    $("#custom_tip_amount").on("keyup", function() {
        var amount = parseFloat($(this).val());
        var order_id = $('#order_id').val();
        if(amount < 0 || isNaN(amount)) {
            alert("Please enter tip amount.")
        } else {
            $.ajax({
                type: 'POST',
                url: "/orders/set_percentage_tip",
                data: {id: order_id, percentage: 0, tip_type: "dollar_value", tip_amount: amount},
                success: function(response) { 
                    if(response) {
                        $(".tip_dollar_value").html(response.tip_amount)
                        $(".total_amount_afer_discount").html(response.order_total)
                        $(".tip-option-button").removeClass("active")
                        $("#custom-tip").addClass("active")
                    }
                }
            });
        }
    })

});

$(document).ready(function() {
    $(document).on('click', '.multiple-customize-btn', function (e) {
        dealModalId = $(this).attr('data-deal-item')
        if(dealModalId){
          $("body").addClass("pp-deal-modal-open")
					$("#"+dealModalId).show()
        }
    });

    // $(document).on(eventTrigger, '.close', function (event) {
		// 	closeModalId = $(this).attr('data-deal-item')
		// 	if(closeModalId){
		// 		$("#"+closeModalId).hide()
		// 		$('.deal-order-complete-meal-btn').show()
		// 		$('.nav-mobile-item').show()
		// 	}
		// });
});





$(document).on('click', 'input.deal_hideshow_topping', function (e) {
    dt_id = $(this).attr('data-topping-id')
    index = $(this).attr('data-index')
    if($(this).attr('data-freeze-topping') === "true") {
        alert("Required toppings can't be altered.")
        return false;
    }
	if($(this).is(':checked')){
		$(this).closest("form").find("#product_toppings_topping-" + dt_id + "_preference").removeAttr('disabled');
		$(this).closest("form").find("#product_toppings_topping-" + dt_id + "_position").removeAttr('disabled');
        $(this).parent().parent().addClass('selectedTopping');
	}else{
		$(this).closest("form").find("#product_toppings_topping-" + dt_id + "_preference").attr('disabled', 'disabled');
		$(this).closest("form").find("#product_toppings_topping-" + dt_id + "_position").attr('disabled', 'disabled');
        $(this).parent().parent().removeClass('selectedTopping');
	}
	order_item = $(this).closest("form").serializeArray();
	$.post("/order_items/deal_live_calculate", order_item );
	pizza_size_prices_update()
	$(this).closest("form").find("#product_toppings_topping-" + dt_id ).toggle();
    $(this).closest("form").find("#product_toppings_topping-" + dt_id + "_preference_group_" + index).toggle();
    $(this).closest("form").find("#product_toppings_topping-" + dt_id + "_position_group_" + index ).toggle();
	// $(this).closest("form").find("#product_toppings_topping-" + dt_id + "_preference").toggle();
	// $(this).closest("form").find("#product_toppings_topping-" + dt_id + "_position").toggle();
})


$(document).on('click', 'input.deal_product_pizza_crust', function (e) {
	$(this).closest("form").find('.product_toppings_group').show();
	order_item = $(this).closest("form").serializeArray();
	$.post("/order_items/deal_live_calculate", order_item );
	pizza_size_prices_update()
})
	
$(document).on('click', 'input.deal_product_pizza_crust_style', function (e) {
	order_item = $(this).closest("form").serializeArray();
	$.post("/order_items/deal_live_calculate", order_item );
	pizza_size_prices_update()
})	

$(document).on('change', 'select.deal_topping_preference', function (e) {
	order_item = $(this).closest("form").serializeArray();
	$.post("/order_items/deal_live_calculate", order_item );
	pizza_size_prices_update()
})	

$(document).on('change', 'select.deal_topping_position', function (e) {
	order_item = $(this).closest("form").serializeArray();
	$.post("/order_items/deal_live_calculate", order_item );
	pizza_size_prices_update()
})	

function dataDealItem(index){
	$('#submit').off('click');
	if(index >= 0 ){
		$("body").removeClass("pp-deal-modal-open")
		$("#deal_order_item_modal_"+index).hide()
	}
	return false;
}

$('.confirm_catering_order').on('click', function(){
    $.confirm({
      title: '',
      content: 'Would you like to add your catering selection to your order before adding a custom pizza to your catering order?',
      buttons: {
        yes: {
            text: 'YES',
            btnClass: 'catering-yes-btn',
            action: function(){
                order_item = $('form#add_additional_to_order').serializeArray();
                $.post("/orders/add_additional_to_order", order_item, function(response) {
                    window.location.href = "/orders?pizza_preset_id=82&is_catering_order=1";
                });
            }
        },
        no: {
            text: 'NO',
            btnClass: 'catering-modal-no-btn',
            action: function(){
                window.location.href = "/orders?pizza_preset_id=82&is_catering_order=1"; 
            }
        }
      }
    });
  });

  $(document).ready(function(){
    $("a.pizza-tab-btn").on('click', function(event) {
      if(!$(this).hasClass( "active" )){
        $("a.pizza-tab-btn").removeClass("active")
				$(this).addClass("active")
				$("#viewContainer").scrollCenter(".active", 1000);
        var hash = $(this).attr('data-href');
        if (hash !== "") {
					event.preventDefault();
					window.scrollTo({
						top: $("#"+hash).offset().top -  120,
						behavior: 'smooth',
					})
          // $('html, body').animate({
          //   scrollTop:  $("#"+hash).offset().top -  120 + 'px'   //$target.offset().top - $header.height() + 50 + 'px'
          // }, 200000, function(){
          //   //window.location.hash = hash;
          // });
        } 
      }
    });
	});
	
	jQuery.fn.scrollCenter = function(elem, speed) {

		// this = #timepicker
		// elem = .active
	
		var active = jQuery(this).find(elem);
		//var activeWidth = active.width(); // get active width
		var activeWidth = active.width() / 2; // get active width center
	
		//alert(activeWidth)
	
		//var pos = jQuery('#timepicker .active').position().left; //get left position of active li
		// var pos = jQuery(elem).position().left; //get left position of active li
		//var pos = jQuery(this).find(elem).position().left; //get left position of active li
		var pos = active.position().left + activeWidth; //get left position of active li + center position
		var elpos = jQuery(this).scrollLeft(); // get current scroll position
		var elW = jQuery(this).width(); //get div width
		//var divwidth = jQuery(elem).width(); //get div width
		pos = pos + elpos - elW / 2; // for center position if you want adjust then change this
	
		jQuery(this).animate({
			scrollLeft: pos
		}, speed == undefined ? 1000 : speed);
		return this;
	};
	
	jQuery.fn.scrollCenterORI = function(elem, speed) {
		jQuery(this).animate({
			scrollLeft: jQuery(this).scrollLeft() - jQuery(this).offset().left + jQuery(elem).offset().left
		}, speed == undefined ? 1000 : speed);
		return this;
	};
    

    
    // $(document).ready(function(){ 
		// 	if($("body").hasClass("catering_home_page")){
		// 		var slider = document.querySelector('.nav-tabs');
		// 		var isDown = false;
		// 		var startX;
		// 		var scrollLeft;
		// 		slider.addEventListener('mousedown', (e) => {
		// 				isDown = true;
		// 				slider.classList.add('active');
		// 				startX = e.pageX - slider.offsetLeft;
		// 				scrollLeft = slider.scrollLeft;
		// 		});
		// 		slider.addEventListener('mouseleave', () => {
		// 				isDown = false;
		// 				slider.classList.remove('active');
		// 		});
		// 		slider.addEventListener('mouseup', () => {
		// 				isDown = false;
		// 				slider.classList.remove('active');
		// 		});
		// 		slider.addEventListener('mousemove', (e) => {
		// 				if(!isDown) return;
		// 				e.preventDefault();
		// 				var x = e.pageX - slider.offsetLeft;
		// 				var walk = (x - startX) * 1; //scroll-fast
		// 				slider.scrollLeft = scrollLeft - walk;
		// 				console.log(walk);
		// 		});
    //   }
    // })

  $(".google-autocomplete").on('focus', function() {
    isAutoCompletedSelected = false;
    $(this).attr("autocomplete", (Math.random() * 100000).toString());
  })
  $(".google-autocomplete").on('focusout', function() {
    var input  = $(this)
    formType = input.attr('data_id');
    setTimeout(function(){
      if(isAutoCompletedSelected){
        console.log("address selected")
        input.parent().parent().find("span").remove();
      }else{
         console.log("address not selected")
          if(formType == "order-form") {
            $("#order_address_1").val("");
            $("#order_city").val("");
            $("#order_postal_code").val("");
          }

          if(formType == "signup-form") {
            $("#customer_address_1").val("");
            $("#customer_city").val("");
            $("#customer_postal_code").val("");
          }

          if(formType == "new-delivery-form") {
            $(".add1").val("");
            $(".city1").val("");
            $(".pin1").val("");
          }

          if(formType == "payment-form") {
            $("#bambora_address_line1").val("");
            $("#bambora_city").val("");
            $("#bambora_postal_code").val("");
          }

          if(formType == "edit-customer-form") {
            $("#customer_address_1").val("");
            $("#customer_city").val("");
            $("#customer_postal_code").val("");
          }

          if(formType == "delivery-address-form") {
            $("#order_delivery_address_1").val("");
            $("#order_delivery_city").val("");
            $("#order_delivery_postal_code").val("");
          }
         input.parent().parent().find("span").remove()
         input.parent().parent().append('<span style="padding-top: 15px; justify-content: left; width: 100%; color: red; font-size: 12px; display: flex; ">You must select an address from the dropdown list</span>');
      }
     }, 500);
  })