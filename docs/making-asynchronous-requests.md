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

### Handling Graph Api Exceptions

For simplicity most of the examples shown here does not handle exceptions. It is always recommended to handle 
exceptions during production. If you are using `CancelAsync()` method make sure to check for `Cancelled` property
before checking for exception.

    var fb = new FacebookClient("access_token");

    fb.GetCompleted +=
        (o, e) =>
        {
            if (e.Cancelled)
            {
                // request was cancelled
                return;
            }

            var ex = e.Error;
            if (ex != null)
            {
                if (ex is FacebookOAuthException)
                {
                    // oauth exception occurred
                }
                else if (ex is FacebookApiLimitException)
                {
                    // api limit exception occurred.
                }
                else if (ex is FacebookApiException)
                {
                    // other general facebook api exception
                }
                else
                {
                    // non-facebook exception such as no internet connection.
                }

                return;
            }
            
            var result = (IDictionary<string, object>)e.GetResultData();
            var id = (string) result["id"];
            var name = (string)result["name"];
        };

    fb.GetAsync("me");

> ```FacebookOAuthException``` and ```FacebookApiLimitException``` inherit from ```FacebookApiException```.

### Multiple Async Calls

Unlike the synchronous (`Get`, `Post` and `Delete`) and XTaskAsync (`GetTaskAsync`, `PostTaskAsync`, `DeleteTaskAsync`) 
methods; `GetAsync`, `PostAsync` and `DeleteAsync` will call the same handler if you execute the async methods more than 
once for the same instance of `FacebookClient`. In order to prevent event handlers being called multiple times it is 
recommended to use different instance of `FacebookClient` for each request.

    string accessToken = "access_token";
    
    var fbMe = new FacebookClient(accessToken);
    fbMe.GetCompleted += (o, e) => { };
    fbMe.GetAsync("me");
    
    var fbFeed = new FacebookClient(accessToken);
    fbFeed.GetCompleted += (o, e) => { };
    fbFeed.GetAsync("me/feed");

Unlike `GetAsync`, `PostAsync`, `DeleteAsync` and `BatchAsync`, you can use `GetTaskAsync`, `PostTaskAsync`, 
`DeleteTaskAsync` and `BatchTaskAsync` on the same instance of `FacebookClient`.

## Insert or Update Data (HTTP POST)
Sample for posting to the wall.

    var fb = new FacebookClient("access_token");
    
    fb.PostCompleted += (o, e) => {
        if(e.Error == null) {
            var result = (IDictionary<string, object>)e.GetResultData();
            var newPostId = (string)result.id;
        }
    };
    
    var parameters = new Dictionary<string, object>();
    parameters["message"] = "My first wall post using Facebook C# SDK";
    fb.PostAsync("me/feed", parameters);

To post to the wall, you will need the user's permission. You can read more about these permissions 
(commonly known as ```extended permissions``` or ```scope```) in the official Facebook documentation at 
[https://developers.facebook.com/docs/reference/api/permissions/](https://developers.facebook.com/docs/reference/api/permissions/)

For platforms that do not support dynamic cast it to either `IDictionary<string, object>` if json object or
`IList<object>` if array. For primitive types cast it to `bool`, `string`, `dobule` or `long` depending on the type.

> Note for Windows Phone 7 (WP7) Developers: Due to the security model of WP7, anonymous objects which are internal 
cannot be accessed by Facebook.dll, in order to solve this problem you will need to use the alternative methods 
using ```IDictionary<string,object>``` or add ```[assembly: InternalsVisibleTo("Facebook")]``` in your source code.

### Uploading Files

To upload files you will need to pass either `FacebookMediaObject` or `FacebookMediaStream` as a top level parameter.

> Avoid using synchronous methods to upload files. Use the async version instead `PostAsync` or `PostTaskAsync`. 
`FacebookMediaStream` is recommended over `FacebookMediaObject`.

_Using FacebookMediaObject_

    var fb = new FacebookClient("access_token");
    byte[] data = ......;
    
    fb.PostCompleted = (o, e) => {
        if(e.Cancelled || e.Error != null) {
            return;
        }
        
        var result = e.GetResultData();
    };
    
    var parameters = new Dictionary<string, object>();
    parameters["message"] = "my first photo upload using Facebook C# SDK";
    parameters["file"] = new FacebookMediaObject
                            {
                                ContentType = "image/jpeg",
                                FileName = "image.jpeg";
                            }.SetValue(data);
                            
    fb.PostAsync("me/photos", parameters);

_Using FacebookMediaStream_

    var fb = new FacebookClient("access_token");
    Stream attachement = .....;
    
    fb.PostCompleted += (o, e) => {
        attachment.Dispose();
        
        if(e.Cancelled || e.Error != null) {
            return;
        }
        
        var result = e.GetResultData();
    };

    var parameters = new Dictionary<string, object>();
    parameters["message"] = "upload using Facebook C# SDK";
    parameters["file"] = new FacebookMediaStream
                        {
                            ContentType = "image/jpeg",
                            FileName = "image.jpg"
                        }.SetValue(attachment);
                        
    fb.PostAsync("me/photos", parameters);

> Unlike FacebookMediaObject the developer must be responsible for correctly disposing the stream.
FacebookMediaStream implements IDisposable which internally calls Dispose on the stream thus you can use 
FacebookMediaStream on the using block or call facebookMediaStream.Dispose() or call dispose on the stream itself.

## Delete Data (HTTP DELETE)

Sample code for deleting the previous wall post.

    var fb = new FacebookClient("access_token");
    
    fb.DeleteCompleted += (o, e) => {
        if(e.Cancelled || e.Error != null) {
            return;
        }
        
        var result = e.GetResultData();
    };
    
    var postIdToDelete = newPostId;
    fb.DeleteAsync(postIdToDelete);
    