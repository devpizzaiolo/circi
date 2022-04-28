$(document).ready(function(){
	$(".remove-address-icon").on('click', function() {
		if(confirm("Are you sure!, you want to delete it ?")){
			address_id = $(this).attr('id');
			if (address_id) {
				$.post("/customers/orders/"+address_id+"/remove_address", {id: address_id}, function(response) {
					if(response.status === "success"){
						$('#'+address_id).parent().hide('1000');
					}
				});
			} 
		}
	});


	$('.pizza-select').on('swipeleft', function(){
		$('.product-image').css('left', '100vw');
		$(this).find('.product-image').css('left', '0');
	});

	$('.product-image .close-preview').on('click', function(){
		$('.product-image').css('left', '100vw');
	});

	$("#deliver_asap").on('click', function() {
		$.get("/orders/order_asap_check", function(response){
			if(response.display_popup) {
				// display popup
				$('#asap_date').html(response.date);
				$('#asap_modal').modal('show');
			} else {
				// continue
				window.location.href = "/orders/summary"
			}
		});
	});

	$("#cancelOrder").on('click', function() {
		window.location.href = "/orders"
	})

	$("#doAsapOrder").on('click', function() {
		window.location.href = "/orders/order_asap"
	})
	
});

var windowWidth = $(window).width();
var eventTrigger = 'click';

if (windowWidth < 768) {
	var eventTrigger = 'click';
}


$(document).on(eventTrigger, '.show-next', function () {
    // e.preventDefault();

	scrollElement = $(this).offset().top;
	
	$(this).hide();
	$('.next-div').show();
	$('html, body').animate({
        scrollTop: scrollElement
    }, 500);
});

$(document).on(eventTrigger, '.show-details', function (e) {
    e.preventDefault();

	scrollElement = $(this).siblings('.item_title').first().offset().top;
	
	$(this).removeClass('show-details').addClass('hide-details');
	$(this).siblings('.item-details').show();

	$('html, body').animate({
        scrollTop: scrollElement
    }, 800);
});

$(document).on(eventTrigger, '.hide-details', function (e) {
    e.preventDefault();

	scrollElement = $(this).siblings('.item_title').first().offset().top;
	
	$(this).removeClass('hide-details').addClass('show-details');
	$(this).siblings('.item-details').hide();

	$('html, body').animate({
        scrollTop: scrollElement
    }, 800);
});

$(document).on(eventTrigger, 'a.back_to_categories', function(e) {
	e.preventDefault();

	$('#all-categories, #select_products').show();
	$('.tab-content').hide();
	$('.homepage-headings').show();
	$('#order_table').removeClass('visible');
});

// $(document).on('click', '.pizza_category', function(){
// 	var heading = $(this).find('h2').text();
// 	$('#all-categories, .homepage-headings').hide();
// 	$('.tab-content').show();
// 	$('#pizza_list h1 span').text(heading);

// 		$('html, body').animate({
// 	        scrollTop: 0
// 	    }, 800);
// });

// PLUS AND MINUS ACTIONS INPUT

$(document).on(eventTrigger, '.right-cell .minus', function() {
	steps = $(this).attr('data-steps');
	quantityInput = $(this).next('input');
	quantityValue = Number(quantityInput.val());
	
	if (quantityValue > 0) {
		if(parseInt(steps) === 5) {
			quantityValue = quantityValue - 5
		} else {
			quantityValue = quantityValue - 1
		}
	} else {
		quantityValue = 0
	}

	quantityInput.val(quantityValue);

	additional_items = $('form#add_additional_to_order').serializeArray();
	$.post("/orders/live_calculate_additional_items", additional_items );
});

$(document).on(eventTrigger, '.right-cell .plus', function() {
	steps = $(this).attr('data-steps');
	quantityInput = $(this).prev('input');
	quantityValue = Number(quantityInput.val());
	
	if (quantityValue >= 0) {
		if(parseInt(steps) === 5) {
			quantityValue = quantityValue + 5
		} else {
			quantityValue = quantityValue + 1
		}
	} else {
		quantityValue = 0
	}

	quantityInput.val(quantityValue);

	additional_items = $('form#add_additional_to_order').serializeArray();
	$.post("/orders/live_calculate_additional_items", additional_items );
});

