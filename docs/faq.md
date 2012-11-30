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
	dynamic result = fb.Get("oauth/access_token", new {
		client_id         = "app_id",
		client_secret     = "app_secret",
		grant_type        = "fb_exchange_token",
		fb_exchange_token = "EXISTING_ACCESS_TOKEN"
	});

For more information see https://developers.facebook.com/roadmap/offline-access-removal/

### How do I debug the access token?

	var fb = new FacebookClient();
	dynamic result = fb.Get("debug_token", new {
		access_token = "your App Access Token or a valid User Access Token from a developer of the app",
		input_token  = "the Access Token to debug"
	});
	
For more information see https://developers.facebook.com/docs/howtos/login/debugging-access-tokens/
	
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

_It is highly recommended to save the user id along with the access\token and access token expiration date._
### I get `Attempt to access the method failed: .<>f__AnonymousType0``1.get_q()` when using anonymous objects as parameter in Windows Phone 7.
This is due the the security limitations in Windows Phone 7, to solve this issue make sure to add `[assembly: InternalsVisibleTo("Facebook")]`
in AssemblyInfo.cs file.