---
layout: default
title: Facebook Helper
---

## Summary

The Facebook helper is designed to integrate your WebMatrix site with Facebook, making it possible to add the [Facebook Social Plugins](http://developers.facebook.com/plugins), such as Like button, Facepile, Comments, Login Button and Like Box, among others, in a few simple steps. It also allows you easily integrate your site with the Facebook login mechanism, so users do not have to create another account just to access your website.

Depending on the social plugin you want to use, the helper requires that you call an initialization method. Check the table below and if the social plugin you want to use does not require initialization see the **Getting Started without initialization** section, otherwise see the **Getting Started with initialization** section.

<table>
    <thead>
        <tr>
            <th>Social Plugin</th>
            <th>Initialization Required</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Like Button</td>
            <td>No</td>
        </tr>
        <tr>
            <td>Activity Feed</td>
            <td>No</td>
        </tr>
        <tr>
            <td>Recommendations</td>
            <td>No</td>
        </tr>
        <tr>
            <td>Like Box</td>
            <td>No</td>
        </tr>
        <tr>
            <td>Login Button</td>
            <td>Yes</td>
        </tr>
        <tr>
            <td>Facepile</td>
            <td>Yes</td>
        </tr>
        <tr>
            <td>Comments</td>
            <td>Yes</td>
        </tr>
        <tr>
            <td>Live Stream</td>
            <td>Yes
                <br />
            </td>
        </tr>
    </tbody>
</table>


## Getting Started Without Initialization

These steps will guide you on how to display a Facebook Like button into your Web site:

1. Add the bolded line from below in the page where you want to show the Like button, in this case for liking the Microsoft Web home page:

    <body>
        ...
        @Facebook.LikeButton("http://www.microsoft.com/web")
        ...
    </body>

## Getting Started With Initialization

These steps will guide you on how to display a Facebook Comments box into your Web site:

1. Make note of the <strong>Site URL</strong>where your Microsoft WebMatrix site is running (click the Site workspace | Settings page).

    ![My Site Settings](/images/wm-mysite-settings.png)

2. [Register](http://www.facebook.com/developers/createapp.php) a new Facebook application and make note of the Application Id and Secret. (Check [http://www.facebook.com/developers](http://www.facebook.com/developers) for instructions on how to create a Facebook application).

    ![Facebook Create Application](/images/FBCreateApplication.png)

3. When creating your Facebook application, make sure you set the Site Url to **http://localhost:[port]**, replacing the __[port]__ placeholder with the port where our local WebMatrix site is running.

    ![Facebook App Settings](/images/FBCoreSettings.png)

4. Add the following line to the **_AppStart.cshtml** page of your WebMatrix Site (create this page if it does not exist). Replace the placeholders with your Application Id and Secret.

    @{ 
    Facebook.Initialize("{your App ID}", "{your App Secret}"); 
    }

5. Add the highlighted lines from below in the page where you want to show the Comments box:

    <!DOCTYPE html>
    <html @Facebook.FbmlNamespaces()>
        ...
        <body>
            @Facebook.GetInitializationScripts()
            ...
            @Facebook.Comments()
            ...
        </body>
    </html>


> Note: Some of the Facebook Social Plugins require that your site is published into a public address where others can use it; see the helper reference for a complete list. To do this you can try some of the *Free* WebMatrix Hostings providers (also check this tutorial on [publishing with WebMatrix](href="http://www.asp.net/webmatrix/tutorials/publish-a-website)).</p>


## Running the Facebook Helper Sample

Optionally, you can download a sample WebMatrix web site where you can see the helper in action, and also see how to use the helper to **integrate the Facebook login mechanism with the membership model of your web site**. To download and run it with Microsoft WebMatrix, follow these steps:

1. Download the sample site from the Downloads section.
2. Extract the content of the package, right-click the Facebook.Bakery folder and select 'Open as a Web Site with Microsoft WebMatrix'. This will open the Bakery sample web site with WebMatrix.
3. Change your WebMatrix site settings to match the Site Url you have configured in your Facebook application settings.

    ![My Site Settings](/images/wm-mysite-settings.png)

4. Open the _AppStart.cshtml page, uncomment the following line and replace the placeholders with your Facebook Application Id and Secret.

    @{ 
    Facebook.Initialize("{your App ID}", "{your App Secret}", "bakery"); 
    }

5. Click on the Run button located in the Home tab.
6. Play with the sample!


## Helper Reference

The helper ships with the following files:

* The **Facebook.cshtml** file located into the <strong>App_Code</strong> folder 
* A **Login.cshtml* file under the **Facebook** folder that will handle user login when using his Facebook account. 


### Helper Properties

> Note: Current version does not support the full Facebook API.

<table>
    <tbody>
        <tr>
            <td>static string</td>
            <td width="715" valign="bottom"><strong>AppId</strong></td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>Gets or sets the Facebook application id.
                <br />
            </td>
        </tr>
        <tr>
            <td>static string</td>
            <td valign="bottom"><strong>AppSecret</strong></td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>Gets or sets the Facebook application secret.
                <br />
            </td>
        </tr>
        <tr>
            <td>static string</td>
            <td valign="bottom"><strong>MembershipDBName</strong></td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>Gets or sets the name of the database used for storing the membership data.
                <br />
            </td>
        </tr>
        <tr>
            <td>static string</td>
            <td valign="bottom"><strong>Language</strong></td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>Gets or sets the code of the language used to display the Facebook plugins.</td>
        </tr>
    </tbody>
</table>


### Helper Methods

<table>
    <tbody>
        <tr>
            <td>&nbsp;</td>
            <td><span style="text-decoration: underline;"><strong>Method</strong></span></td>
            <td><span style="text-decoration: underline;"><strong>Requires Initialization</strong>
            </span></td>
            <td><span style="text-decoration: underline;"><strong>Requires Publishing</strong></span>
            </td>
        </tr>
        <tr>
            <td>static void</td>
            <td><strong>Initialize</strong>(string appId, string appSecret, [string membershipDBName])
            </td>
            <td><strong>-</strong></td>
            <td><strong>-</strong></td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>Initialize the helper with your Facebook application settings.
                <br />
                If the 'membershipDBName' parameter is specified, Facebook membership integration
                will be enabled, allowing users to register and associate their Facebook user account
                (identified with the e-mail) with your site membership and the WebSecurity helper.
                In this case, the helper will initialize the WebSecurity WebMatrix helper automatically
                (if not done previously) and the store the membership information in the 'membershipDbName'
                database.</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>@helper</td>
            <td><strong>GetInitializationScripts()</strong></td>
            <td><strong>-</strong></td>
            <td><strong>-</strong></td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>Initialize the Facebook JavaScript SDK to be able to support the XFBML tags of the
                social plugins.</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>UserProfile</td>
            <td><strong>GetFacebookUserProfile()</strong></td>
            <td>Yes (calling GetInitializationScripts() not required)<strong>
                <br />
            </strong></td>
            <td>No</td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>Retrieves the Facebook profile of current logged in user. See the section at the
                bottom of the page for details on the information you can access.</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>static void</td>
            <td><strong>AssociateMembershipAccount </strong>(string userName)</td>
            <td>Yes (calling GetInitializationScripts() not required )<strong>
                <br />
            </strong></td>
            <td>No</td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>Associates the specified user name (e.g. email, depending on your membership model)
                with the current Facebook User Id from the logged user. See the Facebook.Bakery
                sample Web site for an example on how to use this method.</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>static void</td>
            <td><strong>MembershipLogin</strong>()</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>Creates an authentication cookie with the current Facebook logged User name and
                returns 'true'. If the membership user name cannot be retrieved returns 'false'
                This method can be called after postback to customize page redirection.</td>
            <td>Yes (calling GetInitializationScripts() not required)</td>
            <td>No</td>
        </tr>
        <tr>
            <td>@helper</td>
            <td><strong>LoginButton</strong>(string registerUrl, [string returnUrl], [string callbackUrl]
                [string buttonText], [bool autoLogoutLink], [string size], [string length], [bool
                showFaces], [string extendedPermissions])</td>
            <td>Yes</td>
            <td>No</td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>Shows a Facebok Login Button, with site membership integration, allowing users to
                login on your site with their Facebook account (e-mail).
                <br />
                To use this method, you need to provide the 'membershipDbName' in the helper's Initialize
                method.</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>@helper</td>
            <td><strong>LoginButtonTagOnly</strong>([string buttonText], [bool autoLogoutLink],
                [string size], [string length], [string onLogin], [bool showFaces], [string extendedPermissions])
            </td>
            <td>No<strong>&nbsp;</strong></td>
            <td>No</td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>Shows a Facebook Login Button, without integrating Facebook login with your site
                membership.</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>@helper</td>
            <td><strong>LikeButton</strong>([string href], [string buttonLayout], [bool showFaces],
                [int width], [int height], [string action], [string font], [string colorScheme],
                [string refLabel])</td>
            <td>No<strong>&nbsp;</strong></td>
            <td>No</td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>Shows a Facebook Like Button. When the user clicks the Like button on your site,
                a story appears in the user's friends' News Feed with a link back to your website.
            </td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>@helper</td>
            <td><strong>Comments</strong>([string xid], [int width], [int numPosts], [bool reverseOrder],
                [bool removeRoundedBox])</td>
            <td>Yes<strong>&nbsp;</strong></td>
            <td>No</td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>Shows a Facebook Comments plugin. The Comments Box easily enables your users to
                comment on your site's content &mdash; whether it's for a web page, article, photo,
                or other piece of content.</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>@helper</td>
            <td><strong>Recommendations</strong>([string site], [int width], [int height], [bool
                showHeader], [string colorScheme], [string font], [string borderColor], [string
                filter], [string refLabel])</td>
            <td>No<strong>&nbsp;</strong></td>
            <td>Yes</td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>Shows a Facebook Recommendations plugin. The Recommendations plugin shows personalized
                recommendations to your users.</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>@helper</td>
            <td>
                <p><strong>LikeBox</strong>([string profileId], [string name], [int width], [int height],
                    [string colorScheme], [int connections], [bool showStream], [bool showHeader])
                </p>
            </td>
            <td>No<strong>&nbsp;</strong></td>
            <td>No</td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>Shows a Facebook Like Box. The Like Box is a social plugin that enables Facebook
                Page owners to attract and gain Likes from their own website.</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>@helper</td>
            <td><strong>Facepile</strong>([int maxRows], [int width])</td>
            <td>Yes<strong>&nbsp;</strong></td>
            <td>No</td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>Shows a Facebook Facepile plugin. The Facepile plugin shows the Facebook profile
                pictures of the user's friends who have already signed up for your site.</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>@helper</td>
            <td><strong>LiveStream</strong>([int width], [int height], [string xid], [string viaUrl],
                [bool allwaysPostToFriends])</td>
            <td>Yes (calling GetInitializationScripts() not required) <strong>&nbsp;</strong>
            </td>
            <td>No</td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>Shows a Facebook Live Stream plugin. The Live Stream plugin lets users visiting
                your site or application share activity and comments in real time.</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>@helper</td>
            <td><strong>ActivityFeed</strong>([string site], [int width], [int height], [bool showHeader],
                [string colorScheme], [string font], [string borderColor], [bool showRecommendations])
            </td>
            <td>No<strong>&nbsp;</strong></td>
            <td>Yes</td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>Shows a Facebook Activity Feed plugin. The activity feed displays stories both when
                users like content on your site and when users share content from your site back
                to Facebook.</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>@helper</td>
            <td><strong>OpenGraphRequiredProperties</strong>(string siteName, string title, string
                type, string url, string imageUrl, [string description])</td>
            <td>No<strong>&nbsp;</strong></td>
            <td>Yes</td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>
                <p>OpenGraph properties allows you to specify structured information about your web
                    pages to show up your pages richly across Facebook and enable Facebook users to
                    establish connections to your pages.
                    <br />
                    Use this method to show OpenGraph page data, as the page title, URL, and so on.
                </p>
            </td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>@helper</td>
            <td><strong>OpenGraphLocationProperties</strong>([string latitude], [string longitude],
                [string streetAddress], [string locality], [string region], [string postalCode],
                [string countryName])</td>
            <td>No<strong>&nbsp;</strong></td>
            <td>Yes</td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>Use this method to show page location data. This is useful if your pages is a business
                profile or about anything else with a real-world location. You can specify location
                via latitude and longitude, a full address, or both.</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>@helper</td>
            <td><strong>OpenGraphContactProperties</strong>([string email], [string phoneNumber],
                [string faxNumber])</td>
            <td>No<strong>&nbsp;</strong></td>
            <td>Yes</td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>Use this method to show contact information about your page. Consider including
                contact information if your page is about an entity that can be contacted.</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>@helper</td>
            <td><strong>FbmlNamespaces</strong>()</td>
            <td>No<strong>&nbsp;</strong></td>
            <td>No</td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>Use this method inside your opening HTML tag for W3C compatibility.</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
    </tbody>
</table>


### User Profile Information

<table>
    <tbody>
        <tr>
            <td width="163">string <strong>Id</strong></td>
            <td width="625">Facebook User Id</td>
        </tr>
        <tr>
            <td>string <strong>Name</strong></td>
            <td>Display Name</td>
        </tr>
        <tr>
            <td>string <strong>First_Name</strong></td>
            <td>First Name</td>
        </tr>
        <tr>
            <td>string <strong>Last_Name</strong></td>
            <td>Last Name</td>
        </tr>
        <tr>
            <td>string <strong>Link</strong></td>
            <td>Link to Profile</td>
        </tr>
        <tr>
            <td>string <strong>Bio</strong></td>
            <td>Short biography</td>
        </tr>
        <tr>
            <td>string <strong>Gender</strong></td>
            <td>Gender</td>
        </tr>
        <tr>
            <td>string <strong>Email</strong></td>
            <td>Published e-mail address</td>
        </tr>
        <tr>
            <td>string <strong>Timezone</strong></td>
            <td>User timezone</td>
        </tr>
        <tr>
            <td>string <strong>Locale</strong></td>
            <td>User regional settings</td>
        </tr>
        <tr>
            <td>string <strong>Updated_Time</strong></td>
            <td>Last updated time on Facebook</td>
        </tr>
    </tbody>
</table>