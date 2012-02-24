---
layout: default
title: Using the Facebook C# SDK with the Legacy REST API
---

It is highly recommended to read the official Facebook documentation on Legacy REST Api which can be found at https://developers.facebook.com/docs/reference/rest/ before proceeding further. 

> Although legacy REST api is supported by Facebook C# SDK, it is highly discouraged to be used as Facebook is in the process of deprecating the legacy REST api.

## GET
For rest api make sure to set the name of the rest api as **method** in the parameter.

    var fb = new FacebookClient("accessToken");

    dynamic result = fb.Get(new
        {
            method = "users.getInfo",
            fields = new[] { "name" },
            uids = new[] { 4 }
        });
    Console.WriteLine(result);

Similar to graph api, you can continue to pass parameter as either ```IDictionary<string,object>``` or ```ExpandoObject```.

## POST

    var fb = new FacebookClient("access_token");

    dynamic result = fb.Post(new
        {
            method = "stream.publish",
            message = "My first wall post using Facebook " +
                      "C# SDK via legacy rest api."
        });
    Console.WriteLine(result);