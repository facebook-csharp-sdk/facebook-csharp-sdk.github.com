---
layout: default
title: Facebook C# SDK Frequently Asked Questions
---

## General Questions

### How do I get a Facebook Application Access Token?

    var fb = new FacebookClient();
    dynamic result = fb.Get("oauth/access_token", new { 
    	client_id     = "app_id", 
    	client_secret = "app_secret", 
    	grant_type    = "client_credentials" 
    });
    	
### How do I exchange code for access token?

	var fb = new FacebookClient();
	dynamic result = fb.Get("oauth/access_token", new {
		client_id     = "app_id",
		client_secret = "app_secret",
		redirect_uri  = "http://yoururl.com/callback",
		code          = "code"		
	});
	
### How do I extend the expiry time of the access token?

	var fb = new FacebookClient();
	dynamic result = fb.Get("oauth/acess_token", new {
		client_id         = "app_id",
		client_secret     = "app_secret",
		grant_type        = "fb_exchange_token",
		fb_exchange_token = "EXISTING_ACCESS_TOKEN"
	});
	
For more information see https://developers.facebook.com/roadmap/offline-access-removal/

### I get "window.opener is null or not an object" when running Silverlight application.
The built-in Visual Studio Cassini Web Server is not supported. Use IIS or IIS express.

### Does Facebook C# SDK support Facebook Chat?
Facebook C# SDK doesn't support the Facebook chat (nor do we have any plans to support it in the future). Facebook chat is based on the xmpp protocol thus any [existing XMPP .NET libraries](http://xmpp.org/xmpp-software/libraries/) would work with Facebook Chat.

### How do I check if a property exists?
Internally a json object of key value pair is ```IDictionary<string,object>```. Any methods of it can be called.

	var fb = new FacebookClient();
	var result = (IDictionary<string,object>)fb.Get("4");
	bool containsNameProperty = result.ContainsKey("name");

If you are using dynamic you can call ContainsKey without explicit casting.

	var fb = new FacebookClient();
	dynamic result = fb.Get("4");
	bool containsNameProperty = result.ContainsKey("name");

_Arrays can be casted to ```IList<object>```._

### How do I get the user id from the access token?
Since the access token is encrypted for security reasons you will need to make a request to the server to extract
the user id.

	var fb = new FacebookClient("access_token");
	dynamic result = fb.Get("me?fields=id");
	var id = result.id;

_It is highly recommended to save the user id along with the access token and access token expiration date._
