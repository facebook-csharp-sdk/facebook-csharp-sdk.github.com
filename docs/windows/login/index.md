---
layout: default
title: Facebook Login for Windows 8.0/8.1 and Windows Phone 8.1 (.NET CORE/Universal)
---

##Introduction

Facebook Login in Windows/Windows Phone .Net Core apps allows you to offer a personalized experience to your users by integrating social experiences in the app and increasing the app distribution by means of social and viral sharing.
 
 Before you attempt to include login in  your app, make sure to have finished the [config tutorial](/docs/windows/config)

 Once you are done configuring your app with the above tutorial, logging into Windows Phone is as simple as invoking the following call:

    Session.ActiveSession.LoginWithBehavior("email,public_profile,user_friends", FacebookLoginBehavior.<Select a login behavior>);

Where the selected login behavior can be any of the following

    public enum FacebookLoginBehavior
    {
        LoginBehaviorApplicationOnly,
        LoginBehaviorMobileInternetExplorerOnly,
        LoginBehaviorWebViewOnly,
        LoginBehaviorWebAuthenticationBroker
    }

### Availability and explanation
The above login behaviors Availability can be better understood with this table:

![Login Matrix](/docs/windows/login/login-matrix.png)
<!-- 
|                   |  ApplicationOnly                | MobileInternetExplorerOnly               |WebViewOnly                |WebAuthenticationBroker               |
| ----------------- |:-------------------------------:|:----------------------------------------:|:-------------------------:|:------------------------------------:|
| Windows Phone 8.1 | Available                       | Available                                | Available                 | Not Available                        |
| Windows 8.1       | Not Available                   | Not Available                            | Available                 | Available                            |
| Windows 8.0       | Not Available                   | Not Available                            | Available                 | Available                            |
-->

### Detailed Explanation
Here is more detailed explanation:

1. **LoginBehaviorApplicationOnly**: Your application will attempt the login with the Facebook app only. If the Facebook app does not exist on the platform, this will lead to an OS dialog which will prompt the user with "Do you want to search the store for this app"? If successful, you will get a Single Sign On token from this approach, which can be extended with the *Session.CheckAndExtendTokenIfNeeded*. Using this approach, you will be able to invoke the [Facebook Dialogs](/docs/windows/dialog) without any extra login prompts. This method is available ONLY on Windows Phone 8.1 and does not work with Windows 8.x.

2. **LoginBehaviorMobileInternetExplorerOnly**: Your application will attempt the login out of process, using the Mobile Internet Explorer. This option is recommended for most apps since it does not rely on the presence of the Facebook app. This login behavior also provides a Single Sign On behavior since it happens with the Mobile Internet Explorer. Additionally, you get a Single Sign On token from this approach which can be extended with *Session.CheckAndExtendTokenIfNeeded*. Using this approach, you will be able to invoke the [Facebook Dialogs](/docs/windows/dialog) without any extra login prompts. This method is available ONLY on Windows Phone 8.1 and does not work with Windows 8.x.

3. **LoginBehaviorWebViewOnly**: Your application will attempt the login within the app process and will display a modal dialog on top of your existing UI. This method will provide you a single sign on token as well on Windows Phone 8.1. The token on Windows 8.x will be a short lived token. This is not the recommended approach since the user will have to login separately within your app. Using this approach, you will be able to invoke the [Facebook Dialogs](/docs/windows/dialog) without any extra login prompts. On Windows Phone 8.1, you can extend the token using *Session.CheckAndExtendTokenIfNeeded*. However, token extension is not available on Windows 8.x.

4. **LoginBehaviorWebAuthenticationBroker**: Your application will attempt the login using the OS built inWebAuthenticationBroker. However, the Access token obtained using this method is NOT a true Single Sign On token. Additionally, you will not be able to invoke the [Facebook Dialogs](/docs/windows/dialog) with this

> Note: If you have configured the application correctly as per the config document and have attached an event handler to the  **Session.OnFacebookAuthenticationFinished** event, you handler will be called on successful completion of the login. Without this, Facebook Login in  your app will not behave as intended.
