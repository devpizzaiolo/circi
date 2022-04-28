// apply discound code on order
$(document).on('click', "#submit_discount_code", function() {
  var discount_code = $('#discount_code').val();
  var order_id = $(this).data('order_id');

  if(discount_code == "") {
    alert("Please enter discount code.");
    return;
  }

  if(order_id) {
    $.post("/orders/"+order_id+"/apply_discount_code", {discount_code: discount_code}, function(response) {
      if(response.is_valid) {
        $("#discount_code").removeClass('invalid_input ');
        $(".discount_code_error").html("");
        $("#remove_discount_code").removeClass('hide');
        $("#submit_discount_code").addClass('hide');
        $("#discount_code").prop('disabled', true);
        $(".discount-summary").removeClass('hide');
      } else {
        $("#discount_code").val(response.discount_code);
        $("#discount_code").addClass('invalid_input ');
        $(".discount_code_error").html(response.error_message);
        $("#remove_discount_code").addClass('hide');
        $("#submit_discount_code").removeClass('hide');
        $("#discount_code").prop('disabled', false);
        $(".discount-summary").addClass('hide');
      }
      $(".discount_dollar_value").html(response.discount_dollar_value);
      // $(".total_amount_afer_discount").html(response.total);
      $(".total_amount_afer_discount, .order_total_amount").html(response.total);
		});
  }

});

// remove discound code from order
$(document).on('click', "#remove_discount_code", function() {
  var discount_code = $('#discount_code').val();
  var order_id = $(this).data('order_id');

  if(discount_code && order_id) {
    $.post("/orders/"+order_id+"/remove_discount_code", {discount_code: discount_code}, function(response) {
      if(response.is_removed) {
        $("#discount_code").prop('disabled', false);
        $("#discount_code").val("");
        $("#remove_discount_code").addClass('hide');
        $("#submit_discount_code").removeClass('hide');
        $(".discount_code_error").html("");
        $(".discount-summary").addClass('hide');
        $(".discount_dollar_value").html(response.discount_dollar_value);
      } else {
        $("#discount_code").prop('disabled', true);
        $("#discount_code").val(response.discount_code);
        $("#remove_discount_code").removeClass('hide');
        $("#submit_discount_code").addClass('hide');
        $(".discount_code_error").html(response.error_message);
        $(".discount-summary").removeClass('hide');
      }
      $(".total_amount_afer_discount, .order_total_amount").html(response.total);
    });
  }

});

// Check discount code on page load
$(document).ready(function() {
  var discount_code = $('#discount_code').val();

  if(discount_code != "") {
    // order has discount code, validating it again
    $("#submit_discount_code").trigger('click');
  }
})

// Check hide discount code filter fields on load in admin section
$(document).ready(function() {
  var filter_type_0 = $('#discount_code_discount_code_filters_attributes_0_filter_type').val();
  
  if(filter_type_0) {
    setDiscountCodeFilterFormFields(filter_type_0, "0");
  }

  var filter_type_1 = $('#discount_code_discount_code_filters_attributes_1_filter_type').val();
  
  
  if(filter_type_1) {
    setDiscountCodeFilterFormFields(filter_type_1, "1");
  }

  var filter_type_2 = $('#discount_code_discount_code_filters_attributes_2_filter_type').val();
  
  if(filter_type_2) {
    setDiscountCodeFilterFormFields(filter_type_2, "2");
  }
});

function setDiscountCodeFilterFormFields(filter_type, number) {
  if(filter_type === "toppings") {
    $('label[for=discount_code_discount_code_filters_attributes_' + number + '_email], input#discount_code_discount_code_filters_attributes_' + number + '_email').hide();
    $('#discount_code_discount_code_filters_attributes_' + number + '_email').val('');
    
    $('label[for=discount_code_discount_code_filters_attributes_' + number + '_franchise_location_id], select#discount_code_discount_code_filters_attributes_' + number + '_franchise_location_id').hide();
    $('#discount_code_discount_code_filters_attributes_' + number + '_franchise_location_id').val('');
    
    $('label[for=discount_code_discount_code_filters_attributes_' + number + '_toppings], select#discount_code_discount_code_filters_attributes_' + number + '_toppings').show();
  } else if(filter_type === "email") {
    $('label[for=discount_code_discount_code_filters_attributes_' + number + '_toppings], select#discount_code_discount_code_filters_attributes_' + number + '_toppings').hide();
    $('#discount_code_discount_code_filters_attributes_' + number + '_toppings').val('');

    $('label[for=discount_code_discount_code_filters_attributes_' + number + '_franchise_location_id], select#discount_code_discount_code_filters_attributes_' + number + '_franchise_location_id').hide();
    $('#discount_code_discount_code_filters_attributes_' + number + '_franchise_location_id').val('');

    $('label[for=discount_code_discount_code_filters_attributes_' + number + '_email], input#discount_code_discount_code_filters_attributes_' + number + '_email').show();
  } else if(filter_type === "franchise_location") {
    $('label[for=discount_code_discount_code_filters_attributes_' + number + '_toppings], select#discount_code_discount_code_filters_attributes_' + number + '_toppings').hide();
    $('#discount_code_discount_code_filters_attributes_' + number + '_toppings').val('');

    $('label[for=discount_code_discount_code_filters_attributes_' + number + '_email], input#discount_code_discount_code_filters_attributes_' + number + '_email').hide();
    $('#discount_code_discount_code_filters_attributes_' + number + '_email').val('');
    $('label[for=discount_code_discount_code_filters_attributes_' + number + '_franchise_location_id], select#discount_code_discount_code_filters_attributes_' + number + '_franchise_location_id').show();
  }
}

$(document.body).on('change', '#discount_code_discount_code_filters_attributes_0_filter_type',function(){
  var filter_type = $(this).val();
  setDiscountCodeFilterFormFields(filter_type, "0")
});

$(document.body).on('change', '#discount_code_discount_code_filters_attributes_1_filter_type',function(){
  var filter_type = $(this).val();
  setDiscountCodeFilterFormFields(filter_type, "1")
});

$(document.body).on('change', '#discount_code_discount_code_filters_attributes_2_filter_type',function(){
  var filter_type = $(this).val();
  setDiscountCodeFilterFormFields(filter_type, "2")
});