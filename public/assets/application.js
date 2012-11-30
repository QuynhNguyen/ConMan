
n=document.getElementById('fb-root');
if(!n){
  console.log('creating the divs');
  n=document.createElement('div');
  n.id='fb-root';
}


  window.fbAsyncInit = function() {
    FB.init({
      appId      : '430537743669484', // App ID
      channelUrl : 'http://localhost:3000/settings/',
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

      } else {
        // not_logged_in
        console.log('not logged in');
      }
     });
  };
//aa
function getPosition(e){
  var evt =e || window.event;
  var position = [];
  if (e.pageX && e.pageY){
    position.x =e.pageX;
    position.y =e.pageY;
  }
  else{
    position.x = e.clientX + document.body.scrollLeft+ document.documentElement.scrollLeft;
    position.y =  e.clientY + document.body.scrollTop+ document.documentElement.scrollTop;
  }
  return position;
}

  function fbMenu(e){
    var evt =e || window.event;
    fb = document.getElementById("fb");
    pos = getPosition(evt);
    fb.style.left = pos.x;
    fb.style.top = posy.y;
    link = document.getElementById("fb_message");
    //link.href = ;
    return false;
  }

  function testAPI() {
    console.log('Welcome!  Fetching your information.... ');
    FB.api('/me', function(response) {

        console.log('Goooooood to see you, ' + response.name + '.');
    });
};

  function fbLogin() {
      FB.login(function(response) {
          if (response.authResponse) {
              // connected
              testAPI();
              window.location = "http://localhost:3000/fb/index"
          } else {
              // cancelled
              window.location = "http://localhost:3000/settings"
          }
      }, {scope: "user_status,user_online_presence,friends_online_presence,read_insights,read_friendlists,manage_friendlists,read_mailbox,read_requests,read_stream,ads_management,manage_friendlists,manage_notifications,friends_online_presence,publish_checkins,publish_stream"});
  };


  // Load the SDK Asynchronously
  (function(d){
     var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];
     if (d.getElementById(id)) {return;}
     js = d.createElement('script'); js.id = id; js.async = true;
     js.src = "https://connect.facebook.net/en_US/all.js";
     ref.parentNode.insertBefore(js, ref);
   }(document));