---
layout: default
title: Making AJAX Requests with the Facebook SDK for .NET
---

When making AJAX request you must remember to send the Facebook Access Token to the server. You can do this by either manually including it in the request. The other alternative is to store the access token in a persistent or semi-persistent store on the server. For example, you could use the ASP.NET Session State to store the access token and then retrieve it when you make a request. Below you will find a few examples.

## Including the Access Token with the Request

Here is how you would include the access token with an AJAX request made using jQuery.

	function getData() {
		FB.getLoginStatus(function (response) {
			var accessToken = response.authResponse.accessToken;
			$.post('@Url.Action("UserInfo", "Home")',
			{ 'accessToken': accessToken },
			function (data, statusText) {
				var name = data.name;
				var id = data.id;
			});
		});
	}

Below you will see how to handle the request on the server. This example uses ASP.NET MVC.

	public ActionResult UserInfo(string accessToken)
	{
		var client = new FacebookClient(accessToken);
		dynamic result = client.Get("me", new { fields = "name,id" });

		return Json(new
		{
			id = result.id,
			name = result.name,
		});
	}

## Using Session State

If you had already stored the access token in the session state, you don't need to send it with each request. Below you will see how to make a request without sending the access token.

Here is the jQuery AJAX request that is made from the client.

	function getData() {
		$.post('@Url.Action("UserInfo", "Home")',
		function (data, statusText) {
			var name = data.name;
			var id = data.id;
		});
	}

And here is how you would handle that request on the server using ASP.NET MVC.

	public ActionResult UserInfo()
	{
		var accessToken = Session["AccessToken"].ToString();
		var client = new FacebookClient(accessToken);
		dynamic result = client.Get("me", new { fields = "name,id" });
		return Json(new
		{
			id = result.id,
			name = result.name,
		});
	}

{% include web-see-also.md %}