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

// per PayPal Advanced si veda https://developer.paypal.com/docs/checkout/advanced/integrate/ e https://developer.paypal.com/docs/checkout/advanced/customize/3d-secure/sdk/

// If this returns false or the card fields aren't visible, see Step #1.
if (paypal.HostedFields.isEligible()) {
  let orderId;

  // Renders card fields
  paypal.HostedFields.render({
    // Call your server to set up the transaction
    createOrder: () => {
      return fetch("/api/4170.ecommerce/paypal.advanced.order", {
        method: 'post'
        // use the "body" param to optionally pass additional order information like
        // product ids or amount.
      })
      .then((res) => res.json())
      .then((orderData) => {
        orderId = orderData.id; // needed later to complete capture
        console.log('orderData --> ',orderData);
        return orderData.id
      })
    },
    styles: {
      '.valid': {
        color: 'green'
      },
      '.invalid': {
        color: 'red'
      }
    },
    fields: {
      number: {
        selector: "#card-number",
        placeholder: "4111 1111 1111 1111"
      },
      cvv: {
        selector: "#cvv",
        placeholder: "123"
      },
      expirationDate: {
        selector: "#expiration-date",
        placeholder: "MM/YY"
      }
    }
  }).then((cardFields) => {
   document.querySelector("#card-form").addEventListener("submit", (event) => {
      event.preventDefault();
      cardFields
        .submit({

          // Trigger 3D Secure authentication
          contingencies: ['SCA_ALWAYS'],
/*
          // Cardholder's first and last name
          cardholderName: document.getElementById("card-holder-name").value,
          // Billing Address
          billingAddress: {
            // Street address, line 1
            streetAddress: document.getElementById(
              "card-billing-address-street"
            ).value,
            // Street address, line 2 (Ex: Unit, Apartment, etc.)
            extendedAddress: document.getElementById(
              "card-billing-address-unit"
            ).value,
            // State
            region: document.getElementById("card-billing-address-state").value,
            // City
            locality: document.getElementById("card-billing-address-city")
              .value,
            // Postal Code
            postalCode: document.getElementById("card-billing-address-zip")
              .value,
            // Country Code
            countryCodeAlpha2: document.getElementById(
              "card-billing-address-country"
            ).value,
          },
*/
        })
/*
        .then(() => {
          fetch(`/api/4170.ecommerce/paypal.advanced.capture?id=${data.orderID}`, {
            method: "post",
          })
            .then((res) => res.json())
            .then((orderData) => {
              // Three cases to handle:
              //   (1) Recoverable INSTRUMENT_DECLINED -> call actions.restart()
              //   (2) Other non-recoverable errors -> Show a failure message
              //   (3) Successful transaction -> Show confirmation or thank you
              // This example reads a v2/checkout/orders capture response, propagated from the server
              // You could use a different API or structure for your 'orderData'
              var errorDetail =
                Array.isArray(orderData.details) && orderData.details[0];
              if (errorDetail && errorDetail.issue === "INSTRUMENT_DECLINED") {
                return actions.restart(); // Recoverable state, per:
                // https://developer.paypal.com/docs/checkout/integration-features/funding-failure/
              }
              if (errorDetail) {
                var msg = "Sorry, your transaction could not be processed.";
                if (errorDetail.description)
                  msg += "\n\n" + errorDetail.description;
                if (orderData.debug_id) msg += " (" + orderData.debug_id + ")";
                return alert(msg); // Show a failure message
              }
              // Show a success message or redirect
              alert("Transaction completed!");
            });
        })
*/
        .then(function (payload) {

          /** sample payload
          * {
          * "orderId": "0BS14434UR665304G",
          * "liabilityShift":  Possible,
          * }
          */

          // Needed only when 3D Secure contingency applied
/*
          if (payload.liabilityShift === "POSSIBLE") {
              // 3D Secure passed successfully
          }

          if (payload.liabilityShift) {
              // Handle buyer confirmed 3D Secure successfully
          }
*/
          console.log( 'payload --> ', payload );

          switch (payload.liabilityShift) {

            case "POSSIBLE":
                // Handle no 3D Secure contingency passed scenario
                return fetch("/api/4170.ecommerce/paypal.advanced.capture?id=" + payload.orderId).then(function(res) {
                    return res.json();
                }).then(function(data) {
                    console.log("data->", data);
                    alert("ok"); //id status=completed
                    if( typeof return_url !== 'undefined' && return_url != '' ) {
                      window.location.href = return_url + `?idOrdine=${payload.orderId}`;
                    } else {
                      window.location.href = data.return + `?idOrdine=${payload.orderId}`;
                    }
                    return data.id;
                });

                break;

            case "NO": // esempio !
                hostedFields.clear('number', function(clearErr) {
                    if (clearErr) {
                        console.error(clearErr);
                    }
                });

                hostedFields.clear('cvv', function(clearErr) {
                    if (clearErr) {
                        console.error(clearErr);
                    }
                });

                hostedFields.clear('expirationDate', function(clearErr) {
                    if (clearErr) {
                        console.error(clearErr);
                    }
                });

                break;

            default:

                //undefined,Unknown

                break;

          }

        })
/*
        .then( ( data ) => {

          console.log( 'data --> ', data );

          if( typeof return_url !== 'undefined' && return_url != '' ) {
            actions.redirect( return_url + `?idOrdine=${payload.orderId}` );
          } else {
            actions.redirect( data.return + `?idOrdine=${payload.orderId}` );
          }

        })
*/
        .catch((err) => {
          alert("Payment could not be captured! " + JSON.stringify(err));
        });
    });

  });

} else {
  // Hides card fields if the merchant isn't eligible
  // document.querySelector("#card-form").style = 'display: none';
}
