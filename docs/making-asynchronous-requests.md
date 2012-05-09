---
layout: default
title: Making Asynchronous Requests with the Facebook C# SDK
---

**For synchronous requests refer to [Making Synchronous Requests](Making-Synchronous-Requests).**

> **Use this only if you are using .NET 3.5, Silverlight 4 or Windows Phone 7 where Task Parallel Library (TPL)
in not supported**. It is always recommended to use the TPL alternatives (XTaskAsync) where possible. Refer to
[Making Asynchronous Requests with Task Parallel Library](Making-Asynchronous-Requests-with-Task-Parallel-Library) or
[Making Asynchronous Requests with async await](Making Asynchronous Requests with async await) for more details.

> For simplicity, handling exceptions are ignored in the following samples (Always handle exceptions in production).

## Retrieve Data (HTTP GET)

### Accessing unprotected resources

Here is a hello world async Facebook C# SDK example on accessing public Facebook data without the access token.

    var fb = new FacebookClient();

    fb.GetCompleted +=
        (o, e) =>
        {
            var result = (IDictionary<string, object>)e.GetResultData();
            var id = (string) result["id"];
            var firstName = (string) result["first_name"];
            var lastName = (string) result["last_name"];
            var link = (string) result["link"];
            var locale = (string) result["locale"];
        };

    fb.GetAsync("4");
    
You can take advantage of dynamic if it is supported. (For example: Silverlight 4 supports dynamic but not TPL.)

    var fb = new FacebookClient();

    fb.GetCompleted +=
        (o, e) =>
        {
            dynamic result = e.GetResultData();
            var id = result.id;
            var firstName = result.first_name;
            var lastName = result.last_name;
            var link = result.link
            var locale = result.locale;
        };

    fb.GetAsync("4");

Rather then accessing the value using dot operator as shown above you could also access the value using indexers for dynamic as shown below.

    dynamic result = e.GetResultData();
    dynamic id = result["id"];
    dynamic firstName = result["first_name"];

You could also explicitly mention the type of the value or use var keyword if _result_ is dynamic.

    dynamic result = e.GetResultData();
    long id = result.id;
    string firstName = result.first_name;
    var lastName = result.last_name;

### Accessing protected resources

Facebook requires to access most of the protected resource using access token. You can pass the access token using the constructor.

    var fb = new FacebookClient("access_token");

    fb.GetCompleted +=
        (o, e) =>
        {
            var result = (IDictionary<string, object>)e.GetResultData();
            var id = (string) result["id"];
            var name = (string) result["name"];
        };

    fb.GetAsync("me");
    
Or you can set/get the access token use the AccessToken property.

    var fb = new FacebookClient { AccessToken = "access_token" };

    fb.GetCompleted +=
        (o, e) =>
        {
            var result = (IDictionary<string, object>)e.GetResultData();
            var id = (string) result["id"];
            var name = (string) result["name"];
        };

    fb.GetAsync("me");
    
### Passing parameters

Some of the api's allows you to pass parameters to your request.
Here is an example using anonymous objects.

    var fb = new FacebookClient("access_token");
    
    fb.GetCompleted +=
        (o, e) =>
        {
            var result = (IDictionary<string, object>)e.GetResultData();
            var id = (string) result["id"];
            var name = (string) result["name"];
        };
        
    fb.GetAsync("me", new { fields = new[] { "id", "name" }});

> Note for Windows Phone 7 (WP7) Developers: Due to the security model of WP7, anonymous objects which are internal 
cannot be accessed by Facebook.dll, in order to solve this problem you will need to use the below alternative methods 
using ```IDictionary<string,object>``` or add ```[assembly: InternalsVisibleTo("Facebook")]``` in your source code.

Another alternative would be to pass a type of IDictionary&lt;string,object&gt;

    var fb = new FacebookClient("access_token");
    
    var parameters = new Dictionary<string,object>();
    parameters["fields"] = "id,name";
    
    fb.GetCompleted +=
        (o, e) =>
        {
            var result = (IDictionary<string, object>)e.GetResultData();
            var id = (string) result["id"];
            var name = (string) result["name"];
        };
    
    fb.GetAsync("me", parameters);
    
You could also make use of [ExpandoObject](http://msdn.microsoft.com/en-us/library/system.dynamic.expandoobject.aspx) 
for dynamic.

    var fb = new FacebookClient("access_token");
    
    dynamic parameters = new ExpandoObject();
    parameters.fields = "id,name";
    
    fb.GetCompleted +=
        (o, e) =>
        {
            dynamic result = e.GetResultData();
            var id = result.id;
            var name = result.name;
        };
    
    fb.GetAsync("me", parameters);

