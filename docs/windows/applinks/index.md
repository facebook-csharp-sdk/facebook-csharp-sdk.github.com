---
layout: default
title: App Links - Linking mobile applications
---

##Introduction

[App Links](http://applinks.org/) is an Open and accessible way of making available information about a single mobile application across multiple Platforms. An application may exist on a variety of platforms as well as have a website presence on mobile web. Usually, information about the various incarnations of an application is hard to collect and if you want to point to an application, you need to manually find and link against that app for each platform. This is inefficient and error prone as you need to know the exact way the app being linked to needs to be invoked on the individual platform.

App Links specification tackles this problem by pushing the maintenance of the actual link of an app onto the App developer. The App Developer maintains the links for the application on the various platforms in form of meta tags on a web page. As the app goes through iterations or becomes available on newer platforms, the App Developer can simply update the meta tags representing the latest information about their Application on the Application's web page. Anyone wishing to link with the developer's app can then simply retrieve this information from the meta tags. This way, this information never gets stale and other Application developers can instantly get the most up-to-date information about any app from that App's web page.

## Setting up AppLinks for your Mobile Application

To setup the AppLinks for your Windows or Windows Phone application, you should use the following meta tags in your HTML ``` <head> ``` tag:

    <meta property="fb:app_id" content="<Your Facebook AppId>" />
    <meta property="al:windows_phone:url" content="Your SilverLight Windows Phone App Launch Url://path" />
    <meta property="al:windows_phone:app_name" content="Your Windows Phone App Name" />
    <meta property="al:windows:url" content="Your Windows App Launch URL://path" />
    <meta property="al:windows:app_name" content="Your Windows App Name" />
    <meta property="al:windows_universal:url" content="Universal Windows & Phone app launch url://path" />
    <meta property="al:windows_universal:app_name" content="Universal Windows & Phone App Name" />


> **Note**: If you do not wish to host a web site for your application just to create AppLinks, you can simply host your App's AppLinks onto Facebook using Facebook's [AppLink Hosting API](https://developers.facebook.com/docs/applinks/hosting-api).

## Using AppLinks in your Windows and Windows Phone applications using the SDK

Using AppLinks in your Windows and Windows Phone applications using the SDK is done in two phases:

### Retrieving the AppLinks information

You retrieve the AppLinks available through a web page by invoking the ``` GetAppLinkAsync ``` function to retrieve the ``` AppLink ``` object that contains the results of crawling the web page. This async API call uses the Facebook AppLink resolver engine to perform a quick lookup of the supplied URL and returns you an object that contains the list of platforms supported by the mobile application. The actual call looks like:

```c#
    var appLink = await AppLinkNavigation.DefaultResolver.GetAppLinkAsync("access token", "url with applinks");
```

### Navigating to the Appropriate AppLink

After obtaining the ``` AppLink ``` object for an application, you can either manually navigate to a specific AppLink or you can use the ``` NavigateAsync ``` function supplied in the ``` AppLinkNavigation ``` class to use the default navigation logic. By default, this function attempts to navigate to the platform specific AppLink if available. If no platform specific link is available, it will automatically fall back to the supplied URL and navigate the user to the web page. Here is how the actual API call:

```c#
    await AppLinkNavigation.NavigateAsync(appLink);
```

> **Note**: If you do not wish to use the default applink navigation behavior, you can simply use the AppLink object to retrieve the available links and navigate to an appropriate link  manuall. The structure of the AppLink class for reference purposes is shown below.

```C#
    public class AppLink
    {
        // source url
        public string SourceUri { get; set; }
        
        // list of targets
        public List<Target> Targets { get; set; } 

        // fallback web url
        public string FallbackUri { get; set; }
    }
    
    public class Target
    {
        public Platform Platform { get; set; }

        // url that we have to launch for the platform
        public string Uri { get; set; }

        // app name that we have to show for the back button in the target app
        public string Name { get; set; }
        
        // package family name to redirect to the store
        public string PackageID { get; set; }
    }
    
    public enum Platform
    {
        WindowsPhone,
        Windows,
        Universal
    }
```

## Summary
AppLinks provide a simple way for your Windows and Windows Phone applications to link to other applications. Additionally, by setting up a web page for your application, either yourself or via the Facebook AppLink hosting, you can provide your app additional visibility and a greater linking capability.