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
    
