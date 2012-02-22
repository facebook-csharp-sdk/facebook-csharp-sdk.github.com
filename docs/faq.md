---
layout: default
title: Facebook C# SDK Frequently Asked Questions
---

# Frequently Asked Questions

## General Questions

### How do I get the Facebook Application Access Token?

	string appAccessToken = string.Concat("appid", "|", "appsecret");

You can also you the constructor of Facebook Client to auto set the Facebook App Token for you.

	var fb = new FacebookClient("appid", "appsecret");
	string appAccessToken = fb.AccessToken;

### I get "window.opener is null or not an object" when running Silverlight application.
The built-in Visual Studio Cassini Web Server is not supported. Use IIS or IIS express.

## Does Facebook C# SDK support Facebook Chat?
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