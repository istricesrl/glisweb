<?php	require '../../../_src/_config.php'; ?>

<!DOCTYPE html>
<html>
<head>
<title>Facebook Login JavaScript Example</title>
<meta charset="UTF-8">
</head>
<body>
<script async defer crossorigin="anonymous" src="https://connect.facebook.net/it_IT/sdk.js#xfbml=1&version=v16.0&appId=<?php echo $cf['facebook']['profile']['apps']['GlisWeb']['id']; ?>&autoLogAppEvents=1" nonce="1XiaTQFh"></script>
<script async deferred>

  function statusChangeCallback(response) {  // Called with the results from FB.getLoginStatus().
    console.log('statusChangeCallback');
    console.log(response);                   // The current login status of the person.
    if (response.status === 'connected') {   // Logged into your webpage and Facebook.
      testAPI();  
    } else {                                 // Not logged into your webpage or we are unable to tell.
      document.getElementById('status').innerHTML = 'Please log ' + 'into this webpage.';
    }
  }


  function checkLoginState() {               // Called when a person is finished with the Login Button.
    FB.getLoginStatus(function(response) {   // See the onlogin handler
      statusChangeCallback(response);
    });
  }


  window.fbAsyncInit = function() {
    FB.init({
      appId      : '<?php echo $cf['facebook']['profile']['apps']['GlisWeb']['id']; ?>',
      cookie     : true,                     // Enable cookies to allow the server to access the session.
      xfbml      : true,                     // Parse social plugins on this webpage.
      version    : 'v16.0'           // Use this Graph API version for this call.
    });


    FB.getLoginStatus(function(response) {   // Called after the JS SDK has been initialized.
      statusChangeCallback(response);        // Returns the login status.
    });
/*
    FB.login(function(response) {
  if (response.status === 'connected') {
    // Logged into your webpage and Facebook.
    console.log('connesso');
  } else {
    // The person is not logged into your webpage or we are unable to tell. 
    console.log('non connesso');
  }
});
*/
};
 

  function testAPI() {                      // Testing Graph API after login.  See statusChangeCallback() for when this call is made.
    console.log('Welcome!  Fetching your information.... ');
    FB.api('/me', function(response) {
      console.log('Successful login for: ' + response.name);
      document.getElementById('status').innerHTML =
        'Thanks for logging in, ' + response.name + '!';
    });
  }

</script>

<!-- vedi: https://developers.facebook.com/docs/facebook-login/web -->

<div id="fb-root"></div>

<div id="status">
</div>

<div class="fb-login-button" data-width="" data-size="" data-button-type="" data-layout="" data-auto-logout-link="false" data-use-continue-as="false"></div>

<!-- Load the JS SDK asynchronously -->
</body>
</html>