$(document).on('change', '.right-cell .utensil_quantity', function() {
	additional_items = $('form#add_additional_to_order').serializeArray();
	$.post("/orders/live_calculate_additional_items", additional_items );
});


$(document).on(eventTrigger, '.details-upsize-button', function() {
	var order_item_id = $(this).attr('data_order_item_id');
	var order_id = $(this).attr('data_order_id');
	var upsize = $(this).attr('data_upsize');
	
	if(order_id && order_item_id && upsize) {
		$.post("/order_items/"+order_item_id+"/change_pizza_size_details", {order_id: order_id, size: upsize}, function(response) {
			$("#details_cart").html(response);
		});
	}
});

// $(document).on(eventTrigger, '.details-downsize-button', function() {
// 	var order_item_id = $(this).attr('data_order_item_id');
// 	var order_id = $(this).attr('data_order_id');
// 	var downsize = $(this).attr('data_downsize');
	
// 	if(order_id && order_item_id && downsize) {
// 		$.post("/order_items/"+order_item_id+"/change_pizza_size_details", {order_id: order_id, size: downsize}, function(response) {
// 			$("#details_cart").html(response);
// 		});
// 	}
// });

// on category page size change

// Handle Customize event on Categories Page
$(document).on("change", '.category_pizza_sizes input.category_size_upgrade_btn', function() {
	var size = $(this).val();
	var pizzaID = $(this).attr('data-pizza-id');
	$('a[data_id="'+pizzaID+'"]').attr('data_size', size)
});

// Handle Customize event on Categories Page
$(document).on("change", '.category_pizza_sizes input.catering_pizza_size_upgrade_btn', function() {
	var pizzaID = $(this).attr('data-pizza-id');
	var pizzaPrice = $(this).attr('data-pizza-price');
	var selectedSize = $(this).attr('data-pizza-size');
	var selectedPrice = $(this).attr('data-pizza-formated-price');
	$(".title_"+pizzaID).html(selectedSize)
	$(".price_"+pizzaID).html(selectedPrice)
	$("#catering_pizza_price_upgrade_"+pizzaID).val(pizzaPrice)
	additional_items = $('form#add_additional_to_order').serializeArray();
	$.post("/orders/live_calculate_additional_items", additional_items );
});

// Handle Customize event on Categories Page
$(document).on(eventTrigger, '.add_to_cart_customize', function() {
	var index = $(this).attr('data_id');
	var size = $(this).attr('data_size');
	var slug = $(this).attr('data_slug');
	var quantity = $("#item_qty_"+index).val();
	var pizza_preset_id = $("#pizza_preset_id_"+index).val();

	//if(pizza_preset_id) {
	if(slug) {
		window.location = "/orders/pizza/"+ slug + "?quantity=" + quantity + "&pizza_size=" + size
	}
});

// Handle Add To Cart event on Categories Page
$(document).on(eventTrigger, '.add_to_cart_point_details', function() {
	var index = $(this).attr('data_id');
	var size = $(this).attr('data_size');
	var slug = $(this).attr('data_slug');
	var quantity = $("#item_qty_" + index).val();
	var pizza_preset_id = $("#pizza_preset_id_" + index).val();
	
	// if(pizza_preset_id) {
	if(slug) {
		window.location = "/orders/complete_meal?slug="+slug+"&quantity="+quantity+"&pizza_size="+size
	} else {
		// window.location = "/orders/complete_meal?pizza_preset_id="+pizza_preset_id+"&quantity="+quantity+"&pizza_size="+size
	}
});

