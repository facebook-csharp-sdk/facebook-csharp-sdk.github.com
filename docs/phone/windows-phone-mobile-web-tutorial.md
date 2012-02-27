---
layout: default
title: Mobile Web Tutorial for Windows Phone
---

Mobile web apps are built using web technologies including HTML5, Javascript and CSS. You can build once and deploy everywhere, including on Windows Phone, iPhone, iPad and Android.

This tutorial guides you through the key steps to build, test, and launch social integration in your mobile web app. It's a comprehensive walk through building basic social features into your web app. The code used in this tutorial is available below in the code section as "Hello World". On your phone or tablet, you can play with the live sample at [TODO: figure out hosting location].

If you'd like jump right into a demo that showcases what's possible, visit [TODO: figure out hosting location] on your phone or tablet.

##Getting Started

###Step 1: Register your web app

To begin integrating with Facebook Platform, go to Apps on the dev site, click 'Create New App', and then enter your app's basic information. If you already have a Facebook app and you're building a mobile version of your app, do not create a new app. Instead, use the same App ID so users don't have to authorize your app again.

Now, you should be looking at your new app's settings page. Fill in 'App Domain', then click on 'Mobile Web' under 'Select how your app integrates with Facebook'. Under that, fill in your 'Mobile Web URL'. The resulting form should look similar to the screenshot below.

[[images/hwtut1.png|height=420px]]

Now submit the updated settings. You app is now set up and you're ready to begin integrating with Facebook!

Note that if you want to hide your web app from friends until you launch (from search, News Feed, Requests and other Social Channel), you'll need to enabled Sandbox Mode. You can find this setting on the Advanced tab.

###Step 2: Implement the Facebook SDK

Mobile web apps use the same API and dialog calls as apps on Facebook.com and websites on the desktop.

First, create a new file called 'index.html' and paste this HTML boilerplate code into the file. Then, upload it to your web server.

