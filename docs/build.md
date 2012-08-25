---
layout: default
title: Building the Facebook C# SDK
---

## Getting the source code.

```
git clone https://github.com/facebook-csharp-sdk/facebook-csharp-sdk.git
```

If git is not installed you can also grab the zipped or tarball of the latest source code from 
[https://github.com/facebook-csharp-sdk/facebook-csharp-sdk/downloads](http://facebooksdk.codeplex.com/releases).
Once downloaded extract it to a directory where you would like to build.

## Prerequisites

We assume you already have Visual Studio (2010+) installed and .NET Framework installed.
Depending on what you want to build you can have only specific version of .NET Framework/Silverlight/WindowsPhone 
installed. If you would like to build the binary for Windows Store Apps you will need to run under Windows 8.

**Optional Prerequisites**:
Installing these other prerequisites will also help you to easily automate builds. They are only required if you are using `build.cmd`, `clean.cmd`
or `jake` from command line. We use this to ship every new Facebook C# SDK release as it helps in building all the
binaries from the command line, running tests, creating nuget pacakges and publishing the nuget packages.

*    [NodeJS](http://nodejs.org/)
*    [jake](https://github.com/mde/jake)

### Install NodeJS
Grab a copy of NodeJs installer from the official [NodeJS](http://nodejs.org/) website and install it.

### Install jake

Open the command prompt and install the `jake` node module globally.

```
nmp install -g jake
```

## Building Facebook C# SDK Libraries
You can now build the libraries, run tests as well as create nuget packages using `build.cmd`.
This will build the binaries for .NET 3.5/4.0/4.5, Silverlight 5.0, Windows Phone 7.1 (Mango)
and Windows Store Apps. (Make sure you have the appropriate SDKs installed. For building 
Windows Store Apps you will need to run under Windows 8).
You can find the list of supported .NET Framework/Platforms in 
[README.MD](https://github.com/facebook-csharp-sdk/facebook-csharp-sdk#supported-platforms).

**Output Folders**
* `Bin\Release`: Facebook.dll binaries grouped based on .NET Framework/Platform
* `Dist\NuGet`: NuGet package
* `Dist\SymbolSource`: SymbolSource NuGet Pacakge

To clean and start a new build again run `clean.cmd` then `build.cmd`.

## Advanced Build Options
Incase you want to build particular version for .net 3.5 or .net 4.0 only, It is possible.

Here are the list of available task . 

{% highlight powershell %}
rake build              # Build All
rake build:docs         # Build documentation files
rake build:net35        # Build .NET 3.5 binaries
rake build:net40        # Build .NET 4 binaries
rake build:net45        # Build .NET 4.5 binaries
rake build:sl4          # Build Silverlight 4 binaries
rake build:sl5          # Build Silverlight 5 binaries
rake build:wp7          # Build Windows Phone 7 binaries
rake clean              # Clean All
rake dist               # Create distribution packages
rake libs               # Build All Libraries and run tests (default)
rake nuget              # Build NuGet packages
rake nuget:publish      # Publish .nupkg to nuget.org live feed
rake nuget:push         # Push .nupkg to nuget.org but don't publish
rake nuget:push_source  # Push .nupkg to symbol source & publish
rake tests              # Run tests
rake zip:source         # Create zip archive of the source files
{% endhighlight %}

Inorder to view the above available task execute the following command.
{% highlight powershell %}
rake -f d:\FacebookSDK\rakefile.rb -T
{% endhighlight %}

If you are currently in d:\FacebookSDK directory. It can be executed as (Note: –T is capital letter)
{% highlight powershell %}
rake -T
{% endhighlight %}

If you want to build net 3.5 libraries you would then execute:
{% highlight powershell %}
rake -f d:\FacebookSDK\rakefile.rb build:net35
{% endhighlight %}
or 
{% highlight powershell %}
rake build:net35
{% endhighlight %}

You can also combine them together. For example if you want silverlight and windows phone 7 builds:
{% highlight powershell %}
rake build:sl4 build:wp7
{% endhighlight %}

## Pusing to symbol source
Make sure you have executed nuget task before pushing to symbol source. (Make sure to replace {nuget_api_key} with your nuget api key.)
{% highlight powershell %}
rake nuget
rake nuget:push_source nuget_api_key={nuget_api_key}
{% endhighlight %}

## Pushing to nuget.org
Make sure you have executed nuget task before pushing to symbol source. (Make sure to replace {nuget_api_key} with your nuget api key.)
{% highlight powershell %}
rake nuget
rake nuget:push nuget_api_key={nuget_api_key}
{% endhighlight %}
This command pushes to nuget.org. The package remains hidden. To make it available to public execute nuget:publish task. (Make sure to replace {nuget_api_key} with your nuget api key.)
{% highlight powershell %}
rake nuget
rake nuget:publish nuget_api_key={nuget_api_key}
{% endhighlight %}