// Handle Plus Quantity Change of Order Additionals
$(document).on(eventTrigger, '.order-additional-quantity .plus_pizza', function() {
	var index = $(this).parent().attr('data_order_additional_index');
	var key = $(this).parent().attr('data_key');
	var order_additional = $(this).parent().attr('data_order_additional');
	var order_id = $(this).parent().attr('data_order_id');
	var order_additional_id = $("#"+key+"_"+index).val();
	var quantity = $("#"+key+"_qty_"+index).val();
	quantity = parseInt(quantity) + 1;
	
	if(key && order_additional && order_id && order_additional_id && quantity) {
		$.post("/orders/"+order_id+"/update_order_additional_quantity_details", {quantity: quantity, order_additional_id: order_additional_id, order_additional: order_additional}, function(response) {
			$("#details_cart").html(response);
		});
	}
});

$(document).on('change', '.order-additional-quantity .utensil_quantity', function() {
	var index = $(this).attr('data_order_additional_index');
	var key = $(this).attr('data_key');
	var order_additional = $(this).attr('data_order_additional');
	var order_id = $(this).attr('data_order_id');
	var order_additional_id = $(this).attr('data_order_additional_id');
	var quantity = $(this).val();
	if(key && order_additional && order_id && order_additional_id && quantity) {
		$.post("/orders/"+order_id+"/update_order_additional_quantity_details", {quantity: quantity, order_additional_id: order_additional_id, order_additional: order_additional}, function(response) {
			$("#details_cart").html(response);
		});
	}
});

// Handle Minus Quantity Change of Order Additionals
$(document).on(eventTrigger, '.order-additional-quantity .minus_pizza', function() {
	var index = $(this).parent().attr('data_order_additional_index');
	var key = $(this).parent().attr('data_key');
	var order_additional = $(this).parent().attr('data_order_additional');
	var order_id = $(this).parent().attr('data_order_id');
	var order_additional_id = $("#"+key+"_"+index).val();
	var quantity = $("#"+key+"_qty_"+index).val();
	// quantity = parseInt(quantity) + 1;
	
	if(key && order_additional && order_id && order_additional_id && quantity && parseInt(quantity) > 1) {
		quantity = parseInt(quantity) - 1;
		$.post("/orders/"+order_id+"/update_order_additional_quantity_details", {quantity: quantity, order_additional_id: order_additional_id, order_additional: order_additional}, function(response) {
			$("#details_cart").html(response);
		});
	}
});

// Handle Minus Quantity Change of Order Additionals via input keypress
$(document).on("keyup", '.order-additional-quantity .order_additional_qty', function(event) {
	var index = $(this).parent().attr('data_order_additional_index');
	var key = $(this).parent().attr('data_key');
	var newVal = parseInt($(this).val());
	var oldVal = parseInt($(this).data("previousvalue"));
	
	if(newVal > 0){
		var order_additional = $(this).parent().attr('data_order_additional');
		var order_id = $(this).parent().attr('data_order_id');
		var order_additional_id = $("#" + key + "_" + index).val();
		var quantity = newVal;
		if(key && order_additional && order_id && order_additional_id && quantity && parseInt(quantity) > 1) {
			$.post("/orders/"+order_id+"/update_order_additional_quantity_details", {quantity: quantity, order_additional_id: order_additional_id, order_additional: order_additional}, function(response) {
				$("#details_cart").html(response);
			});
		}
	} else {
		$("#" + key + "_qty_" + index).val(oldVal);
		alert("Please provide a valid quantity");
		return false;
	}
});

// Prevent Form submit on google autocomplete field
$('.google-autocomplete').keydown(function (e) {
	if (e.keyCode == 13) {
			e.preventDefault();
			return false;
	}
});

// For handling pizza count on Details page for deal section
$(document).on(eventTrigger, '.deal-cart-quantity .plus_pizza', function() {
	var index = $(this).parent().parent().attr('data-index');
	var order_id = $('#order_id_'+index).val();
	var deal_id = $('#deal_id_'+index).val();
	var deal_qty = $("#quantity_"+index).val();
	deal_qty = parseInt(deal_qty) + 1;

	if(order_id && deal_id && deal_qty) {
		$.post("/orders/" + order_id + "/update_deal_quantity", {deal_id: deal_id, quantity: deal_qty}, function(response) {
			$("#details_cart").html(response);
		});
	}
});

