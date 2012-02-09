# Getting Started

## Installation
The easiest way to get started using the Facebook C# SDK is to install it using [Nuget](http://nuget.org). If you don't already have it installed, download it from [nuget.org](http://nuget.org). If you do already have NuGet installed make sure you have the most recent version. So of the features used in the Facebook C# SDK will not work with old versions of NuGet.

### Adding the Facebook NuGet Package
To add the package to your project simply right click on the references folder and select...

// TODO: Picture on NuGet package installation.

### Configuring the Facebook C# SDK
After you install the package you must configure the application...


## Making Your First Request
Retrieving data form the Facebook Graph API is very easy using the Facebook C# SDK. The following code shows how to call the Graph API to retrieve [Nathan Totten's](http://facebook.com/totten) public information.

{% highlight c# %}
var client = new FacebookClient();
dynamic me = client.Get("totten");
{% endhighlight %}

The result of this request is a dynamic object containing various properties such as first_name, last_name, username, etc. You can see the values of this request by browsing to [http://graph.facebook.com/totten](http://graph.facebook.com/totten) in your web browser. The JSON result is shown below.

{% highlight json %}
{
	id: "14812017",
	name: "Nathan Totten",
	first_name: "Nathan",
	last_name: "Totten",
	link: "https://www.facebook.com/totten",
	username: "totten",
	gender: "male",
	locale: "en_US"
}
{% endhighlight %}

In you aren't familiar with dynamic objects in C# you can see below that they are very easy to use. 

{% highlight c# %}
dynamic me = client.Get("totten");
string firstName = me.first_name;
string lastName = me.last_name;
{% endhighlight %}

A dynamic object is an object that is evaluated only at runtime. You can think of it as being a ```Dictionary<string, object>``` that is easier to use. In fact, the dynamic object we use actually _is_ an ```IDictionary<string, object>```. So if you dont like dynamic objects or are on a platform such as Windows Phone that doesn't support dynamic you can access the same information with a dictionary.

{% highlight c# }
var me = client.Get("totten") as IDictionary<string, object>;
string firstName = (string)me["first_name"];
string lastName = (string)me["last_name"];
{% endhighlight %}

As you can see, using a dictionary is possible, but it requires a lot of casting.