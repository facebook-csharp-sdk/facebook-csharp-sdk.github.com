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
	<div class="curl-1 active">
{% highlight %}
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
{% endhighlight %}
	</div>
	<div class="php-1 active">
{% highlight %}
$facebook = new Facebook();
$facebook->setAccessToken('your_access_token')

$user_profile = $facebook->api('/me','GET');
echo "First Name: " . $user_profile['first_name'];
echo "Last Name: " . $user_profile['last_name'];
{% endhighlight %}
	</div>
	<div class="csharp4-1 active">
{% highlight %}
var client = new FacebookClient("your_access_token");

client.GetTaskAsync("/me").ContinueWith(task =>
{
	dynamic result = task.Result;
	string firstName = result.first_name;
	string lastName = result.last_name;
});
{% endhighlight %}
	</div>
	<div class="csharp45-1 active">
{% highlight %}
var client = new FacebookClient("your_access_token");

dynamic result = await client.GetTaskAsync("me");
string firstName = result.first_name;
string lastName = result.last_name;
{% endhighlight %}
	</div>
	<div class="httpclient45-1 active">
{% highlight %}
var httpClient = new HttpClient();

var url = "http://graph.facebook.com/me?access_token=your_access_token"
httpClient.GetAsync(url).ContinueWith(response =>
{
		response.Result.Content.ReadAsAsync<JsonObject>().ContinueWith(json =>
		{
				dynamic result = json.Result;
				string firstName = result.first_name;
				string lastName = result.last_name;
		});
});
{% endhighlight %}
	</div>
	<div class="httpclient45-1 active">
{% highlight %}
var httpClient = new HttpClient();

var url = "https://graph.facebook.com/me?access_token=your_access_token"
var response = await httpClient.GetAsync(url);
dynamic result = await response.Content.ReadAsAsync<JsonObject>();
string firstName = result.first_name;
string lastName = result.last_name;
{% endhighlight %}
	</div>
</div>












</div>