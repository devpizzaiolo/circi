// ** topping position /
// For adding new ui for topping position

$(".quantity-selector .topping_position").each(function(index, position_el){
  position = $(position_el);
  // $(position_el).hide();
  topping_position_id = $(position_el).data('topping-position-id');
  options = position.children("option");
  values = [];
  idx = 0;
  options.each(function(_, opt) { 
      values[idx] = [opt.value, opt.text, opt.selected];
      idx++;
  });
  // Appending new ui
  position.parent().append("<div id='product_toppings_topping-" + topping_position_id + "_position_group' class='pizzaToppingPosition' data-topping-select-id='product_toppings_topping-" + topping_position_id +"_position' >");
  values.map(function(value) {
    if(value[0] === "Whole Pizza") {
      if(value[2]) {
        $('#product_toppings_topping-' + topping_position_id + '_position_group').append("<div class='pizzaToppingPositionSelect topping_position_new' data-position='" + value[0] + "'><img src='/assets/new_design/pizzaWholeActive.svg' alt='" + value[0] + "' /></div>");
      } else {
        $('#product_toppings_topping-' + topping_position_id + '_position_group').append("<div class='pizzaToppingPositionSelect topping_position_new' data-position='" + value[0] + "'><img src='/assets/new_design/pizzaWhole.svg' alt='" + value[0] + "' /></div>");
      }
    } else if(value[0] === "Left Side") {
      if(value[2]) {
        $('#product_toppings_topping-' + topping_position_id + '_position_group').prepend("<div class='pizzaToppingPositionSelect topping_position_new' data-position='" + value[0] + "'><img src='/assets/new_design/pizzaLeftSideActive.svg' alt='" + value[0] + "' /></div>");
      } else {
        $('#product_toppings_topping-' + topping_position_id + '_position_group').prepend("<div class='pizzaToppingPositionSelect topping_position_new' data-position='" + value[0] + "'><img src='/assets/new_design/pizzaLeftSide.svg' alt='" + value[0] + "' /></div>");
      }
    } else if(value[0] === "Right Side") {
      if(value[2]) {
        $('#product_toppings_topping-' + topping_position_id + '_position_group').append("<div class='pizzaToppingPositionSelect topping_position_new' data-position='" + value[0] + "'><img src='/assets/new_design/pizzaRightSideActive.svg' alt='" + value[0] + "' /></div>");
      } else {
        $('#product_toppings_topping-' + topping_position_id + '_position_group').append("<div class='pizzaToppingPositionSelect topping_position_new' data-position='" + value[0] + "'><img src='/assets/new_design/pizzaRightSide.svg' alt='" + value[0] + "' /></div>");
      }
    }
  })
  position.parent().append("</div>");
}); 

// Handle on click event of topping position
$(".topping_position_new").click(function(el) {
  new_position = $(el.target).parent().data('position');
  topping_select_id = $(el.target).parent().parent().data('topping-select-id');

  $(el.target).parent().parent().find(".topping_position_new").each(function(index, position_el) {
    el_position = $(position_el).data('position');
    if(new_position === el_position) {
      // set active
      switch(el_position) {
        case 'Left Side':
          $(position_el).children("img").attr('src', "/assets/new_design/pizzaLeftSideActive.svg");
          break;
        case 'Right Side':
          $(position_el).children("img").attr('src', "/assets/new_design/pizzaRightSideActive.svg");
          break;
        case 'Whole Pizza':
          $(position_el).children("img").attr('src', "/assets/new_design/pizzaWholeActive.svg");
          break;
      }
    } else {
      // set inactive
      switch(el_position) {
        case 'Left Side':
          $(position_el).children("img").attr('src', "/assets/new_design/pizzaLeftSide.svg");
          break;
        case 'Right Side':
          $(position_el).children("img").attr('src', "/assets/new_design/pizzaRightSide.svg");
          break;
        case 'Whole Pizza':
          $(position_el).children("img").attr('src', "/assets/new_design/pizzaWhole.svg");
          break;
      }
    }
  });
  // setting val and trigger change
  $('#' + topping_select_id).val(new_position).trigger('change');
})

// ** /