```xml
<html>
<head>
  <title>Hello World</title>
</head>
<body>
</body>
</html>
```
First, we need to enable the [Facebook Javascript SDK](http://developers.facebook.com/docs/reference/javascript) in order to start integrating social functionality into your mobile web app. This is the same SDK you use when integrating with your website or an app on Facebook.com.

To add the SDK, paste the following code into the `<body></body>` section of your index.html.

```javascript
<div id="fb-root"></div>
<script>
  (function() {
    var e = document.createElement('script'); e.async = true;
        e.src = document.location.protocol + '//connect.facebook.net/en_US/all.js';
        document.getElementById('fb-root').appendChild(e);
        }());
</script>

```

The above code will load the JavaScript SDK asynchronously so that the user will be able to access your web app as quickly as possible.

Now that you have the SDK added to your website, you can start creating a social experience.

###Step 3: Log the user in

The next step is to get the Facebook user's access token in order to personalize the experience for them. If your app only wishes to use the News Feed or Request dialog and doesn't require the user to login you can skip directly to Social Channels section below (Integrate with Social Channels).

**Login before landing on your web app**

Authenticated referrals is a new authentication mode for Facebook applications that ensures all referral traffic from Facebook to your application is already connected with Facebook. This means that visitors arrive on your app already "logged in" and with whatever data permissions (email, likes and interests, etc.) you requested in the Required Permissions section. You can use this information to provide a personalized experience for Facebook visitors the moment they land on your app, and if you are using open graph, users will already have authorized your app to publish open graph actions on your behalf.

Authenticated referrals works by showing the app permissions dialog on Facebook (immediately after clicking on any links to your app) so you should be sure to configure this dialog to properly show off the best features of your app, and what actions will be added to their profile. Once they are authenticated, they are sent directly to your Mobile Web URL.

For web apps, this new authentication mode should dramatically increase the number of Facebook connected users of your site, and help you design a more personalized experience. Facebook encourages all mobile web apps to enable this mode to encourage sharing and discovery of your app content.

You can specify the permissions you would like to ask for by setting them in the App Settings for your app. To understand what you can ask for, check out the [Permission doc](https://developers.facebook.com/docs/reference/api/permissions/).

Navigate to your app settings and click on the 'Auth Dialog' tab in order to enable this functionality and set the permissions you would like to ask for. See the dialog below.

[[images/hwtut2.png|height=250px]]

**Important note for Windows Phone**
The Enhanced Auth Dialog experience is not fully supported for Windows Phone (as of December 2011). By default, new applications have the Advanced 'Enhanced Auth Dialog' option enabled in the app settings, but this will need to be disabled in order for Windows Phone web app users to be able to properly interact with the initial app permissions dialog.

**Login when landing directly on your web app**

If a user doesn't come to your web app via Facebook, they will not see this auth dialog. For example, if you're running an ad campaign and directly linking to your web app. In this case you should show the user the login button to enable them to login using Facebook.

Paste the code below into the `<body></body>`.

```xml
<div id="login">
  <p><button onClick="loginUser();">Login</button></p>
</div>
<div id="logout">
  <p><button  onClick="FB.logout();">Logout</button></p>
</div>
```
```javascript
<script>
 function loginUser() {
  if (navigator.userAgent.indexOf("IEMobile")!=-1) {
   showMobileFacebookDialog("oauth",
   {
     client_id: FB._apiKey,
     scope: "email"
   });
  }
  else {
   FB.login(function (response) { }, { scope: 'email' });
  }
 }

 function showMobileFacebookDialog(dialog, params) {
  // These params are the same for all dialogs we support.
  params.display = "touch";
  params.access_token = FB.getAccessToken();
  params.appId = FB._apiKey;
  params.redirect_uri = document.location;

  // Seems like the easiest way to iterate properties of an object.
  var list = "";
  for (var prop in params) {
   if (params.hasOwnProperty(prop))
    list += "&" + prop + "=" + encodeURIComponent(params[prop]);
  }

  // Send off and assume it'll make its way home.
  document.location = "https://m.facebook.com/dialog/" + dialog + "?" + list;
 }
</script>
```

First, we're displaying a login and logout button to the user. The first button calls the loginUser() function when clicked, which in turn takes care of sending parameters to and showing the Facebook oauth login dialog. This prompts the user with the login dialog, asking them for basic permissions and email (since we specify scope: 'email'). For more information on this flow, see [login button docs](http://developers.facebook.com/docs/reference/javascript/FB.login/). Note that, typically you should prompt the same permissions that you're asking for in Authenticated Referrals.

Once the user has interacted with the login dialog, you'll receive a response back via the hashtag. This can all be handled by using the Facebook SDK. Add the following code into the body section of your web app, but replace 'YOUR_APP_ID' with your app id.

```javascript
<script>
 window.fbAsyncInit = function() {
  FB.init({ appId: 'YOUR_APP_ID', 
   status: true, 
   cookie: true,
   xfbml: true,
   oauth: true});

  FB.Event.subscribe('auth.statusChange', handleStatusChange);  
 };
</script>
```

In the code above, init() is called in order to initialize the Facebook JS SDK. For more information on init(), check out the [JavaScript SDK docs](http://developers.facebook.com/docs/reference/javascript/). Next, we need to know whenever a Facebook has authenticated with your app, so we subscribe to the auth.statusChange event. Then, we define the handleStatusChange callback function to handle the response. This function will be called whenever the user's authenticates.

Now, paste the following code into your index.html file, right below the fbAsyncInit code.

```javascript
<script>
function handleStatusChange(response) {
  document.body.className = response.authResponse ? 'connected' : 'not_connected';

  if (response.authResponse) {
   console.log(response);
  }
 }
</script>
```

This is the function that will be triggered when the user authenticates. If the function gets a response (the user is logged into Facebook and they've logged into your app), the <body> class name will be changed to connected. If a response isn't returned (because the user hasn't logged into your app or is logged out of Facebook), the `<body>` class name will be not_connected. We're also logging the response to the console for debug purposes.

Try loading your index.html. You'll notice that both the login and logout buttons are displayed. Remember that we're setting the `<body>` class to reflect if the user has authenticated or not. So to fix this problem, add the following code into the bottom of index.html.

```xml
<style>
 body.connected #login {display: none;}
 body.connected #logout {display: block;}
 body.not_connected #login {display: block;}
 body.not_connected #logout {display: none;}
</style>
```
Now, let's add in one additional bit of script to make sure that window.console is defined when running if different environments:

```javascript
<script>
 if (!window.console) console = {};
  console.log = console.log || function () {
  var message = "";
  for (var i = 0; i < arguments.length; i++) {
   message += arguments[i];
  }
  //alert(message);
 };
 console.warn = console.warn || function () { };
 console.error = console.error || function () { };
 console.info = console.info || function () { };
</script>
```

Now, let's test this flow. On your Windows Phone device (or emulator), go to the URL of your mobile web application and click on the Login button. The CSS stylesheet will display the `<div id="login">` when the user is logged in and the `<div id="logout">` when the user is not logged in. For more information on logging a user into your app, go to the [authentication documentation](https://developers.facebook.com/docs/authentication/).

When viewing on a phone, you'll notice that all of the content is zoomed out is hard to tap. To fix that problem, just paste the code below into the `<head></head>` of index.html.

```xml
<head>
 <meta name="viewport" 
  content="initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no"/>
 <title>Hello World</title
</head>
```

This will make sure that the user is zooomed to 100% and is locked, so that the content appears correctly on the device. Try navigating to index.html to see the result.

##Adding social context

###Step 1: Use the Graph API

Now that the user is logged in, we're ready to start making their experience social.

**Get the user's information**

First, let's display the user's profile picture and name.

Go back to the handleStatusChange function that we already defined. In the `if (response.authResponse)` section, let's add in `updateUserInfo (response);`

```javascript
<script>
function handleStatusChange(response) {
  document.body.className = response.authResponse ? 'connected' : 'not_connected';

  if (response.authResponse) {
   console.log(response);
   updateUserInfo(response);
  }
 }
</script>
```

Now, paste this code at the bottom of index.html.

```javascript
<div id="user-info"></div>
<script>
 function updateUserInfo(response) {
  FB.api('/me', function(response) {
   document.getElementById('user-info').innerHTML = '<img src="https://graph.facebook.com/' +    response.id + '/picture">' + response.name;
  });
 }
</script>
```

This new function, `updateUserInfo`, is called whenever a user authenticates, meaning that they're logged into Facebook and your app. Since we have the user's access token, we can now make API calls on their behalf.

In this function, we're changing the inner HTML of the `user-info` div to the user's picture and name.

Here's what you should see when you've logged into your web app now.

[[images/hwtut3.png|height=120px]]

**Get the user's friends' information**

Now, let's grab the user's friends information and display it to them. Paste this code at the bottom of your index.html.

```xml
<a href="#" onclick="getUserFriends();">Get friends</a><br>
<div id="user-friends"></div>

```
```javascript
<script>
function getUserFriends() {
 FB.api('/me/friends&fields=name,picture', function(response) {
  console.log('Got friends: ', response);

  if (!response.error) {
   var markup = '';

   var friends = response.data;

   for (var i=0; i < friends.length && i < 5; i++) {
    var friend = friends[i];

    markup += '<img src="' + friend.picture + '"> ' + friend.name + '<br>';
   }

   document.getElementById('user-friends').innerHTML = markup;
  }
 });
}
</script>
```

First, we're displaying a link, "Get Friends". When clicked, it will call getUserFriends(). Next, we're calling the FB.api function, and the Graph API method '/me/friends/'. This will return an array of all of the user's friends. Since we specified '&fields=name,picture', you'll get their friends' profile pictures and names.

Once we have the response, we loop through it, create the HTML markup, and insert it into the div with the id 'friends'.

Now, refresh your web app, click 'Get friends' and you should see something like this.

[[images/hwtut4.png|height=250px]]

There are many more things that you can do with the Graph API. Read the [Graph API docs](https://developers.facebook.com/docs/reference/api/) for more info and check out the [Graph API Explorer](http://developers.facebook.com/tools/explorer/).

###Step 2: Integrate with Social Channels

Social Channels enable users to post to their friends' News Feed or send a Request to their friends. Read more about both products in the social channels section of the [main mobile doc](http://developers.facebook.com/docs/mobile/).

**Requests**

Requests are a great way to enable users to invite their friends to your mobile web app or to take specific action like accepting a gift. Your mobile web app can send requests by using the [Request dialog](http://developers.facebook.com/docs/reference/dialogs/requests). If the user's device supports it, they will receive a Push Notification via the Facebook native app whenever a friend sends them a request, in addition to the notification they normally get within Facebook.

The following example shows how to display this dialog within your mobile web page:

```xml
<a href="#" onclick="sendRequest();">Send request</a><br>
```
```javascript
<script>
function sendRequest() {
 var params = {
  //put specific IDs here (separated by commas) - can be user name or id values
  //to: "user1,user2",
  method: 'apprequests',
  message: 'invites you to learn how to make your mobile web app social'
 };

 if (navigator.userAgent.indexOf("IEMobile")!=-1) {
   showMobileFacebookDialog("apprequests", params);
 }
 else {
  FB.ui(params, function (response) {
   console.log('sendRequest response: ', response);
  });
 }
}
</script>
```

When defining 'message', it should follow the format of `<verb> <action to take>`. In this example, it will read as "Matt invites you to learn how to make your mobile web app social."

Now, open index.html and tap 'Send request'. This is the flow that you should see.

[screenshot]

**Here are some additional notes you should keep in mind.**

* The 'message' parameter has a limit of 60 characters. If it's over 60 characters, the dialog will display an error.
* If the user isn't logged into Facebook or hasn't authorized your app yet, this Requests dialog will appear as a new window within their browser, rather than inline within the same page.
* By default, dialogs will be pre-cached for performance reasons. If you would like to disable that for debugging reasons, set the "useCachedDialogs" flag to "false" in init().
* The parameters 'filters', 'exclude_ids', 'max_recipients', and 'data' are currently not supported on mobile, but they will be available soon.
* Please ensure that your Facebook App has been migrated to Requests 2.0. You can find this setting in App Settings on the "Advanced" tab. It's called "Upgrade to Requests 2.0".

There are several more use cases for Requests. See them in action with the Hackbook sample app on your Windows Phone device.

**Timeline and Open Graph**

Historically, Facebook has managed this graph and has expanded it over time as new products were launched (photos, places, etc.). In 2010, they extended the social graph, via the Open Graph protocol, to include 3rd party web sites and pages that people liked throughout the web. They are now extending the Open Graph to include arbitrary actions and objects created by 3rd party apps and enabling these apps to integrate deeply into the Facebook experience.


After a user adds your app to their Timeline, app specific actions are shared on Facebook via the Open Graph. As your app becomes an important part of how users express themselves, these actions are more prominently displayed throughout the Facebook Timeline and News Feed. This enables your app to become a key part of the user's and their friend's experience on Facebook.

Timeline is coming to mobile soon. In preparation, you can start integrating now.

To learn more about how you can integrate your app into Open Graph and Timeline, [learn more](http://developers.facebook.com/docs/beta/) or dive right into the [tutorial](http://developers.facebook.com/docs/beta/opengraph/tutorial/).

**News Feed**
The News Feed is shown immediately to users upon logging in to Facebook, making it core to the Facebook experience. Your mobile web app can post to the user's news feed by using the [Feed Dialog](http://developers.facebook.com/docs/reference/dialogs/feed).

FB.ui() is the method that allows you to trigger this and other dialogs. For example:

Let's add the following code to the very bottom of your existing code, within `<body></body>`.

```xml
<a href="#" onclick="publishStory();">Publish feed story</a><br>
```
```javascript
<script>
 function publishStory() {
  var params = {
   method: 'feed',
   name: 'I am building a social mobile web app!',
   caption: 'This web app is going to be awesome.',
   description: 'Check out Facebooks developer site to start building.',
   link: 'http://www.facebookmobileweb.com/hello',
   picture: 'http://www.facebookmobileweb.com/hackbook/img/facebook_icon_large.png'
  };

  if (_isWP7) {
   showMobileFacebookDialog("feed", params);
  }
  else {
   FB.ui(params, function (response) {
    console.log('publishStory response: ', response);
   });
  }
 }
</script>
```

Now, open up index.html and tap 'Publish feed story'. This is the flow that you should see.

[screenshot]

If you navigate to your profile you should see the story appear on your Wall, like the screenshot below. This story will also show up in your friends' News Feeds.

[screenshot]

**Sending the user to the right experience**

If you already have an App integration on Facebook.com, ensure that the base domain used in link parameter has the base domain ‘http://apps.facebook.com/’. For example, http://apps.facebook.com/your-app?page=1.

When users click on links, Facebook will automatically direct them to your desktop or mobile experience. If the user is on mobile, we will redirect to your Mobile Web URL. For example, http://m.mobilewebapp.com/?page=1.

If the user is on desktop, we will redirect them to the apps.facebook.com URL, as in http://apps.facebook.com/your-app?page=1.

For more information on this dialog, see the [Feed Story docs](http://developers.facebook.com/docs/reference/dialogs/feed/).

**Social Plugins**

Currently, only the Like button is supported in mobile web apps, but more social plugins will be coming soon.

To implement the like button, add this code to the bottom of `<body></body>`. This will allow the user to like the current page you're on.

```xml
<fb:like></fb:like>
```

Also, make to include these meta tags in the `<head></head>` section of index.html so that, when the user likes the page, the page's info is displayed properly on Facebook.

```xml
<meta property="og:title" content="Hello world" />
<meta property="og:type" content="website" />
<meta property="og:site_name" content="Hello World" />
<meta property="og:description" content="Hello World!  This is my mobile web sample app." />
<meta property="og:image" content="http://www.facebookmobileweb.com/start/img/facebook_icon_large.png"/>
```

Open up index.html and you should see the Like button appear. Once liked, a new post will appear on the user's profile.

[[images/hwtut20.png]]

For more information on the Like button, including customization options, see the [Like button docs](http://developers.facebook.com/docs/plugins/like/). Also, [Open Graph docs](https://developers.facebook.com/docs/opengraph/) are available.

**Search and Bookmarks**

Your web app will automatically be indexed in search once you have ten active users. You can search for your app on m.facebook.com by tapping on the top left bookmarks button and tapping "Search". Once a user has authenticated with your web app, it will show up as a bookmark for them on m.facebook.com.

##Deploying your social mobile web app

In order to deploy your mobile web app on Facebook, you just need to ensure that sandbox mode is disabled in App Settings and get ten friends to login to your app. You can point them to http://m.facebook.com/apps/[YOUR_APP_ID] or have them navigate directly to your web app's URL.

Then, your web app will start showing up for all Facebook users in all of the Social Channels mentioned above, including search.

Before doing that, we recommend that you follow the steps below.

###Step 1: Display your app properly on devices

It's important that your web app can render correctly on any device.

You can hide the bottom navigational bar in the Facebook native app. To do this, add the following meta tag to the `<head></head>` section of your web app.

```xml
<meta name="apple-mobile-web-app-capable" content="yes" />
```

It's also recommend that you automatically scroll away the address bar in order to get as much real estate for your web app as possible. To do that, change the `<body>` element of you web app to this.

```xml
<body onload="setTimeout(function() { window.scrollTo(0, 1) }, 100);"></body>
```

###Step 2: Test your integration

It's important that you test your web app before deploying it.

**Testing in a mobile browser**

It's highly recommended that you enable the debug console on Safari and Android in order to debug any issues your web app may be having.

For more information for doing that on iOS, see the [Apple debug console docs](http://developer.apple.com/library/safari/#documentation/AppleApplications/Reference/SafariWebContent/DebuggingSafarioniPhoneContent/DebuggingSafarioniPhoneContent.html).

For more information for doing that on Android, see the [official debug console docs](http://developer.android.com/guide/webapps/debugging.html).

**Testing in a desktop browser**

In order to test the mobile experience in your desktop browser, you will have to change the user agent so that m.facebook.com renders the proper mobile version.

In Safari for example, navigate to “Developer” -> “User Agent” and choose “Safari iOS 4.1 – iPhone”.

The following links contain information on how to spoof properly in other browsers.

* [Internet Explorer](http://www.howtogeek.com/howto/18450/change-the-user-agent-string-in-internet-explorer-8/)
* [Firefox](https://addons.mozilla.org/en-US/firefox/addon/user-agent-switcher/)
* [Chrome](http://www.google.com/support/forum/p/Chrome/thread?tid=64e4e45037f55919&hl=en)

Once you set up spoofing in these browsers, use the User Agent “Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1A543a Safari/419.3”. This will trick the Facebook dialogs and your website into thinking your desktop browser is an iPhone, which will render the proper mobile content.

###Step 3: Add icons

Before you deploy your mobile web app, you should set icons so that it appears properly within Facebook. You'll need a 75x75 and 16x16 icon (the latter will be used for your bookmark).

##Finished!

Congrats, you've built and deployed your social mobile web app. One of the key benefits of building a web app is that it works just about anywhere.

Note that this tutorial covers most of the functionality offered to mobile web apps. Some features that are available on desktop aren't support on mobile yet. For an overview of those features, see the [feature support page](Congrats, you've built and deployed your social mobile web app. One of the key benefits of building a web app is that it works just about anywhere.

Note that this tutorial covers most of the functionality offered to mobile web apps. Some features that are available on desktop aren't support on mobile yet. For an overview of those features, see the [feature support page](http://developers.facebook.com/docs/mobile/web/support/).

{% include phone-see-also.md %}
