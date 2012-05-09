---
layout: default
title: Making Synchronous Requests with the Facbeook C# SDK
---

> Synchronous requests are not supported in Silverlight, Windows Phone and Windows Metro Style apps. Refer to [Making Asynchronous Requests](Making Asynchronous Requests) or [Making Asynchronous Requests with Task Parallel Library](Making-Asynchronous-Requests-with-Task-Parallel-Library) or [Making Asynchronous Requests with async await](Making Asynchronous Requests with async await).

> For simplicity, handling exceptions are ignored in the following samples (Always handle exceptions in production).

> All samples below are shown using dynamic. For platforms such as .NET 3.5/Windows Phone where dynamic is not supported refer to [Making synchronous requests without dynamic support](Making-Synchronous-Requests-without-Dynamic-Support). All the samples shown below can be done without dynamic.

It is highly recommended to read the official Facebook documentation on Graph Api which can be found at https://developers.facebook.com/docs/reference/api/ before proceeding further. 

## Retrieve Data (HTTP GET)

### Accessing unprotected resources

Here is a hello world Facebook C# SDK example on accessing public Facebook data without the access token.

    var fb = new FacebookClient();
    dynamic result = fb.Get("4");
    dynamic id = result.id;
    dynamic firstName = result.first_name;
    dynamic lastName = result.last_name;
    dynamic link = result.link;
    dynamic locale = result.locale;

Rather then accessing the value using dot operator as shown above you could also access the value using indexers as shown below.

    dynamic id = result["id"];
    dynamic firstName = result["first_name"];

You could also explicitly mention the type of the value or use var keyword. But _result_ should be dynamic.

    var fb = new FacebookClient();
    dynamic result = fb.Get("4");
    long id = result.id;
    string firstName = result.first_name;
    var lastName = result.last_name;

### Accessing protected resources

Facebook requires to access most of the protected resource using access token. You can pass the access token using the constructor.

    var fb = new FacebookClient("access_token");
    dynamic me = fb.Get("me");
    var id = me.id;
    var name = me.name;

Or you can set/get the access token use the AccessToken property.

    var fb = new FacebookClient { AccessToken = "access_token" };
    dynamic result = fb.Get("4");
    var id = me.id;
    var name = me.name;

### Passing parameters

Some of the api's allows you to pass parameters to your request.
Here is an example using anonymous objects.

    var fb = new FacebookClient("access_token");
    dynamic result = fb.Get("me", new { fields = new[] { "id", "name" }});
    var id = result.id;
    var name = result.name;

> Note for Windows Phone 7 (WP7) Developers: Due to the security model of WP7, anonymous objects which are internal cannot be accessed by Facebook.dll, in order to solve this problem you will need to use the below alternate methods using ```IDictionary<string,object>``` or add ```[assembly: InternalsVisibleTo("Facebook")]``` in your source code.

Another alternative would be to pass a type of IDictionary&lt;string,object&gt;

    var fb = new FacebookClient("access_token");
    var parameters = new Dictionary<string,object>();
    parameters["fields"] = "id,name";
    dynamic result = fb.Get("me", parameters);
    var id = result.id;
    var name = result.name;

