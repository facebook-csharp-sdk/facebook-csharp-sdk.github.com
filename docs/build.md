---
layout: default
title: Building the Facebook C# SDK
---

## Getting/Unpacking the Source
Get the latest stable source code from [here.](http://facebooksdk.codeplex.com/releases)

Extract it to a temporary directory where you would like to build. For this sample I assume the location for build.cmd after extraction is *D:\FacebookSDK\build.cmd*

## Prerequisites
Things to install:

*    Ruby (with rake) 
*    Albacore dependencies for Rake 
*    Silverlight 4 Toolkit - April 2010

These perquisite step needs to be executed only once.

### Install Ruby
Grab a copy of ruby installer from [Ruby Installer](http://rubyinstaller.org/) ([direct link](http://rubyforge.org/frs/download.php/76054/rubyinstaller-1.9.3-p194.exe))

Make sure to *enable "Add Ruby executables to your PATH"* when installing Ruby.

### Install Albacore dependencies for Rake
Open Command Prompt and execute the following command.
{% highlight powershell %}
ruby D:\FacebookSDK\Build\install_albacore_dependencies.rb
{% endhighlight %}

### Silverlight 4 Toolkit - April 2010
Grab a copy of the April 2010 Silverlight 4 Toolkit installer from [CodePlex](http://silverlight.codeplex.com/releases/view/43528) and install it.

## Building Facebook C# SDK Libraries
You can then build the libraries by double clicking "build.cmd" in D:\FacebookSDK\ folder. This will build the binaries for .net 3.5, .net 4.0, silverlight 4.0 and windows phone7. (Make sure you have the appropriate SDKs installed). For .net 3.5 and .net 4.0 it builds all the libraries i.e. (Facebook.dll, Facebook.Web.dll, Facebook.Web.Mvc.dll)

You can then find the appropriate libraries that you just build at *"D:\FacebookSDK\Bin\Release"*

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