---
layout: default
title: Handling Facebook API Limit Errors
---

##Handling Facebook API Limit Errors
If your app recieves a rate limit error you must wait untill Facebook allows your app to start making requests again, this usually happens with in a few hours.  There are no warnings if you are getting close to a rate limit error.  The best way to prevent getting rate limit errors is to always use a user access token to make any API calls, rate limit errors can happen much faster if an app access token is being used to make api calls.  An example would be loading images dynamically making a graph API call each time the page is loaded for each user like this

      <img src="https://graph.facebook.com/{user fbid you want image of}/picture" />

You may not have not realized that just getting this image is actually making a graph API call.  A good way to prevent these images from giving you a rate limit error is to add the user's access token if you have one

      <img src="https://graph.facebook.com/{user fbid you want image of}/picture?access_token=sadlkfuhwakjcbweklcbklerwuagbvlkajgvklreaklherlkjhersc" />

Check any other places in your app where many API calls are being made without an access token, and add an access_token to the call

{% include web-see-also.md %}