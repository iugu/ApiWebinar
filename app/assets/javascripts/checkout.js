
jQuery(function($) {
  Iugu.setAccountID("CC2D7A35C66444F88D4485E215D6DC6C");
  Iugu.setTestMode(true);
  Iugu.setup();

  $('#payment-form').submit(function(evt) {
      var form = $(this);
      var tokenResponseHandler = function(data) {
          
          if (data.errors) {
              // console.log(data.errors);
              alert("Erro salvando cartão: " + JSON.stringify(data.errors));
          } else {
              $("#token").val( data.id );
              form.get(0).submit();
          }
          
          // Seu código para continuar a submissão
          // Ex: form.submit();
      }
      
      Iugu.createPaymentToken(this, tokenResponseHandler);
      return false;
  });
});
