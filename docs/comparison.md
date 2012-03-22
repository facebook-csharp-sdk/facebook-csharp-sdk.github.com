---
layout: default
title: Facebook C# SDK Comparison of PHP SDK and HttpClient
---

There are many different ways you can make requests to the Facebook Graph API. This document compares some of the most common Graph API actions using curl, the Facebook C# SDK, the Facebook PHP SDK, and System.Net.HttpClient.

## Get User Information

<ul class="nav nav-tabs">
 	<li class="active"><a href="#curlA" data-toggle="tab">cURL</a></li>
	<li><a href="#phpA" data-toggle="tab">PHP SDK</a></li>
	<li><a href="#csharp4A" data-toggle="tab">C# SDK</a></li>
	<li><a href="#csharp45A" data-toggle="tab">C# SDK (await)</a></li>
	<li><a href="#httpclient4A" data-toggle="tab">HttpClient</a></li>
	<li><a href="#httpclient45A" data-toggle="tab">HttpClient (await)</a></li>
</ul>
 
<div class="tab-content">

{% codetab none id=curlA active %}
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
{% endcodetab %}

{% codetab php id=phpA %}
$facebook = new Facebook();
$facebook->setAccessToken('your_access_token')

$user_profile = $facebook->api('/me','GET');
echo "First Name: " . $user_profile['first_name'];
echo "Last Name: " . $user_profile['last_name'];
{% endcodetab %}

{% codetab csharp id=csharp4A %}
var client = new FacebookClient("your_access_token");

client.GetTaskAsync("/me").ContinueWith(task =>
{
	dynamic result = task.Result;
	string firstName = result.first_name;
	string lastName = result.last_name;
});
{% endcodetab %}

{% codetab csharp id=csharp45A %}
var client = new FacebookClient("your_access_token");

dynamic result = await client.GetTaskAsync("me");
string firstName = result.first_name;
string lastName = result.last_name;
{% endcodetab %}

{% codetab csharp id=httpclient4A %}
var httpClient = new HttpClient();

httpClient.GetAsync("http://graph.facebook.com/me?access_token=your_access_token").ContinueWith(response =>
{
		response.Result.Content.ReadAsAsync<JsonObject>().ContinueWith(json =>
		{
				dynamic result = json.Result;
				string firstName = result.first_name;
				string lastName = result.last_name;
		});
});
{% endcodetab %}

{% codetab csharp id=httpclient45A %}
var httpClient = new HttpClient();

var response = await httpClient.GetAsync("https://graph.facebook.com/me?access_token=your_access_token");
dynamic result = await response.Content.ReadAsAsync<JsonObject>();
string firstName = result.first_name;
string lastName = result.last_name;
{% endcodetab %}

</div>