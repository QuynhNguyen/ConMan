  window.fbAsyncInit = function() {
    FB.init({
      appId      : '430537743669484', // App ID
      channelUrl : 'blooming-fjord-1291.herokuapp.com',
      status     : true, // check login status
      cookie     : true, // enable cookies to allow the server to access the session
      xfbml      : true,  // parse XFBML
      oauth      : true
    });

    // Additional init code here
    FB.getLoginStatus(function(response) {
      if (response.status === 'connected') {
        // connected
      } else if (response.status === 'not_authorized') {
        // not_authorized
        fbLogin();
        console.log('must log in');
      } else {
        // not_logged_in
        console.log('not logged in');
      }
     });
  };

  function testAPI() {
    console.log('Welcome!  Fetching your information.... ');
    FB.api('/me', function(response) {
        console.log('Good to see you, ' + response.name + '.');
    });
};

  function fbLogin() {
      FB.login(function(response) {
          if (response.authResponse) {
              // connected
              testAPI();
          } else {
              // cancelled
          }
      });
  };



  // Load the SDK Asynchronously
  (function(d){
     var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];
     if (d.getElementById(id)) {return;}
     js = d.createElement('script'); js.id = id; js.async = true;
     js.src = "https://connect.facebook.net/en_US/all.js ";
     ref.parentNode.insertBefore(js, ref);
   }(document));