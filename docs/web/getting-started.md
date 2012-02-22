---
layout: default
title: Getting Started with the Facebook C# SDK for ASP.NET
---

# Getting Started with the Facebook C# SDK for ASP.NET

## Contents

* [Creating a Facebook Application](#1)
* [Installation](#2)
* [Making Your First Request](#3)
* [Accessing User Information](#4)
* [Obtaining an Access Token](#5 )

## Creating a Facebook Application<a id="1">&nbsp;</a>
Before you even begin using the Facebook C# SDK you must create a Facebook application. To do so navigate to [http://developers.facebook.com](http://developers.facebook.com) and....

## Installation<a id="2">&nbsp;</a>
The easiest way to get started using the Facebook C# SDK is to install it using [Nuget](http://nuget.org). If you don't already have it installed, download it from [nuget.org](http://nuget.org). If you do already have NuGet installed make sure you have the most recent version. So of the features used in the Facebook C# SDK will not work with old versions of NuGet.

### Adding the Facebook NuGet Package
To add the package to your project simply right click on the references folder and select...

// TODO: Picture on NuGet package installation.

### Configuring the Facebook C# SDK
After you install the package you must configure the application...


## Making Your First Request<a id="3">&nbsp;</a>
Retrieving data form the Facebook Graph API is very easy using the Facebook C# SDK. The following code shows how to call the Graph API to retrieve [Nathan Totten's](http://facebook.com/totten) public information.

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

## Accessing User Information<a id="4">&nbsp;</a>
Now that you have seen how to make a request of public information using the Facebook C# SDK you probably want to do something a little more interesting. In order to access any information that is not public such as a user's profile details, friends list, or Time Line posts you need to provide a valid access token when making the request. 

### Obtaining an Access Token
For the purposes of this walk through we are going to start by obtaining an access token from Facebook's Graph API tool. You can find that tool at: ....


### Retrieving Profile Data
Now that you have obtained a valid access token you are ready to make a request for private data. Because this access token did not request any special permissions (discussed later) we will only be able to access limited details from the user.

	var accessToken = "your access token here";
	var client = new FacebookClient(accessToken);
	dynamic me = client.Get("me");
	string aboutMe = me.about;

> Note: "me" is a special user name that indicates you are making the request in the context of the user who's access token was provided with the request.

This is the technique you will use for request all kinds of data such as friends lists, likes, Time Line posts and more. However, the types of data you can request depend on which permissions you have requested from the user. We will talk about that in more detail later.

## Obtaining an Access Token<a id="5">&nbsp;</a>
In order to obtain an access token from your users you must present them with an authentication dialog. The method in which you present this dialog varies depending on which device your application is built for. Ultimately, regardless of the form factor you are presenting the user with a Facebook login web page. 

> You cannot and must not ask your users for their user name and password directly. There is no way to convert a user name and password into an access token. Additionally, Facebook does not permit applications from requesting, storing, or transmitting Facebook credentials.

> Some observant users will note that there are applications that ask you for your Facebook user name and password directly. For example, you can log in to [Spotify](http://spotify.com) using your Facebook credentials. Spotify does not use the standard Facebook authentication mechanisms. The authentication mechanism used by Spotify and other limited partners is granted only by Facebook to specific applications. I have no idea how this works or how you get permission to use this API. My advice is that unless you are a well established brand or know Mark Zuckerburg you probably aren't going to get access to this special authentication API. As such you must use the standard OAuth 2.0 authentication system.

### Requesting an Access Token from a Website
In order to get an access token from your users on a website you must use the either the [Facebook JavaScript SDK](http://github.com/facebook/facebook-js-sdk) or perform what is called server flow authentication. In this tutorial we will use the Facebook JavaScript SDK to perform authentication. The Facebook JavaScript SDK will handle all the details of displaying the login dialog, requesting permissions, and parsing the authentication cookie for the access token.

### Adding the Facebook JavaScript SDK to Your Site
The first step in using the Facebook JavaScript SDK to your web application is to add the script references. To do this add the following code immediately before the ```</body>``` tag on your web page.

	TODO: FB JavaScript SDK here

> Be sure to set the ```'your_app_id'``` string equal to the AppId of the Facebook application you created at the beginning of this tutorial.

### Authenticating a User
Now that you have the Facebook JavaScript SDK installed on your application you will want to create a Facebook Login button.

	TODO: FB Login Button

After your user has authenticated and authorized your application you need to obtain the access token. You can do this by adding the following JavaScript to your site.

	TODO: FB Post Auth javascript

Now that you have obtained the access token you will need to send it to the server. You can do this in a variety of ways. The easiest to do this is perform an HTTP POST with the access token and then redirect your user to a new page. Once you have obtained the token on the server you can use any standard method for storing it. The easiest way to store the access token is to simply place it in the Session State and let ASP.NET manage the state for you. You can see how to do this with the following code.

First, here is your client side JavaScript.

	TODO: Access token post

Next, create a page, action, or handler to recieve the token and redirect the user. For this example we will create a generic handler.

	TODO: Access token generic handler

### Using the Access Token
Now that you have successfully saved the access token to the session state you can make requests on behalf of that user when they are browsing your site.

	TODO: ASP.NET Action using session state access token

Using these examples you should be able to handle most of the basic actions for your users. For additional reading see the topics below.

{% include web-see-also.md %}