// ** topping preferences /
// For adding new ui for topping preferences
$(".quantity-selector .topping_preference").each(function(index, preference_el) {
  preference = $(preference_el);
  // $(preference_el).hide();
  topping_preference_id = $(preference_el).data('topping-preference-id');
  preference_options = preference.children("option");
  preference_values = [];
  preference_idx = 0;
  preference_options.each(function(_, opt) { 
    preference_values[preference_idx] = [opt.value, opt.text, opt.selected];
    preference_idx++;
  });
  // Appending preference new ui
  preference.parent().append("<div id='product_toppings_topping-" + topping_preference_id + "_preference_group' class='pizzaToppingPreference' data-topping-select-id='product_toppings_topping-" + topping_preference_id + "_preference' >");
  preference_values.map(function(value) {
    active_klass = value[2] == true ? " selected active" : " ";
    $('#product_toppings_topping-' + topping_preference_id + '_preference_group').append("<div class='pizzaToppingPreferenceSelect topping_preference_new" + active_klass +  "'>" + value[1] + "</div>");
  })
  preference.parent().append("</div>");
}); 

// After appending preference & position ui setting initil show/hide state
$("input.hideshow_topping").each(function(index, topping_el) {
  topping_id = $(topping_el).data('topping-id');
  if($(topping_el).is(':checked')) {
    $("#product_toppings_topping-" + topping_id + "_preference_group").show();
    $("#product_toppings_topping-" + topping_id + "_position_group").show();
    $(topping_el).parent().parent().addClass('selectedTopping');
  } else {
    $("#product_toppings_topping-" + topping_id + "_preference_group").hide();
    $("#product_toppings_topping-" + topping_id + "_position_group").hide();
    $(topping_el).parent().parent().removeClass('selectedTopping');
  }
});

// Handle on click event of topping preference
$(".topping_preference_new").click(function(el) {
  $(el.target).parent().find(".topping_preference_new").removeClass("selected active");
  $(el.target).addClass("selected active");
  // getting select element
  topping_select_id = $(el.target).parent().data('topping-select-id');
  // setting val and trigger change
  if($(el.target).text() === "Regular") {
    preference = "Normal";
  } else {
    preference = $(el.target).text();
  }
  $('#' + topping_select_id).val(preference).trigger('change');
})

// ** /


//** deal page customization */
// ** topping position /
// For adding new ui for topping position
// deal first Item
$(".quantity-selector .deal-topping-position-0").each(function(index, position_el){
  position = $(position_el);
  topping_position_id = $(position_el).data('topping-position-id');
  options = position.children("option");
  values = [];
  idx = 0;
  options.each(function(_, opt) { 
      values[idx] = [opt.value, opt.text, opt.selected];
      idx++;
  });
  // Appending new ui
  position.parent().append("<div id='product_toppings_topping-" + topping_position_id + "_position_group_0' class='pizzaToppingPosition' data-topping-select-id='product_toppings_topping-" + topping_position_id +"_position_0' >");
  values.map(function(value) {
    if(value[0] === "Whole Pizza") {
      if(value[2]) {
        $('#product_toppings_topping-' + topping_position_id + '_position_group_0').append("<div class='pizzaToppingPositionSelect deal_topping_position_new' data-position='" + value[0] + "'><img src='/assets/new_design/pizzaWholeActive.svg' alt='" + value[0] + "' /></div>");
      } else {
        $('#product_toppings_topping-' + topping_position_id + '_position_group_0').append("<div class='pizzaToppingPositionSelect deal_topping_position_new' data-position='" + value[0] + "'><img src='/assets/new_design/pizzaWhole.svg' alt='" + value[0] + "' /></div>");
      }
    } else if(value[0] === "Left Side") {
      if(value[2]) {
        $('#product_toppings_topping-' + topping_position_id + '_position_group_0').prepend("<div class='pizzaToppingPositionSelect deal_topping_position_new' data-position='" + value[0] + "'><img src='/assets/new_design/pizzaLeftSideActive.svg' alt='" + value[0] + "' /></div>");
      } else {
        $('#product_toppings_topping-' + topping_position_id + '_position_group_0').prepend("<div class='pizzaToppingPositionSelect deal_topping_position_new' data-position='" + value[0] + "'><img src='/assets/new_design/pizzaLeftSide.svg' alt='" + value[0] + "' /></div>");
      }
    } else if(value[0] === "Right Side") {
      if(value[2]) {
        $('#product_toppings_topping-' + topping_position_id + '_position_group_0').append("<div class='pizzaToppingPositionSelect deal_topping_position_new' data-position='" + value[0] + "'><img src='/assets/new_design/pizzaRightSideActive.svg' alt='" + value[0] + "' /></div>");
      } else {
        $('#product_toppings_topping-' + topping_position_id + '_position_group_0').append("<div class='pizzaToppingPositionSelect deal_topping_position_new' data-position='" + value[0] + "'><img src='/assets/new_design/pizzaRightSide.svg' alt='" + value[0] + "' /></div>");
      }
    }
  })
  position.parent().append("</div>");
}); 

