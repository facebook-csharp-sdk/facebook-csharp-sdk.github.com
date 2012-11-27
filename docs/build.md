---
layout: default
title: Building Facebook C# SDK from Source
---

## Getting the source code.

    git clone https://github.com/facebook-csharp-sdk/facebook-csharp-sdk.git

If git is not installed you can also grab the zipped or tarball of the latest source code from 
[https://github.com/facebook-csharp-sdk/facebook-csharp-sdk/downloads](https://github.com/facebook-csharp-sdk/facebook-csharp-sdk/downloads).
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

    npm install -g jake

## Building Facebook C# SDK Libraries
You can now build the libraries, run tests as well as create nuget packages using `build.cmd`.
This will build the binaries for .NET 3.5/4.0/4.5, Silverlight 5.0, Windows Phone 7.1 (Mango)
and Windows Store Apps. (Make sure you have the appropriate SDKs installed. For building 
Windows Store Apps you will need to run under Windows 8).
You can find the list of supported .NET Framework/Platforms in 
[README.MD](https://github.com/facebook-csharp-sdk/facebook-csharp-sdk#supported-platforms).

**Output Folders**

* **Bin\Release**: Facebook.dll binaries grouped based on .NET Framework/Platform
* **Dist\NuGet**: NuGet package
* **Dist\SymbolSource**: SymbolSource NuGet Pacakge

To clean and start a new build again run `clean.cmd` then `build.cmd`.

## Advanced Build Options
Unless you are buliiding under Windows 8 and have installed all the .NET Framework and SDKs your build will fail.
In this case you will want to build only for a particular version of .NET Framework or Platform.

Here are the list of available jake tasks. It may vary depending on version of Facebook C# SDK. 

    jake default                   # Build all binaries, run tests and create nuget and symbolsource packages
    jake build:net45               # Build .NET 4.5 binaries
    jake build:net40               # Build .NET 4.0 binaries
    jake build:net35               # Build .NET 3.5 binaries
    jake build:winstore            # Build Windows Store binaries
    jake build:wp71                # Build Windows Phone 7.1 binaries
    jake build:sl5                 # Build Silverlight 5 binaries
    jake clean                     # Clean all
    jake test                      # Run tests
    jake nuget:push:nuget          # Push nuget package to nuget.org
    jake nuget:push:symbolsource   # Push nuget package to symbolsource
    jake nuget:pack                # Create NuGet and SymbolSource pacakges

In order to view the above available task execute the following command in the root source code.

    jake -T

Additional task such as `jake clean:net45` are also available but are hidden. 
For full list of tasks look at `jakefile.js`.

If you want to build net 3.5 libraries you would then execute:

    jake build:net35

You can also combine them together. For example if you want Silverlight and Windows Phone 7 builds:


    jake build:sl5 build:wp71

If you want to clean all the output files.

    jake clean

## Pusing to symbol source

Make sure you have executed nuget task before pushing to symbol source. 
(Replace `nuget_api_key` with your nuget api key. Single quotes are required.)

    jake nuget:pack
    jake nuget:push:nuget['nuget_api_key']

## Pushing to nuget.org
Make sure you have executed nuget task before pushing to nuget.org 
(Replace `nuget_api_key` with your nuget api key. Single quotes are required.)

    jake nuget:pack
    jake nuget:push:symbolsource['nuget_api_key']

It is recommended to push to symbol source first and verify it has been published successfully before publishing to nuget.
This will guarantee that sources will be available for all published nuget packages. You can find the symbol souce status
at [http://www.symbolsource.org/Public/Status](http://www.symbolsource.org/Public/Status).