You could also make use of [ExapndoObject](http://msdn.microsoft.com/en-us/library/system.dynamic.expandoobject.aspx) for dynamic.

    var fb = new FacebookClient("access_token");
    dynamic parameters = new ExpandoObject();
    parameters.fields = "id,name";
    dynamic result = fb.Get("me", parameters);
    var id = result.id;
    var name = result.name;

### Handling Graph Api Exceptions

For simplicity most of the examples shown here does not handle exceptions. It is always recommended to handle exceptions during production.

    try
    {
        var fb = new FacebookClient("access_token");
        dynamic result = fb.Get("me");
    }
    catch(FacebookOAuthException ex)
    {
        // oauth exception occurred
    }
    catch(FacebookApiLimitException ex)
    {
        // api limit exception occurred.
    }
    catch(FacebookApiException ex)
    {
        // other general facebook api exception
    }
    catch(Exception ex)
    {
        // non-facebook exception such as no internet connection.
    }

> ```FacebookOAuthException``` and ```FacebookApiLimitException``` inherit from ```FacebookApiException```.

## Insert or Update Data (HTTP POST)
Sample for posting to the wall.

    var fb = new FacebookClient("access_token");
    dynamic result = fb.Post("me/feed", new { message = "My first wall post using Facebook C# SDK" });
    var newPostId = result.id;

To post to the wall, you will need the user's permission. You can read more about these permissions (commonly known as ```extended permissions``` or ```scope```) in the official Facebook documentation at https://developers.facebook.com/docs/reference/api/permissions/

### Uploading Files

To upload files you will need to pass either FacebookMediaObject or FacebookMediaStream as a top level parameter.

_Using FacebookMediaObject_

    var fb = new FacebookClient("access_token");
    string attachementPath = @"C:\\image.jpg";
    dynamic result = fb.Post("me/photos",
        new
            {
                message = "my first photo upload using Facebook C# SDK",
                file = new FacebookMediaObject
                        {
                            ContentType = "image/jpg",
                            FileName = Path.GetFileName(attachementPath)
                        }.SetValue(File.ReadAllBytes(attachementPath))
            });

_Using FacebookMediaStream_

    var fb = new FacebookClient("access_token");
    string attachementPath = @"C:\\image.jpg";

    using (var file = new FacebookMediaStream
                    {
                        ContentType = "image/jpge",
                        FileName = Path.GetFileName(attachementPath)
                    }.SetValue(File.OpenRead(attachementPath)))
    {
        dynamic result = fb.Post("me/photos", 
            new { message = "upload using Facebook C# SDK", file });
    }

> Unlike FacebookMediaObject the developer must be responsible for correctly disposing the stream. FacebookMediaStream implements IDisposable which internally calls Dispose on the stream thus you can use FacebookMediaStream on the using block.

## Delete Data (HTTP DELETE)

Sample code for deleting the previous wall post.

    var fb = new FacebookClient("access_token");
    var postIdToDelete = newPostId;
    dynamic result = fb.Delete(postIdToDelete);

## Facebook Query Language (FQL)
It is highly recommended to read the official Facebook documentation on Facebook Query Language (FQL) which can be found at https://developers.facebook.com/docs/reference/fql/ before proceeding further.

### Query

    var fb = new FacebookClient("access_token");
    dynamic result = fb.Get("fql", 
        new { q = "SELECT uid FROM user WHERE uid=me()" });

### Multi-query

    var fb = new FacebookClient("access_token");
    dynamic result = fb.Get("fql", new
        {
            q = new[]
                    {
                        "SELECT uid from user where uid=me()",
                        "SELECT name FROM user WHERE uid=me()"
                    }
        });

### Multi-query with dependency

    var fb = new FacebookClient("access_token");
    dynamic result = fb.Get("fql",
        new
            {
                q = new
                {
                    id = "SELECT uid from user where uid=me()",
                    name = "SELECT name FROM user WHERE uid " +
                    "IN (SELECT uid FROM #id)",
                }
            });

## Batch Requests
It is highly recommended to read the official Facebook documentation on Batch Requests which can be found at https://developers.facebook.com/docs/reference/api/batch/ before proceeding further.

    try
    {
        var fb = new FacebookClient("access_token");
        
        dynamic result = fb.Batch(
            new FacebookBatchParameter("me"),
            new FacebookBatchParameter("me/feed", 
                new { limit = 10 }));
        
        if (result[0] is Exception)
        {
            var ex = (Exception)result[0];
            // handle exception
            Console.WriteLine(ex);
        }
        else
        {
            Console.WriteLine(result[0]);
        }
        
        if (result[1] is Exception)
        {
            var ex = (Exception)result[1];
            // handle exception
            Console.WriteLine(ex);
        }
        else
        {
            Console.WriteLine(result[1]);
        }
    }
    catch(FacebookApiException ex)
    {
        // handle exception
    }
    catch(Exception ex)
    {
        // handle exception
    }

> Always warp batch request in a ```try...catch``` block. Result of batch request is always ```IList<object>```. Make sure to always check for exceptions in each result.

### FQL in Batch Requests

FQL in batch requests are similar to normal FQL Query. You can also execute multi query and multi query with dependency.

    var fb = new FacebookClient("access_token");
    dynamic result = fb.Batch(
        new FacebookBatchParameter("fql", 
        new { q = "SELECT uid FROM user WHERE uid=me()" }));

### Advanced Batch Requests

If you want to set the parameters such as ```omit_response_on_success``` or ```name```, you will need to make use of ```Data``` property.

    var fb = new FacebookClient("access_token");
    dynamic result = fb.Batch(
        new FacebookBatchParameter("me/friends", 
            new { limit = 1 }) { 
                Data =  new { 
                    name = "one-friend", 
                    omit_response_on_success = false } 
                },
            new FacebookBatchParameter(null, 
                new { 
                    ids = "{result=one-friend:$.data.0.id}" 
                })
        );

> Examples shown above does not necessarily include best practices for Facebook development using Facebook C# SDK. It is highly recommend to handle exceptions. If possible it is always recommended to use the asynchronous alternatives - [Making Asynchronous Requests](Making-Asynchronous-Requests), [Making Asynchronous Requests with Task Parallel Library](Making-Asynchronous-Requests-with-Task-Parallel-Library), [Making Asynchronous Requests with async await](Making-Asynchronous-Requests-with-async-await)