// For handling pizza count on Details page for deal section
$(document).on(eventTrigger, '.deal-cart-quantity .minus_pizza', function() {
	var index = $(this).parent().parent().attr('data-index');
	var order_id = $('#order_id_'+index).val();
	var deal_id = $('#deal_id_'+index).val();
	var deal_qty = $("#quantity_"+index).val();
	if(parseInt(deal_qty) > 1) { 
		deal_qty = parseInt(deal_qty) - 1;
		
		if(order_id && deal_id && deal_qty) {
			$.post("/orders/" + order_id + "/update_deal_quantity", {deal_id: deal_id, quantity: deal_qty}, function(response) {
				$("#details_cart").html(response);
			});
		}
	}
});

// For handling pizza count on Details page for deal section
$(document).on("keyup", '.deal-cart-quantity .deal_order_qty', function(event) {
	newVal = parseInt($(this).val());
	oldVal = parseInt($(this).data("previousvalue"));
	var index = $(this).parent().parent().attr('data-index');
	var order_id = $('#order_id_'+index).val();
	var deal_id = $('#deal_id_'+index).val();
	if(newVal > 0){
		var deal_qty = newVal;
		if(parseInt(deal_qty) > 0) {
			if(order_id && deal_id && deal_qty) {
				$.post("/orders/" + order_id + "/update_deal_quantity", {deal_id: deal_id, quantity: deal_qty}, function(response) {
					$("#details_cart").html(response);
				});
			}
		}
	}
	else{
		$("#quantity_"+index).val(oldVal);
		alert("Please provide a valid quantity");
		return false;
	}
});

// For handling pizza count on Details page
$(document).on(eventTrigger, '.details-cart-quantity .plus_pizza', function() {
	var index = $(this).parent().parent().attr('data_id')
	var order_item_id = $('#order_item_id_'+index).val();
	var order_item_qty = $("#order_item_qty_"+index).val();
	order_item_qty = parseInt(order_item_qty) + 1;

	if(order_item_id && order_item_qty) {
		$.post("/order_items/"+order_item_id+"/update_quantity_details", {quantity: order_item_qty}, function(response) {
			$("#details_cart").html(response);
		});
	}
});

// For handling pizza count on Details page
$(document).on(eventTrigger, '.details-cart-quantity .minus_pizza', function() {
	var index = $(this).parent().parent().attr('data_id')
	var order_item_id = $('#order_item_id_'+index).val();
	var order_item_qty = $("#order_item_qty_"+index).val();
	if(parseInt(order_item_qty) > 1) { 
		order_item_qty = parseInt(order_item_qty) - 1;
		
		if(order_item_id && order_item_qty) {
			$.post("/order_items/"+order_item_id+"/update_quantity_details", {quantity: order_item_qty}, function(response) {
				$("#details_cart").html(response);
			});
		}
	}
});


// For handling pizza count on Details page
$(document).on("keyup", '.details-cart-quantity .order_item_qty', function(event) {
	newVal = parseInt($(this).val());
	oldVal = parseInt($(this).data("previousvalue"));
	var index = $(this).parent().parent().attr('data_id')
	if(newVal > 0){
		var order_item_id = $('#order_item_id_'+index).val();
		var order_item_qty = newVal;
		if(parseInt(order_item_qty) > 0) {
			if(order_item_id && order_item_qty) {
				$.post("/order_items/" + order_item_id + "/update_quantity_details", { quantity: order_item_qty }, function(response) {
					$("#details_cart").html(response);
				});
			}
		}
	}
	else{
		$("#order_item_qty_"+index).val(oldVal);
		alert("Please provide a valid quantity");
		return false;
	}
});

// For handling pizza count on Category page
$(document).on(eventTrigger, '.categories-cart-quantity .plus_pizza', function() {
	var index = $(this).parent().parent().attr('data_id')
	var order_item_qty = $("#item_qty_"+index).val();
	order_item_qty = parseInt(order_item_qty) + 1;

	$("#item_qty_"+index).val(order_item_qty);
});

