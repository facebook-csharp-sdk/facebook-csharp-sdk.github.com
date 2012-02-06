---
layout: default
title: Facebook C# SDK for Windows Phone
---

# Facebook C# SDK for Windows Phone

Over 350 million users access Facebook from a mobile device every month. Facebook Platform lets you bring these users and their friends to your mobile apps, creating a more engaging and personalized experience for your users.

##Seamless Social Experiences

Facebook Platform enables seamless social experiences across a large variety of devices.

**Distribution.** Users can share with their friends using Requests, News Feed, and Open Graph.

**Engagement.** Bring users back to your app through a bookmark or search. Keep them there by letting them connect with their friends.

**Cross-platform.** The same Javascript SDK works across web and mobile, so it's easy to build one experience that works across multiple devices.

##Login

Authenticated referrals is a new authentication mode for Facebook applications that ensures all referral traffic from Facebook to your application is already connected with Facebook.

This means that visitors arrive on your app already "logged in" and with whatever data permissions (email, likes and interests, etc.) you requested in the Required Permissions section. You can use this information to provide a personalized experience for Facebook visitors the moment they land on your app.

The flow below shows what happens when a user receives a Request (more on that below) and taps on it.

[insert 3 stage screenshot showing receipt of request notification, login to app screen/permissions request, and finally logged into mobile app]


* one issue is that it seems the m.facebook.com mobile site doesn't show notifications at all at the moment (there is a screen for it but I have never seen any listed there when there should be).
* next issue is that (currently) you can't enable Enhanced Auth Dialog option for WP, which I *think* prevents screenshot number 2

Orig screenshot:

[[images/over1.png|height=300px]]


##Social Channels

One benefit of using Facebook Platform is the potential reach you have when Facebook users share content from your app or website with their friends. Because of the strength of a friend’s endorsement, communication through Facebook Platform can help high-quality products grow tremendously. When users tap on links, they are deep-linked directly into your app.

All of the screenshots below illustrate a Mobile Web App integration running on Windows Phone.

##Requests

Requests are a great way to enable users to invite specific friends to play a turn in a game, complete a task, or just generally use your app.

[insert 3 stage screenshot showing request from Facebook mobile app, receipient seeing request notification 'jewel' icon, then looking at notification details]

Orig screenshot:
[[images/over2.png|height=300px]]


##Timeline and Open Graph

After a user adds your app to their Timeline, app specific actions are shared on Facebook via the Open Graph. As your app becomes an important part of how users express themselves, these actions are more prominently displayed throughout the Facebook Timeline and News Feed.

##News Feed

When users log into Facebook, the News Feed is the first thing they see, making it core to the Facebook experience. The screenshots below show you how a user can post to their own wall, which will appear in their friends' News Feeds.

[insert 3 stage screenshot showing post to wall dialog, recipient viewing post on wall, finally viewing post on news feed]

Orig screenshot:
[[images/over2.png|height=300px]]

##Bookmarks

Bookmarks are automatically displayed to the user within Facebook once they login to your app. On our mobile web site, users can now navigate to web apps via bookmarks. Similarly, on our iPhone and iPad apps, users are now able to navigate to native iOS apps. This list of bookmarks is in sync across desktop and mobile so the apps you use most frequently are there when you want them.

[insert screenshot showing bookmark for hackbook or hello world app]

* current problem getting screenshot is that when I go to Bookmarks | Sites on WP, there isn't an Apps bookmark section. Sites is probably the closest to this, and when you click on it there is not an Apps section that I can see. There is an Apps & Games button, but when I click on this I get HTTP 500 errors.

##Search

User can also search for your app within Facebook, whether they have already logged into your app in the past or not.

[insert screenshot showing search for 'hackbook' and that it shows the "Hackbook for Mobile Web" as a result]

* current problem getting screenshot is that m.facebook.com on WP appears to just search people, pages, events, and groups. It does not appear to return app results.

##Social Plugins

Social plugins let you see what your friends have liked, commented on or shared on sites across the web. The like button allows your users to easily share interesting content from your app back to Facebook. Like stories appear on the user's Wall and their friends’ News Feeds. Currently, the [Like button](http://developers.facebook.com/docs/reference/plugins/like/) is only available in mobile web apps.

##Email

When the user authenticates with your app, you can ask them for the email permission, which grants you access to their email address. You can use this to send them information like important updates to your app or actions that their friends have been taking in your app.

##Payments

Facebook Credits allows you to accept payments for digital goods or services within your app.

See our [Credits API doc](http://developers.facebook.com/docs/creditsapi) for information on how to integrate Credits into your mobile web app.

[[images/over10.png|height=300px]]

##Building Mobile Web Apps

Get maximum distribution by integrating social into your mobile web app across many different phone platforms and tablets, including Windows Phone, iOS, and Android.

You can also ship it in native app stores by using the [PhoneGap Facebook plugin](https://github.com/davejohnson/phonegap-plugin-facebook-connect).

Check out some of the [great mobile experiences](http://developers.facebook.com/showcase/mobile) that developers have built using Facebook Platform.

[Click here to get started](http://github.com/microsoft-dpe/wp-toolkit-facebook/wiki/Mobile-Web-Tutorial-for-Windows-Phone).

##Building Windows Phone Apps

If you already have a Windows Phone app, then Facebook Platform enables you to integrate with Facebook login and APIs to create personalized experiences for your users and drive engagement and distribution for your app. You can also use Single Sign-on to let users sign into your app using their Facebook identity.

[Click here to get started](http://github.com/microsoft-dpe/wp-toolkit-facebook/wiki/Getting-Started-with-the-Facebook-Controls-for-Windows-Phone).