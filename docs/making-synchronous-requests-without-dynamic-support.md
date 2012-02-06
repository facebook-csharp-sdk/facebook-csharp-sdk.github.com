---
layout: default
title: Facebook C# SDK Docs
---

**Note: Synchronous requests are not supported in Silverlight, Windows Phone and Windows Metro Style apps. Refer to [Making Asynchronous Requests](Making Asynchronous Requests) or [Making Asynchronous Requests with Task Parallel Library](Making-Asynchronous-Requests-with-Task-Parallel-Library) or [Making Asynchronous Requests with async await](Making Asynchronous Requests with async await).**

_For simplicity, handling exceptions are ignored in the following samples (Always handle exceptions in production). Refer to [Handling Exceptions for Synchronous Requests](Handling Exceptions for Synchronous Requests) on how to handle exceptions._

_This doc is focused for .NET 3.5 and Windows Phone developers where dynamic is not supported (although it can be used on platforms that support dynamic). If you are using platforms that support dynamic it is recommend to read [Making Synchronous Requests](Making-Synchronous-Requests) first._

# Graph Api

It is highly recommended to read the official Facebook documentation on Graph Api which can be found at https://developers.facebook.com/docs/reference/api/ before proceeding further. 

## GET
**Accessing unprotected resources**

Here is a hello world Facebook C# SDK example on accessing public Facebook data without the access token.

```csharp
var fb = new FacebookClient();
var result = (IDictionary<string,object>)fb.Get("4");
var id = (long)result["id"];
var firstName = (string)result["first_name"];
var lastName = (string)result["last_name"];
```

**Accessing protected resources**

Facebook requires to access most of the protected resource using access token. You can pass the access token using the constructor.

```csharp
var fb = new FacebookClient("access_token");
var result = (IDictionary<string,object>)fb.Get("me");
var id = (long)result["id"];
var firstName = (string)result["first_name"];
var lastName = (string)result["last_name"];
```

Or you can set/get the access token use the AccessToken property.

```csharp
var fb = new FacebookClient { AccessToken = "access_token" };
var result = (IDictionary<string,object>)fb.Get("4");
var id = (long)result["id"];
var firstName = (string)result["first_name"];
var lastName = (string)result["last_name"];
```

***Passing parameters***

Some of the api's allows you to pass parameters to your request.
Here is an example using anonymous objects.

```csharp
var fb = new FacebookClient("access_token");
var result = (IDictionary<string,object>)fb.Get("me", new { fields = new[] { "id", "name" }});
var id = (long)result["id"];
var name = (string)result["name"];
```

Another alternative would be to pass a type of IDictionary&lt;string,object&gt;
```csharp
var fb = new FacebookClient("access_token");
var parameters = new Dictionary<string,object>();
parameters["fields"] = "id,name";
var result = (IDictionary<string,object>)fb.Get("me", parameters);
var id = (long)result["id"];
var name = (string)result["name"];
```

## POST
Sample for posting to the wall.

```csharp
var fb = new FacebookClient("access_token");
var result = (IDictionary<string,object>)fb.Post("me/feed", new { message = "My first wall post using Facebook C# SDK" });
var newPostId = (string)result["id"];
```

## DELETE

Sample code for deleting the previous wall post.

```csharp
var fb = new FacebookClient("access_token");
var postIdToDelete = newPostId;
dynamic result = fb.Delete(postIdToDelete);
```

# Legacy REST Api
It is highly recommended to read the official Facebook documentation on Legacy REST Api which can be found at https://developers.facebook.com/docs/reference/rest/ before proceeding further. 

**Although legacy REST api is supported by Facebook C# SDK, it is highly discouraged to be used as Facebook is in the process of deprecating the legacy REST api.**

## GET
[TODO]

## POST
[TODO]

# Batch Requests
Please refer to [Batch Requests](Batch-Requests) wiki.

**Note**

Examples shown above does not necessarily include best practices for Facebook development using Facebook C# SDK. It is highly recommend to read [Handling Exceptions for Synchronous Requests](Handling Exceptions for Synchronous Requests). If possible it is always recommended to use the asynchronous alternatives - [Handling Exceptions for Synchronous Requests](Making-Asynchronous-Requests), [Making Asynchronous Requests with Task Parallel Library](Making-Asynchronous-Requests-with-Task-Parallel-Library), [Making Asynchronous Requests with async await](Making-Asynchronous-Requests-with-async-await)