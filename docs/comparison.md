---
layout: default
title: Facebook C# SDK Comparison of PHP SDK and HttpClient
---

There are many different ways you can make requests to the Facebook Graph API. This document compares some of the most common Graph API actions using curl, the Facebook C# SDK, the Facebook PHP SDK, and System.Net.HttpClient.

## Get User Information

<ul class="nav nav-tabs">
	<li><a href="#curl-1" data-toggle="tab">cURL</a></li>
	<li><a href="#php-1" data-toggle="tab">PHP SDK</a></li>
	<li><a href="#csharp4-1" data-toggle="tab">C# SDK</a></li>
	<li><a href="#csharp45-1" data-toggle="tab">C# SDK (await)</a></li>
	<li><a href="#httpclient4-1" data-toggle="tab">HttpClient</a></li>
	<li><a href="#httpclient45-1" data-toggle="tab">HttpClient (await)</a></li>
</ul>
 
| <div class="tab-content"><div class="tab-pane active" id="curl-1">

	curl \
		-F 'access_token=your_access_token' \
		https://graph.facebook.com/me

	// Response

	{
		"id": "14812017", 
		"name": "Nathan Totten", 
		"first_name": "Nathan", 
		"last_name": "Totten", 
		"link": "https://www.facebook.com/totten", 
		"username": "totten"
	}

| </div><div class="tab-pane" id="php-1">

	$facebook = new Facebook();
	$facebook->setAccessToken('your_access_token')
	$user_profile = $facebook->api('/me','GET');
	echo "Name: " . $user_profile['name'];

| </div><div class="tab-pane" id="csharp4-1">

	var client = new FacebookClient("your_access_token");

	client.GetTaskAsync("/me").ContinueWith(task =>
	{
		dynamic result = task.Result;
		string firstName = result.first_name;
	});

| </div><div class="tab-pane" id="csharp45-1">

	var client = new FacebookClient("your_access_token");
	dynamic result = await client.GetTaskAsync("me");
	string firstName = result.first_name;

| </div><div class="tab-pane" id="httpclient4-1">

	var httpClient = new HttpClient();
	httpClient.GetAsync("http://graph.facebook.com/me?access_token=your_access_token").ContinueWith(response =>
	{
			response.Result.Content.ReadAsAsync<JsonObject>().ContinueWith(json =>
			{
					dynamic me = json.Result;
					string firstName = me.first_name;
			});
	});

| </div><div class="tab-pane" id="httpclient45-1">

	var httpClient = new HttpClient();
	var response = await httpClient.GetAsync("https://graph.facebook.com/me?access_token=your_access_token");
	dynamic json = await response.Content.ReadAsAsync<JsonObject>();
	string firstName = json.first_name;

| </div></div>