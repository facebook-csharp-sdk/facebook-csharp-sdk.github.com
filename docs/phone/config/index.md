---
layout: default
title: Configuring Windows Phone Silverlight apps
---

## Applicability
* Windows Phone 8.0 (Silverlight apps)
* Windows Phone 8.1 (Silverlight apps only). 

> Note: For .NET CORE/Universal/non-silverlight  apps, use [Config for .NET CORE based apps Win8.0/Win8.1/WinPhone 8.1 document](/docs/windows/config))

## Introduction
Before you can use the Facebook.Client SDK, you need to supply some configuration in your application. In particular, you need to configure your app to provide its Facebook Application ID. Additionally, if you are using the SDK in Windows Phone, you must configure a protocol handler for your application.

##Configuring Facebook AppID. 
We have changed the way you supply the Facebook AppID since version 0.99 of the SDK. Now the SDK expects you to put your Facebook application ID in a an XML file with the name **FacebookConfig.xml** in the root folder of your application. Put the following contents in your application. You will not be needing to add the Facebook AppID any place else.

### FacebookConfig.xml

    <?xml version="1.0" encoding="utf-8" ?>
    <Extensions>
        <Facebook AppId="Insert your Facebook App ID here" />

        <!-- 
        The following is needed only for Windows Phone Silverlight apps. Since the page to redirect after facebook authentication
        can be different than MainPage.xaml, set this field here to get redirected to the appropriate page.
        -->
        <RedirectPage Name="PageToRedirectTo.xaml" />
    </Extensions>

### WMAppManifest.xml

For Windows Phone 8, if you are doing app based authentication, browser based authentication or Webview based authentication, you additionally need the following configuration in the WMAppManifest.xml file under your project (Properties\WMAppManifest.xml). 

    <Extensions>
       <Protocol Name="fb<your app id>" NavUriFragment="encodedLaunchUri=%s" TaskID="_default" /> <!-- Browser based authentication -->
       <Protocol Name="msft-<your guid as configured on Facebook portal>" NavUriFragment="encodedLaunchUri=%s" TaskID="_default" /> <!-- Facebook app based authentication -->
    </Extensions>



> Note: The custom uri scheme shown above i.e. that of the form *msft-{ProductID}*, where *{ProductID}* is your app's product ID, without the dashes. It should look like this:

    <Protocol Name="msft-43245dd584d84cde837aa19a4a2e3914" NavUriFragment="encodedLaunchUri=%s" TaskID="_default" />

The above protocol launch declarations are required so that after authentication, the facebook app and browser can redirect the access token to your app. 

An example would be:

    <Extensions>
       <Protocol Name="fb128970323969586" NavUriFragment="encodedLaunchUri=%s" TaskID="_default" />
       <Protocol Name="msft-69609250b267436aa7dd8347dd320a3b" NavUriFragment="encodedLaunchUri=%s" TaskID="_default" />
    </Extensions>

> Note: The above section will be inside the Deployment->App section in WMAppManifest.xml as shown below:

    <Deployment>
        <App> 
            Extensions section here 
        </App>
    </Deployment>

## Configuring protocol launch

The SDK has changed the way you get notified of success from the Facebook authentication. Login via the Facebook App or via Mobile Internet Explorer required that calling app be suspended while the authentication happened out of process. Finally, after authentication, the caller would be invoked again. Thus, the architecture of the SDK now includes an application wide callback handler that should be setup as soon as the app starts. To ensure that your app can receive the callbacks after the authentication, make sure that you add the following line in your **App.xaml.cs** as the last line in the **App()** constructor. 

    RootFrame.UriMapper = new FacebookUriMapper();

To resolve the FacebookUriMapper class, you will also need to add the following *using* statement to your code:

    using Facebook.Client;

> Note: If you forget the above line, when your app receives the Authentication, it will likely crash when the authentication is finished.

## Setup a callback for login
Setup a callback so that you can be notified when any session state changes are made. Here is a sample

    public App()
    {
        // You can setup a event handler to be called back when the authentication has finished
       Session.OnFacebookAuthenticationFinished += OnFacebookAuthenticationFinished;

       // This line is from the above step
       RootFrame.UriMapper = new FacebookUriMapper();
     }

     private void OnFacebookAuthenticationFinished(AccessTokenData session)
     {
       // here the authentication succeeded callback will be received.
       // put your login logic here
     }


That's it. You have finished configuring your Windows Phone 8.0/8.1 **Silverlight** app for Facebook and you should be able to following the [LoginButton sample](/docs/phone/controls/login-ui-control)

