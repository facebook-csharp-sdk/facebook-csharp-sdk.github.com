---
layout: default
title: Facebook SDK for .NET Exchange Token
---

## Version 6 and above

	var fb = new FacebookClient();
	dynamic result = fb.Get("oauth/acess_token", new {
		client_id         = "app_id",
		client_secret     = "app_secret",
		grant_type        = "fb_exchange_token",
		fb_exchange_token = "EXISTING_ACCESS_TOKEN"
	});

## Version 5 and below

Exchanging access token in not supported by Facebook SDK for .NET prior to v6. You will need to write your custom code to support it. Here is the sample code to get started with.

    var appId = "app_id";
    var appSecret = "app_secret";
    var existingAccessToken = "EXISTING_ACCESS_TOKEN";

    try
    {
        var wc = new WebClient();
        var result = wc.DownloadString(string.Format(
            "https://graph.facebook.com/oauth/access_token?client_id={0}&client_secret={1}&grant_type=fb_exchange_token&fb_exchange_token={2}",
            appId, appSecret, existingAccessToken));

        var split = result.Split('&');
        var dict = new Dictionary<string, object>();
        foreach (var s in split)
        {
            var kvp = s.Split('=');
            if (kvp.Length == 2)
                dict[kvp[0]] = kvp[0] == "expires" ? (object)Convert.ToInt64(kvp[1]) : kvp[1];
        }

        Console.WriteLine(dict["access_token"]);
        if (dict.ContainsKey("expires"))
            Console.WriteLine(dict["expires"]);
    }
    catch (WebException ex)
    {
        var response = ex.Response;
        if (response == null)
            throw;

        string responseString;
        using (var stream = response.GetResponseStream())
        {
            using (var reader = new StreamReader(stream))
            {
                responseString = reader.ReadToEnd();
            }
        }

        throw new Exception(responseString, ex);
    }
    