// For handling pizza count on Category page
$(document).on(eventTrigger, '.categories-cart-quantity .minus_pizza', function() {
	var index = $(this).parent().parent().attr('data_id')
	var order_item_qty = $("#item_qty_"+index).val();
	if(parseInt(order_item_qty) > 1) { 
		order_item_qty = parseInt(order_item_qty) - 1;
		$("#item_qty_"+index).val(order_item_qty);
	}
});

// For handling pizza count
$(document).on(eventTrigger, '.product-quantity .plus_pizza', function() {
	var order_item_id = $('#order_item_id').val();
	var order_item_qty = $('#order_item_qty').val();
	order_item_qty = parseInt(order_item_qty) + 1;
	
	if(order_item_id && order_item_qty) {
		$.post("/order_items/" + order_item_id + "/update_quantity", { quantity: order_item_qty }, function(response) {
			$("#inline_calculator").html(response);
			$("#order_item_qty").val(parseInt(order_item_qty));
			$("input[name='product[quantity]']").val(order_item_qty);
		});
	}
});

// For handling pizza count
$(document).on(eventTrigger, '.product-quantity .minus_pizza', function() {
	var order_item_id = $('#order_item_id').val();
	var order_item_qty = $('#order_item_qty').val();
	if(parseInt(order_item_qty) > 1) { 
		order_item_qty = parseInt(order_item_qty) - 1;
		
		if(order_item_id && order_item_qty) {
			$.post("/order_items/"+order_item_id+"/update_quantity", {quantity: order_item_qty}, function(response) {
				$("#inline_calculator").html(response);
				$("#order_item_qty").val(parseInt(order_item_qty));
				$("input[name='product[quantity]']").val(order_item_qty);
			});
		}
	}
});

// For handling pizza count on focus out
$(document).on('focusout', '#order_item_qty', function() {
	var order_item_id = $('#order_item_id').val();
	var order_item_qty = $('#order_item_qty').val();
	if(parseInt(order_item_qty) >= 1) {
	 if(order_item_id && order_item_qty) {
		$.post("/order_items/"+order_item_id+"/update_quantity", {quantity: order_item_qty}, function(response) {
			$("#inline_calculator").html(response);
			$("#order_item_qty").val(parseInt(order_item_qty));
			$("input[name='product[quantity]']").val(order_item_qty);
		});
	 }
	}
});

// PLUS AND MINUS ACTIONS INPUT FOR COMBO PRODUCT

$(document).on('keyup', '.additional_items_form_combo', function() {
	quantityInput = $(this).next('input');
	quantityValue = Number(quantityInput.val());

	quantityInput.val(quantityValue);
	additional_items = $('form#add_product').serializeArray();
	$.ajax({
		type: 'POST',
		url: "/orders/live_calculate_additional_for_combo_items",
		data: additional_items,
		success: function(data) { 
	 
		}
	});
});


$(document).on(eventTrigger, '.product_additional_group .order-item-row .right-cell-combo .minus', function() {
	quantityInput = $(this).next('input');
	quantityValue = Number(quantityInput.val());
	
	if (quantityValue > 0) {
		quantityValue = quantityValue - 1
	} else {
		quantityValue = 0
	}

	quantityInput.val(quantityValue);
	additional_items = $('form#add_product').serializeArray();
	$.ajax({
		type: 'POST',
		url: "/orders/live_calculate_additional_for_combo_items",
		data: additional_items,
		success: function(data) { 
	 
		}
	});
});

$(document).on(eventTrigger, '.product_additional_group .order-item-row  .right-cell-combo .plus', function() {
	quantityInput = $(this).prev('input');
	quantityValue = Number(quantityInput.val());
	
	if (quantityValue >= 0) {
		quantityValue = quantityValue + 1
	} else {
		quantityValue = 0
	}

	quantityInput.val(quantityValue);
	additional_items = $('form#add_product').serializeArray();
	$.ajax({
		type: 'POST',
		url: "/orders/live_calculate_additional_for_combo_items",
		data: additional_items,
		success: function(data) { 
		 
		}
	});
});

