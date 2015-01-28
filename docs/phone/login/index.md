---
layout: default
title: Facebook Login for Windows Phone 8/8.1 (SilverLight Only)
---

##Introduction

Facebook Login in Windows Phone 8 apps allows you to offer a personalized experience to your users by integrating social experiences in the app and increasing the app distribution by means of social and viral sharing.
 
 Before you attempt to include login in  your app, make sure to have finished the [config tutorial](/docs/phone/config)

 Once you are done configuring your app with the above tutorial, logging into Windows Phone is as simple as invoking the following call:

    Session.ActiveSession.LoginWithBehavior("email,public_profile,user_friends", FacebookLoginBehavior.<Select a login behavior>);

Where the selected login behavior can be any of the following

    public enum FacebookLoginBehavior
    {
        LoginBehaviorApplicationOnly,
        LoginBehaviorMobileInternetExplorerOnly,
        LoginBehaviorWebViewOnly,
    }

The above login behaviors can be explained as following:

1. **LoginBehaviorApplicationOnly**: Your application will attempt the login with the Facebook app only. If the Facebook app does not exist on the platform, this will lead to an OS dialog which will prompt the user with "Do you want to search the store for this app"? If successful, you will get a Single Sign On token from this approach, which can be extended with the *Session.CheckAndExtendTokenIfNeeded* 

2. **LoginBehaviorMobileInternetExplorerOnly**: Your application will attempt the login out of process, using the Mobile Internet Explorer. This option is recommended for most apps since it does not rely on the presence of the Facebook app. This login behavior also provides a Single Sign On behavior since it happens with the Mobile Internet Explorer. Additionally, you get a Single Sign On token from this approach which can be extended with *Session.CheckAndExtendTokenIfNeeded*.

3. **LoginBehaviorWebViewOnly**: Your application will attempt the login within the app process and will display a modal dialog on top of your existing UI. Although this method will provide you a single sign on token as well, this is not the recommended approach since the user will have to login separately within your app. However, since the token you will receive will be a Single Sign On token, you will receive all the benefits of a Single Sign On token such as token extension using *Session.CheckAndExtendTokenIfNeeded*.

> Note: If you have configured the application correctly as per the config document and have attached an event handler to the  **Session.OnFacebookAuthenticationFinished** event, you handler will be called on successful completion of the login. Without this, Facebook Login in  your app will not behave as intended.