// ** topping preferences /
// For adding new ui for topping preferences
//  deal first item
$(".quantity-selector .deal-topping-preference-0").each(function(index, preference_el) {
  preference = $(preference_el);
  topping_preference_id = $(preference_el).data('topping-preference-id');
  preference_options = preference.children("option");
  preference_values = [];
  preference_idx = 0;
  preference_options.each(function(_, opt) { 
    preference_values[preference_idx] = [opt.value, opt.text, opt.selected];
    preference_idx++;
  });
  // Appending preference new ui
  preference.parent().append("<div id='product_toppings_topping-" + topping_preference_id + "_preference_group_0' class='pizzaToppingPreference' data-topping-select-id='product_toppings_topping-" + topping_preference_id + "_preference_0' >");
  preference_values.map(function(value) {
    active_klass = value[2] == true ? " selected active" : " ";
    $('#product_toppings_topping-' + topping_preference_id + '_preference_group_0').append("<div class='pizzaToppingPreferenceSelect deal_topping_preference_new" + active_klass +  "'>" + value[1] + "</div>");
  })
  preference.parent().append("</div>");
});

// deal second Item
$(".quantity-selector .deal-topping-position-1").each(function(index, position_el){
  position = $(position_el);
  // $(position_el).hide();
  topping_position_id = $(position_el).data('topping-position-id');
  options = position.children("option");
  values = [];
  idx = 0;
  options.each(function(_, opt) { 
      values[idx] = [opt.value, opt.text, opt.selected];
      idx++;
  });
  // Appending new ui
  position.parent().append("<div id='product_toppings_topping-" + topping_position_id + "_position_group_1' class='pizzaToppingPosition' data-topping-select-id='product_toppings_topping-" + topping_position_id + "_position_1' >");
  values.map(function(value) {
    if(value[0] === "Whole Pizza") {
      if(value[2]) {
        $('#product_toppings_topping-' + topping_position_id + '_position_group_1').append("<div class='pizzaToppingPositionSelect deal_topping_position_new' data-position='" + value[0] + "'><img src='/assets/new_design/pizzaWholeActive.svg' alt='" + value[0] + "' /></div>");
      } else {
        $('#product_toppings_topping-' + topping_position_id + '_position_group_1').append("<div class='pizzaToppingPositionSelect deal_topping_position_new' data-position='" + value[0] + "'><img src='/assets/new_design/pizzaWhole.svg' alt='" + value[0] + "' /></div>");
      }
    } else if(value[0] === "Left Side") {
      if(value[2]) {
        $('#product_toppings_topping-' + topping_position_id + '_position_group_1').prepend("<div class='pizzaToppingPositionSelect deal_topping_position_new' data-position='" + value[0] + "'><img src='/assets/new_design/pizzaLeftSideActive.svg' alt='" + value[0] + "' /></div>");
      } else {
        $('#product_toppings_topping-' + topping_position_id + '_position_group_1').prepend("<div class='pizzaToppingPositionSelect deal_topping_position_new' data-position='" + value[0] + "'><img src='/assets/new_design/pizzaLeftSide.svg' alt='" + value[0] + "' /></div>");
      }
    } else if(value[0] === "Right Side") {
      if(value[2]) {
        $('#product_toppings_topping-' + topping_position_id + '_position_group_1').append("<div class='pizzaToppingPositionSelect deal_topping_position_new' data-position='" + value[0] + "'><img src='/assets/new_design/pizzaRightSideActive.svg' alt='" + value[0] + "' /></div>");
      } else {
        $('#product_toppings_topping-' + topping_position_id + '_position_group_1').append("<div class='pizzaToppingPositionSelect deal_topping_position_new' data-position='" + value[0] + "'><img src='/assets/new_design/pizzaRightSide.svg' alt='" + value[0] + "' /></div>");
      }
    }
  })
  position.parent().append("</div>");
});

