---
layout: default
title: Handling Expired Access Tokens
---

Dealing with expired access tokens can be a little tricky. There is no way to determine if an access token is expired without making a request to Facebook. For this reason, you must **always assume that an access token could be expired** when making requests to Facebook. This means that ever request you make to Facebook could throw an OAuthException and that your application much be prepared to handle it. In short, you should always wrap your requests in a ```try { ... } catch (FacebookOAuthException) { }``` and be prepared to handle an unauthorized request.

## FacebookOAuthException
When an access token is invalid or expired, Facebook will return an error and the Facebook SDK for .NET will throw a ```FacebookOAuthException```. The most basic example of handling the ```FacebookOAuthException``` is show below.

	try {
		var client = new FacebookClient("my_access_token");
		dynamic result = client.Get("me/friends");
	} catch (FacebookOAuthException) {
		// Our access token is invalid or expired
		// Here we need to do something to handle this.
	}

## Reasons for OAuth Exceptions
There are a variety of reasons why an OAuth error and ```FacebookOAuthException``` could occur. The most obvious is that the use has simply logged out of Facebook. If a user logged out of Facebook and you attempt to make a request using their token you will receive and error. Second, if a user has removed (deauthorized) your application and you attempt to make a request you will will also receive an error. 

Next, if the users permissions are not valid for the request you are making. This could happen either because the user never granted the permission or they removed a particular permission from your app. For example, if you were to request a user's email address, but never asked them for the 'email' permission, you would receive an OAuth error as show below.

	try {
		var client = new FacebookClient("my_access_token");
		dynamic result = client.Get("me/email");
		var email = (string)result.email;
	} catch (FacebookOAuthException) {
		// The access token expired or the user 
		// has not granted your app 'email' permission.
		// Handle this by redirecting the user to the
		// Facebook authenticate and ask for email permission.
	}

The next reason why an access token is invalid is simply because too much time has passed since the user has been active on your application. If an access token is not used for a period of time it will eventually expire and you must request a new token.

Finally, be mindful that there can be errors with Facebook's API. If you make a request and believe that the token is valid you can always retry the request. Be careful when performing retries though as you can easily reach your request limit by being too aggressive with retries. If you reach your API request limit you will receive a ```FacebookApiLimitException``` and you must wait for a period of time before your application can make a new request. You can read more about Facebook API limits [here](/docs/web/handling-api-limit-errors.html).

> Currently, you can request a permission called 'offline_access' which grants you an access token that will never expire. This is being deprecated by Facebook and it is no longer recommended you built applications that rely on this type of token.

## Renewing an Access Token
[TOTO]

## Reauthorizing a Users
[TOTO]

{% include web-see-also.md %}