// https://developer.paypal.com/docs/checkout/advanced/integrate/
// https://github.com/paypal-examples/docs-examples/tree/main/advanced-integration

paypal
  .Buttons({
    // Sets up the transaction when a payment button is clicked
    createOrder: function (data, actions) {
//      return fetch("/api/orders", {
        return fetch("/api/4170.ecommerce/paypal.advanced.order", {
        method: "post",
        // use the "body" param to optionally pass additional order information
        // like product ids or amount
      })
        .then((response) => response.json())
        .then((order) => order.id);
    },
    // Finalize the transaction after payer approval
    onApprove: function (data, actions) {
//      return fetch(`/api/orders/${data.orderID}/capture`, {
      return fetch(`/api/4170.ecommerce/paypal.advanced.capture?id=${data.orderID}`, {
            method: "post",
      })
        .then((response) => response.json())
        .then((orderData) => {
          // Successful capture! For dev/demo purposes:
          console.log(
            "Capture result",
            orderData,
            JSON.stringify(orderData, null, 2)
          );
          const transaction = orderData.purchase_units[0].payments.captures[0];
//          alert(`Transaction ${transaction.status}: ${transaction.id}
//            See console for all available details
//          `);
          // When ready to go live, remove the alert and show a success message within this page. For example:
          // var element = document.getElementById('paypal-button-container');
          // element.innerHTML = '<h3>Thank you for your payment!</h3>';
          // Or go to another URL:  actions.redirect('thank_you.html');

          // TODO leggere l'URL di redirect dai dati e fare il redirect
          if( typeof return_url !== 'undefined' && return_url != '' ) {
            actions.redirect( return_url + `?idOrdine=${data.orderID}` );
          } else {
            actions.redirect( orderData.return + `?idOrdine=${data.orderID}` );
          }

        });
    },
  })
  .render("#paypal-button-container");
