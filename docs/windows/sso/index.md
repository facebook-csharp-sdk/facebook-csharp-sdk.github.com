---
layout: default
title: Facebook Login with Single Sign On for Windows Store Apps
---

##Introduction

Facebook Login in Windows Store apps with Single Sign On allows your users to login into any app on the system once using the[WebAuthenticationBroker](http://msdn.microsoft.com/en-us/library/windows/apps/windows.security.authentication.web.webauthenticationbroker.aspx) built into Windows. If another application then wants to access the users facebook account, the user need only provide consent and does not have to sign in again. The Single Sign On experience is provided in a secure manner by the [WebAuthenticationBroker](http://msdn.microsoft.com/en-us/library/windows/apps/windows.security.authentication.web.webauthenticationbroker.aspx) by making sure that Windows Store Apps can be uniquely and safely identified using the Package Security Identifier that Windows assigns to each app.

 Lets take a look at the user experience.  The first time the user connects to facebook they would see this.

![Login dialog box](images/wab_keep_logged_in.png)

In this case the user would provide their credentials.  If they check **keep me logged in** then when the next application, which could be yours, requests access to facebook, the user will not have to provide their credentials again.  Instead the user will see the following. 

![authorize dialog](images/wab_authorize.png)

All the user needs to do is agree to give your application access to the specific information and capabilities provided by facebook.  Once the user authorizes your application, it can continue to access the requested information with no further prompts.   

In this post, we will walk  you through the steps on how to setup your applications for a Single Sign On with [WebAuthenticationBroker](http://msdn.microsoft.com/en-us/library/windows/apps/windows.security.authentication.web.webauthenticationbroker.aspx) for Windows Store apps.


> **Note**: To get the Facebook Login with SSO working, you do not necessarily need to have a Windows Store account. You can simply get your Package Security Identifier (SID) by looking at the value of the AbsoluteURI property of the URI returned by the [GetCurrentApplicationCallbackUri](http://msdn.microsoft.com/en-us/library/windows/apps/windows.security.authentication.web.webauthenticationbroker.getcurrentapplicationcallbackuri.aspx) function of the WebAuthenticationBroker via a debugger, printing it on console (JavaScript Applications) or viewing it by attaching its value to a UI element such as a TextBox. However, It is strongly recommended that you get the value via the Windows Store by following the steps below because the Package Security Identifier is computed by Windows based on your App Name and if there is any difference between the name you reserve in the Store for your app and what you use when creating a project in Visual Studio, the Facebook login may break.

## Setting up on Windows Store app on Facebook
*	Log on to the Facebook developer portal (https://developers.facebook.com) and navigate to your application. Click Edit App or Create new app 

![Edit or Create app](images/edit_create_new_app.png)
 
*	Next, look for the following section on the resulting page, which specifies the place to integrate the Windows Store app setup for Login with Facebook:

![Facebook portal Windows box](images/facebook_portal_windows_box.png)


The Windows Store ID box is the place where you need to enter the App ID for your Windows Store app. To obtain the Windows Store ID for your app and to continue integrating the Login with Facebook in a Single Sign On manner, login to your Windows Store Account at the [Dev Portal](https://appdev.microsoft.com/storeportals) and follow through the rest of the steps.

## Getting Package Security Identifier (SID) from Windows Store dev portal

*	Once you are logged on to Windows Store Developer portal at the link specified in the above step, locate your app on the dashboard and click the Edit link below that :
 
![Facebook portal Windows box](images/StorePortal_dashboard.png)
 
*	Following the above step will lead you to the page containing the details for the app. Once on this page, click on the Services section 

 ![Facebook portal Windows box](images/StorePortal_services.png)

*	On the page that results from above step, Click the Live Services site in there 

 ![Facebook portal Windows box](images/StorePortal_live_services_site.png)

*	On the resulting page, click the Authenticating your service link 

![Facebook portal Windows box](images/StorePortal_authenticating_your_service.png)

*	On the resulting page, the highlighted string in Figure 7 is the the Package Security Identifier or Package SID that you need for the Single Sign On. Note: You should drop the **ms-app://** prefix preceding the Package SID when copying the SID to the Facebook portal.
 
![Facebook portal Windows box](images/StorePortal_app_sid.png)
 
*	Finally, once you have obtained the Package Security Identifier (SID) and copied it over to the Facebook dev portal as specified in Step 1, you simply need to make the WebAuthenticationBroker.authenticateAsync call with the startUri parameter set to include your Package SID as the redirect URL.  Make sure you use the two parameter version of authenticateAsync function instead of the three parameter version with the callback URI. If your app uses Login with Facebook, currently in the startURI parameter, you are likely using the redirect URI as www.facebook.com/connect/login_success.html and you need it to change to your Package SID. Specifically, change the startURI in the authenticateAsync call so that it would change 

From:

https://www.facebook.com/dialog/oauth?client_id=<Your Facebook App ID>&display=popup&response_type=token&redirect_uri=**www.facebook.com/connect/login_success.html** 
 
To:

https://www.facebook.com/dialog/oauth?client_id=<Your Facebook App ID>&display=popup&response_type=token&redirect_uri=**ms-app://[Your Windows Store Package SID]/**

> **Note**: For the first parameter of the *AuthenticateAsync* call, you should use the *None* option unless you are performing advance operations such as silent token extension. These valid values for the first parameter are listed on the [WebAuthenticationOptions page](http://msdn.microsoft.com/en-us/library/windows/apps/windows.security.authentication.web.webauthenticationoptions.aspx) but for Facebook Login scenarios, only *None* and *SilentMode* values are appropriate.

Here is a code sample that showcases the usage with the SDK for Windows Store apps:

    FacebookClient _fb = new FacebookClient();
    var loginUrl = _fb.GetLoginUrl(new
    {
        client_id = Constants.FacebookAppId,
        redirect_uri = Windows.Security.Authentication.Web.WebAuthenticationBroker.GetCurrentApplicationCallbackUri().AbsoluteUri,
        scope = _permissions,
        display = "popup",
        response_type = "token"
    });
 
    WebAuthenticationResult WebAuthenticationResult = await WebAuthenticationBroker.AuthenticateAsync(
          WebAuthenticationOptions.None,
          loginUrl);
 
    if (WebAuthenticationResult.ResponseStatus == WebAuthenticationStatus.Success)
    {
        var callbackUri = new Uri(WebAuthenticationResult.ResponseData.ToString());
        var facebookOAuthResult = _fb.ParseOAuthCallbackUrl(callbackUri);

        // Retrieve the Access Token. You can now interact with Facebook on behalf of the user
        // using the Access Token.
        var accessToken = facebookOAuthResult.AccessToken;
    }
    else if (WebAuthenticationResult.ResponseStatus == WebAuthenticationStatus.ErrorHttp)
    {
        // handle authentication failure
    }
    else
    {
       // The user canceled the authentication
    }

	
Once you have the Access Token, you can easily retrieve information about the user, or their friends by using Facebook Open Graph APIs. Here is a short snippet that shows how you can retrieve the list of friends using the SDK:

    FacebookClient fb = new FacebookClient(App.AccessToken);
 
    dynamic friendsTaskResult = await fb.GetTaskAsync("/me/friends");
    var result = (IDictionary<string, object>)friendsTaskResult;
    var data = (IEnumerable<object>)result["data"];
    foreach (var item in data)
    {
        var friend = (IDictionary<string, object>)item;
        // now you can retrieve data from the dictionary above
        string friendName = string)friend["name"];
        string friendFacebookId = (string)friend["id"];
    }

Its just that easy! 

Check out the [Scrumptious tutorial](/docs/windows/tutorial/) that uses the SDK to build a social meal sharing story to learn more.

## Summary

Login with Facebook using Single Sign On via the WebAuthenticationBroker in Windows Store apps offers your users a simple and convenient way of logging into your applications.  This enables you to easily provide rich and personalized experiences and take advantage of the viral effect of your users social network. To learn how to do so, you can leverage the Facebook C# SDK for Windows Store apps and Windows Phone apps. Check out the Facebook Open Graph APIs that allow you to programmatically publish stories to a user’s Timeline to create personalized user experiences. You can also visit [Facebook Developer Portal](http://developers.facebook.com) to learn more about the Facebook social platform and other ways of integrating social functionality in your apps. Also check out the [Facebook app based login](/docs/phone/sso) functionality for Windows Phone 8 which offers similar experience for the Phone platform.