//  deal second item
$(".quantity-selector .deal-topping-preference-1").each(function(index, preference_el) {
  preference = $(preference_el);
  topping_preference_id = $(preference_el).data('topping-preference-id');
  preference_options = preference.children("option");
  preference_values = [];
  preference_idx = 0;
  preference_options.each(function(_, opt) { 
    preference_values[preference_idx] = [opt.value, opt.text, opt.selected];
    preference_idx++;
  });
  // Appending preference new ui
  preference.parent().append("<div id='product_toppings_topping-" + topping_preference_id + "_preference_group_1' class='pizzaToppingPreference' data-topping-select-id='product_toppings_topping-" + topping_preference_id + "_preference_1' >");
  preference_values.map(function(value) {
    active_klass = value[2] == true ? " selected active" : " ";
    $('#product_toppings_topping-' + topping_preference_id + '_preference_group_1').append("<div class='pizzaToppingPreferenceSelect deal_topping_preference_new" + active_klass +  "'>" + value[1] + "</div>");
  })
  preference.parent().append("</div>");
});

// After appending preference & position ui setting initil show/hide state
$("input.deal_hideshow_topping").each(function(index, topping_el) {
  topping_id = $(topping_el).data('topping-id');
  freeze_topping = $(topping_el).data('freeze-topping');
  index = $(topping_el).data('index');
  if($(topping_el).is(':checked')) {
    if(freeze_topping) {
      $("#product_toppings_topping-" + topping_id + "_preference_group_" + index).hide();
      $("#product_toppings_topping-" + topping_id + "_position_group_" + index).hide();
      $(topping_el).parent().parent().removeClass('selectedTopping');
    } else {
      $("#product_toppings_topping-" + topping_id + "_preference_group_" + index).show();
      $("#product_toppings_topping-" + topping_id + "_position_group_" + index).show();
      $(topping_el).parent().parent().addClass('selectedTopping');
    }
  } else {
    $("#product_toppings_topping-" + topping_id + "_preference_group_" + index).hide();
    $("#product_toppings_topping-" + topping_id + "_position_group_" + index).hide();
    $(topping_el).parent().parent().removeClass('selectedTopping');
  }
});

// Handle on click event of topping position
$(".deal_topping_position_new").click(function(el) {
  new_position = $(el.target).parent().data('position');
  topping_select_id = $(el.target).parent().parent().data('topping-select-id');

  $(el.target).parent().parent().find(".deal_topping_position_new").each(function(index, position_el) {
    el_position = $(position_el).data('position');
    if(new_position === el_position) {
      // set active
      switch(el_position) {
        case 'Left Side':
          $(position_el).children("img").attr('src', "/assets/new_design/pizzaLeftSideActive.svg");
          break;
        case 'Right Side':
          $(position_el).children("img").attr('src', "/assets/new_design/pizzaRightSideActive.svg");
          break;
        case 'Whole Pizza':
          $(position_el).children("img").attr('src', "/assets/new_design/pizzaWholeActive.svg");
          break;
      }
    } else {
      // set inactive
      switch(el_position) {
        case 'Left Side':
          $(position_el).children("img").attr('src', "/assets/new_design/pizzaLeftSide.svg");
          break;
        case 'Right Side':
          $(position_el).children("img").attr('src', "/assets/new_design/pizzaRightSide.svg");
          break;
        case 'Whole Pizza':
          $(position_el).children("img").attr('src', "/assets/new_design/pizzaWhole.svg");
          break;
      }
    }
  });
  // setting val and trigger change
  $('#' + topping_select_id).val(new_position).trigger('change');
})

// Handle on click event of topping preference
$(".deal_topping_preference_new").click(function(el) {
  $(el.target).parent().find(".deal_topping_preference_new").removeClass("selected active");
  $(el.target).addClass("selected active");
  // getting select element
  topping_select_id = $(el.target).parent().data('topping-select-id');
  // setting val and trigger change
  if($(el.target).text() === "Regular") {
    preference = "Normal";
  } else {
    preference = $(el.target).text();
  }
  $('#' + topping_select_id).val(preference).trigger('change');
})


// ** /