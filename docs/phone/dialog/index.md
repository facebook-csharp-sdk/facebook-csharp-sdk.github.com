---
layout: default
title: Facebook Login for Windows Phone 8
---

##Introduction

Facebook Login in Windows Phone 8 apps allows you to offer a personalized experience to your users by integrating social experiences in the app and increasing the app distribution by means of social and viral sharing.
 
## User Experience

The following illustration showcases how the users will see the Facebook login flow on the Windows Phone 8 when using the Facebook app based login. 

![Login flow via the Facebook app](images/combined_flow.png)

The user initiates the Facebook login from an app by hitting a *Login with Facebook* button and gets redirected to the Facebook app. During this switch from your app to the Facebook app, the originating app transfers crucial information such as Facebook App ID and any other state it needs to uniquely and security identify itself to the Facebook app. After the Facebook app receives this information, it shows an authorization screen to the user asking whether they want to share this information with the original app. Once the user taps the OK button, the Facebook app redirects back to the original app and passes the Access Token for the user back to the original app.

> **Note**: If the user does not have the Facebook app installed on their Windows Phone 8 device, then instead getting redirected to the Facebook app, they will be prompted to download the app from the store.

## Configuring your app for the Facebook Login

### App Manifest
Configure your app’s manifest file *WMAppManifest.xml* to register a custom uri scheme that is of the form *msft-{ProductID}*, where *{ProductID}* is your app’s product ID (without dashes). It should look like this:

    <Protocol Name="msft-43245dd584d84cde837aa19a4a2e3914" NavUriFragment="encodedLaunchUri=%s" TaskID="_default" />


> **Note**: If you have not yet submitted your app to the Windows Phone Store, be aware that the product ID used during development is a randomly assigned placeholder. After your app has been certified, it will be assigned a different product ID. In this case, submit your app first to get a product ID assigned, but select the Manual publish option to ensure that you don’t release an app that is not set up correctly on the Facebook Developers site. Once you have your final product ID, make sure you update your *WMAppManifest.xml* to use the final product ID rather than the randomly assigned placeholder. Check out the submission process on the [msdn page](http://msdn.microsoft.com/en-us/library/windowsphone/help/jj206729\(v=vs.105\).aspx) for Windows Phone submission.


### Install the Nuget
Install the latest NuGet packages (Facebook.dll and Facebook.Client.dll) from the SDK. Refer to the *Getting Started on the Application* section in the [Windows Phone Scrumptious Tutorial](/docs/phone/tutorial/) page on how to do this.

### Update your app on the Facebook Developers portal
You also need to enter some information about your app in the Facebook Developers portal, for example, identify your application ID in the Windows Phone Store so Facebook can ensure only your app gets access tokens granted by users to your Facebook app. 

* Go to [Facebook Developer Portal](http://developers.facebook.com) and log in.
* Click *Apps* in the top navigation bar.
* Select your Facebook app in the left pane (or create a new one if you are starting from scratch).
* Click *edit settings*.
* Under *select how your application integrates with Facebook*, find the section for *Windows App* and expand it.
* Enter exactly the same product ID you entered in your *WMAppManifest.xml* file, the *{ProductID}* portion (without dashes) of your *msft-{ProductID}* custom URI scheme.

> **Note**: See earlier note on how the product ID is different during development and after submission. This is crucial if you have not yet been assigned a product ID.
Here’s an example of how the Facebook Developers site looks when set up.

![Windows Phone textbox on Facebook Dev Portal](images/Facebook_Windows_portal_section.png)

### Setting up your development environment

If you are developing on a phone, you will need the latest version of the Facebook Beta app installed. 

However, if you are developing on an emulator you will not be able to install the Facebook Beta app as the emulator cannot connect to the Windows Phone Store. To help enable emulator development, you should use the login simulator app present among the samples in the [github repository](https://github.com/facebook-csharp-sdk/facebook-winclient-sdk.git) that you can deploy to your emulator and use for development and testing. This is a very simple app that does not actually connect to Facebook, but simply echoes back any user supplied Access Tokens in exactly the same way as the official Facebook app does. This way, you can test success and failure paths easily.

Before you deploy the simulator, you need to provide an access token to use in success cases. To get an access token, visit the [Graph Explorer Tool](http://developers.facebook.com/tools/explorer/) on the Facebook Developers site and click *Get Access Token*.

![Get an Access Token via the Graph Explorer](images/graph_explorer.png)


### Initiate Login

Using the *Facebook.Client* nuget package, make a call to *Facebook.Client.Session.ActiveSession.LoginWithBehavior*. This method has different overloads, which require the following parameters:

* The set of permissions your app is requesting
* The login behavior that your app wants. Possible options are: LoginBehaviorApplicationOnly, LoginBehaviorMobileInternetExplorerOnly or LoginBehaviorWebViewOnly. For this tutorial, we are using LoginBehaviorApplicationOnly.

This can be used to redirect the user back to the original page within your application that initiated login, or any other app specific logic.
A full example would be:

    Session.ActiveSession.LoginWithBehavior("email,public_profile,user_friends", FacebookLoginBehavior.LoginBehaviorApplicationOnly);


### Login response handler

You can register an event handler to be notified when the login has successfully been finished. Take a look at the [config sample for an example](/docs/phone/config)

## Conclusion
This article introduces you on the Facebook app based Single Sign On login for Windows Phone 8. Also check out the [Facebook login for Windows Store apps](/docs/windows/sso) which offers similar functionality for on the Windows Store side.