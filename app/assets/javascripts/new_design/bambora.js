$(document).ready(function() {
  (function() {
    var customCheckout = window.customcheckout;
  
    var isCardNumberComplete = false;
    var isCVVComplete = false;
    var isExpiryComplete = false;
  
    var customCheckoutController = {
      init: function() {
        console.log('checkout.init()');
        this.createInputs();
        this.addListeners();
      },
      createInputs: function() {
        console.log('checkout.createInputs()');
        var options = {};
  
        // Create and mount the inputs
        options.placeholder = 'Card number';
        customCheckout.create('card-number', options).mount('#card-number');
  
        options.placeholder = 'CVV';
        customCheckout.create('cvv', options).mount('#card-cvv');
  
        options.placeholder = 'MM / YY';
        customCheckout.create('expiry', options).mount('#card-expiry');
      },
      addListeners: function() {
        var self = this;
  
        // listen for submit button
        if (document.getElementById('payment_method') !== null) {
          document
            .getElementById('payment_method')
            .addEventListener('submit', self.onSubmit.bind(self));
        }
  
        customCheckout.on('brand', function(event) {
          console.log('brand: ' + JSON.stringify(event));
          var cardLogo = 'none';
          if (event.brand && event.brand !== 'unknown') {
            var filePath = 'https://cdn.na.bambora.com/downloads/images/cards/' + event.brand + '.svg';
            cardLogo = 'url(' + filePath + ')';
          }
          document.getElementById('card-number').style.backgroundImage = cardLogo;
        });
  
        customCheckout.on('empty', function(event) {
          console.log('empty: ' + JSON.stringify(event));
  
          if (event.empty) {
            if (event.field === 'card-number') {
              isCardNumberComplete = false;
            } else if (event.field === 'cvv') {
              isCVVComplete = false;
            } else if (event.field === 'expiry') {
              isExpiryComplete = false;
            }
            self.setPayButton(false);
          }
        });
  
        customCheckout.on('complete', function(event) {
          console.log('complete: ' + JSON.stringify(event));
  
          if (event.field === 'card-number') {
            isCardNumberComplete = true;
            self.hideErrorForId('card-number');
          } else if (event.field === 'cvv') {
            isCVVComplete = true;
            self.hideErrorForId('card-cvv');
          } else if (event.field === 'expiry') {
            isExpiryComplete = true;
            self.hideErrorForId('card-expiry');
          }
  
          self.setPayButton(
            isCardNumberComplete && isCVVComplete && isExpiryComplete
          );
        });
  
        customCheckout.on('error', function(event) {
          console.log('error: ' + JSON.stringify(event));
  
          if (event.field === 'card-number') {
            isCardNumberComplete = false;
            self.showErrorForId('card-number', event.message);
          } else if (event.field === 'cvv') {
            isCVVComplete = false;
            self.showErrorForId('card-cvv', event.message);
          } else if (event.field === 'expiry') {
            isExpiryComplete = false;
            self.showErrorForId('card-expiry', event.message);
          }
          self.setPayButton(false);
        });
      },
      onSubmit: function(event) {
        var self = this;
  
        console.log('checkout.onSubmit()');
  
        event.preventDefault();

        var name = $('#bambora_name').val();
        var email = $('#bambora_email').val();
        var address_1 = $('#bambora_address_line1').val();
        var city = $('#bambora_city').val();
        var postalCode = $('#bambora_postal_code').val();
        var phone_number = $('#bambora_phone_number').val();
        var province = $('#bambora_province option:selected').val();

        if(name == "") {
          alert("Please enter name.");
          return;
        }
        if(email == "") {
          alert("Please enter email.");
          return;
        }
        if(address_1 == "") {
          alert("Please enter address.");
          return;
        }
        if(city == "") {
          alert("Please enter city.");
          return;
        }
        if(postalCode == "") {
          alert("Please enter postal code.");
          return;
        }
        if(phone_number == "") {
          alert("Please enter phone number.");
          return;
        }
        if(province == "") {
          alert("Please enter province.");
          return;
        }

        self.setPayButton(false);
        self.toggleProcessingScreen();
  
        var callback = function(result) {
          console.log('token result : ' + JSON.stringify(result));
  
          if (result.error) {
            self.processTokenError(result.error);
          } else {
            self.processTokenSuccess(result.token);
          }
        };
  
        console.log('checkout.createToken()');
        customCheckout.createToken(callback);
      },
      hideErrorForId: function(id) {
        console.log('hideErrorForId: ' + id);
  
        var element = document.getElementById(id);
  
        if (element !== null) {
          var errorElement = document.getElementById(id + '-error');
          if (errorElement !== null) {
            errorElement.innerHTML = '';
          }
  
          var bootStrapParent = document.getElementById(id + '-bootstrap');
          if (bootStrapParent !== null) {
            bootStrapParent.className = 'form-group has-feedback has-success';
          }
        } else {
          console.log('showErrorForId: Could not find ' + id);
        }
      },
      showErrorForId: function(id, message) {
        console.log('showErrorForId: ' + id + ' ' + message);
  
        var element = document.getElementById(id);
  
        if (element !== null) {
          var errorElement = document.getElementById(id + '-error');
          if (errorElement !== null) {
            errorElement.innerHTML = message;
          }
  
          var bootStrapParent = document.getElementById(id + '-bootstrap');
          if (bootStrapParent !== null) {
            bootStrapParent.className = 'form-group has-feedback has-error ';
          }
        } else {
          console.log('showErrorForId: Could not find ' + id);
        }
      },
      setPayButton: function(enabled) {
        console.log('checkout.setPayButton() disabled: ' + !enabled);
  
        var payButton = document.getElementById('pay-button');
        if (enabled) {
          payButton.disabled = false;
          payButton.className = 'button default';
        } else {
          payButton.disabled = true;
          payButton.className = 'button default disabled';
        }
      },
      toggleProcessingScreen: function() {
        var processingScreen = document.getElementById('processing-screen');
        if (processingScreen) {
          processingScreen.classList.toggle('visible');
        }
      },
      showErrorFeedback: function(message) {
        var xMark = '\u2718';
        this.feedback = document.getElementById('feedback');
        this.feedback.innerHTML = xMark + ' ' + message;
        this.feedback.classList.add('error');
      },
      showSuccessFeedback: function(message) {
        var checkMark = '\u2714';
        this.feedback = document.getElementById('feedback');
        this.feedback.innerHTML = checkMark + ' ' + message;
        this.feedback.classList.add('success');
      },
      processTokenError: function(error) {
        error = JSON.stringify(error, undefined, 2);
        console.log('processTokenError: ' + error);
  
        this.showErrorFeedback(
          'Error creating token: </br>' + JSON.stringify(error, null, 4)
        );
        this.setPayButton(true);
        this.toggleProcessingScreen();
      },
      processTokenSuccess: function(token) {
        console.log('processTokenSuccess: ' + token);
        
        // Use token to call payments api
        // this.makeTokenPayment(token);
        var name = $('#bambora_name').val();
        var email = $('#bambora_email').val();
        var address_1 = $('#bambora_address_line1').val();
        var address_2 = $('#bambora_address_line2').val();
        var city = $('#bambora_city').val();
        var phone_number = $('#bambora_phone_number').val();
        var postal_code = $('#bambora_postal_code').val();
        var province = $('#bambora_province option:selected').val();
        var country = $('#bambora_country option:selected').val();
        var name = $('#bambora_name').val().trim();
        var customer_name = name.split(" ");

        $('#order_token').val(token);
        $('#order_name').val(name);
        $('#order_first_name').val(customer_name[0]);
        $('#order_last_name').val(customer_name[1]);
        $('#order_email').val(email);
        $('#order_phone_number').val(phone_number);
        $('#order_address_line1').val(address_1);
        $('#order_address_line2').val(address_2);
        $('#order_city').val(city);
        $('#order_postal_code').val(postal_code);
        $('#order_province').val(province);
        $('#order_country').val(country);


        $('#payment_method').submit();
      },
    };
    if($('body.confirm_your_order_page').length > 0){
      customCheckoutController.init();	
    }
    //customCheckoutController.init();
  })();

});