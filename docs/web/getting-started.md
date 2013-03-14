---
layout: default
title: Getting Started with the Facebook SDK for .NET and ASP.NET
---

## Creating a Facebook Application
Before you even begin using the Facebook SDK for .NET you must create a Facebook application. To do so navigate to [http://developers.facebook.com/apps](https://developers.facebook.com/apps) and click the 'Create New App' button. Follow the steps to create an app and record your AppId for use later.

## Installation
The easiest way to get started using the Facebook SDK for .NET is to install it using [Nuget](http://nuget.org). If you don't already have it installed, download it from [nuget.org](http://nuget.org). If you do already have NuGet installed make sure you have the most recent version. So of the features used in the Facebook SDK for .NET will not work with old versions of NuGet.

### Adding the Facebook NuGet Package
To add the package to your project simply right click on the references folder and select 'Manage Nuget Packages...'. Search for the packaged title 'Facebook', select it, and then click 'install'.

// TODO: Picture on NuGet package installation.

### Configuring the Facebook SDK for .NET
After you install the package you must configure the application. The only setting we need to change is the 'Site URL' under the 'Website' settings. The Site URL must match the url you are using for local development. Set this URL to http://localhost:#### where #### is the port you are using for local development.

> WARNING: There is a bug in the Facebook Javascript SDK that prevents you from performing logins when running on non-standard ports on localhost in Internet Explorer. You must either use port 80 or test this in a browser other than Internet Explorer.


## Making Your First Request
Retrieving data form the Facebook Graph API is very easy using the Facebook SDK for .NET. The following code shows how to call the Graph API to retrieve [Nathan Totten's](http://facebook.com/totten) public information.

	var client = new FacebookClient();
	dynamic me = client.Get("totten");

The result of this request is a dynamic object containing various properties such as first_name, last_name, user name, etc. You can see the values of this request by browsing to [http://graph.facebook.com/totten](http://graph.facebook.com/totten) in your web browser. The JSON result is shown below.

	{
		id: "14812017",
		name: "Nathan Totten",
		first_name: "Nathan",
		last_name: "Totten",
		link: "https://www.facebook.com/totten",
		username: "totten",
		gender: "male",
		locale: "en_US"
	}

In you aren't familiar with dynamic objects in C# you can see below that they are very easy to use. 

	dynamic me = client.Get("totten");
	string firstName = me.first_name;
	string lastName = me.last_name;

A dynamic object is an object that is evaluated only at runtime. You can think of it as being a ```Dictionary<string, object>``` that is easier to use. In fact, the dynamic object we use actually _is_ an ```IDictionary<string, object>```. So if you don't like dynamic objects or are on a platform such as Windows Phone that doesn't support dynamic you can access the same information with a dictionary.

	var me = client.Get("totten") as IDictionary<string, object>;
	string firstName = (string)me["first_name"];
	string lastName = me["last_name"].ToString();

As you can see, using a dictionary is possible, but it requires casting or conversion.

## Accessing User Information
Now that you have seen how to make a request of public information using the Facebook SDK for .NET you probably want to do something a little more interesting. In order to access any information that is not public such as a user's profile details, friends list, or Time Line posts you need to provide a valid access token when making the request. 

### Obtaining an Access Token
For the purposes of this walk through we are going to start by obtaining an access token from Facebook's Graph API tool. You can find that tool at [https://developers.facebook.com/tools/access_token/](https://developers.facebook.com/tools/access_token/).


### Retrieving Profile Data
Now that you have obtained a valid access token you are ready to make a request for private data. Because this access token did not request any special permissions (discussed later) we will only be able to access limited details from the user.

	var accessToken = "your access token here";
	var client = new FacebookClient(accessToken);
	dynamic me = client.Get("me");
	string aboutMe = me.about;

> Note: "me" is a special user name that indicates you are making the request in the context of the user who's access token was provided with the request.

This is the technique you will use for request all kinds of data such as friends lists, likes, Time Line posts and more. However, the types of data you can request depend on which permissions you have requested from the user. We will talk about that in more detail later.

## Obtaining an Access Token
In order to obtain an access token from your users you must present them with an authentication dialog. The method in which you present this dialog varies depending on which device your application is built for. Ultimately, regardless of the form factor you are presenting the user with a Facebook login web page. 

> You cannot and must not ask your users for their user name and password directly. There is no way to convert a user name and password into an access token. Additionally, Facebook does not permit applications from requesting, storing, or transmitting Facebook credentials.

### Requesting an Access Token from a Website
In order to get an access token from your users on a website you must use the either the [Facebook JavaScript SDK](http://github.com/facebook/facebook-js-sdk) or perform what is called server flow authentication. In this tutorial we will use the Facebook JavaScript SDK to perform authentication. The Facebook JavaScript SDK will handle all the details of displaying the login dialog, requesting permissions, and parsing the authentication cookie for the access token.

### Adding the Facebook JavaScript SDK to Your Site
The first step in using the Facebook JavaScript SDK to your web application is to add the script references. To do this add the following code right after the ```<body>``` tag on your web page.

	<div id="fb-root"></div>
	<script>
	  window.fbAsyncInit = function() {
	    FB.init({
	      appId      : 'YOUR_APP_ID', // App ID
	      status     : true, // check login status
	      cookie     : true, // enable cookies to allow the server to access the session
	      xfbml      : true  // parse XFBML
	    });

	    // Additional initialization code here
	  };

	  // Load the SDK Asynchronously
	  (function(d){
	     var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];
	     if (d.getElementById(id)) {return;}
	     js = d.createElement('script'); js.id = id; js.async = true;
	     js.src = "//connect.facebook.net/en_US/all.js";
	     ref.parentNode.insertBefore(js, ref);
	   }(document));
	</script>

> Be sure to set the ```'YOUR_APP_ID'``` string equal to the AppId of the Facebook application you created at the beginning of this tutorial.

### Authenticating a User
Now that you have the Facebook JavaScript SDK installed on your application you will want to create a Facebook Login button.

	<div class="fb-login-button" data-show-faces="true" data-width="400" data-max-rows="1"></div>

After your user has authenticated and authorized your application you need to obtain the access token. You can do this with the following Javascript. Add this script immediately after the ```// Additional initialization code here``` comment in the Javascript you added ealier.

	FB.Event.subscribe('auth.authResponseChange', function(response) {
		if (response.status === 'connected') {
			// the user is logged in and has authenticated your
			// app, and response.authResponse supplies
			// the user's ID, a valid access token, a signed
			// request, and the time the access token 
			// and signed request each expire
			var uid = response.authResponse.userID;
			var accessToken = response.authResponse.accessToken;

			// TODO: Handle the access token

		} else if (response.status === 'not_authorized') {
			// the user is logged in to Facebook, 
			// but has not authenticated your app
		} else {
			// the user isn't logged in to Facebook.
		}
	});

Now that you have obtained the access token you will need to send it to the server. You can do this in a variety of ways. The easiest to do this is perform an HTTP POST with the access token and then redirect your user to a new page. Once you have obtained the token on the server you can use any standard method for storing it. The easiest way to store the access token is to simply place it in the Session State and let ASP.NET manage the state for you. You can see how to do this with the following code.

First, here is your client side JavaScript. Place this immediately after the comment ```// TODO: Handle the access token``` in the script form the previous step.

	// Do a post to the server to finish the logon
    // This is a form post since we don't want to use AJAX
    var form = document.createElement("form");
    form.setAttribute("method", 'post');
    form.setAttribute("action", '/FacebookLogin.ashx');

    var field = document.createElement("input");
    field.setAttribute("type", "hidden");
    field.setAttribute("name", 'accessToken');
    field.setAttribute("value", accessToken);
    form.appendChild(field);

    document.body.appendChild(form);
    form.submit();

Next, create a page, action, or handler to receive the token and redirect the user. For this example we will create a generic handler.

	public class FacebookLogin : IHttpHandler, System.Web.SessionState.IRequiresSessionState {

		public void ProcessRequest(HttpContext context) {
			var accessToken = context.Request["accessToken"];
			context.Session["AccessToken"] = accessToken;

			context.Response.Redirect("/MyUrlHere");
		}

		public bool IsReusable {
			get { return false; }
		}
	}

### Using the Access Token
Now that you have successfully saved the access token to the session state you can make requests on behalf of that user when they are browsing your site.

	var accessToken = Session["AccessToken"].ToString();
	var client = new FacebookClient(accessToken);
	dynamic result = client.Get("me", new { fields = "name,id" });
	string name = result.name;
	string id = result.id;

Using these examples you should be able to handle most of the basic actions for your users. For additional reading see the topics below.

{% include web-see-also.md %}





