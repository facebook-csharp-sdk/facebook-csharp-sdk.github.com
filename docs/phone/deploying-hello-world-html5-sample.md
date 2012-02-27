---
layout: default
title: Deploying the HTML5 'Hello World' Sample for Windows Phone
---

## Getting Started
1.Create Facebook application at http://developers.facebook.com/apps.

2.In basic settings for application, select the Mobile Web integration option and enter the URL to wherever you will host the index.html page. You may host this locally on a web server but it is suggested that you use port 80.

3.In advanced settings for application, disable Enhanced Auth Dialogs. This is currently necessary in order for WP7 apps to successfully requeset permissions from the user (as of 12/5/11).

4.In index.html, replace the application ID currently being sent to the FB.init javascript call with the one for the newly created application.

5.Host the index.html file so that it will be served from the URL that you configured in the Facebook application (step #2).

## Notes
*Based on sample provided as part of Facebook's Javascript SDK.

*This sample has branching logic for WP7 in the cases where dialogs are to be shown and will navigate to m.facebook.com.

*By default, the mobile send request dialog does not currently list friends, but rather includes a link that indicates that you can 'add some friends'. This does not currently work as expected and will instead navigate to the mobile Facebook experience. To work around this, it is recommended that you include a 'to' parameter listing the users to show in the dialog (see commented out code in sendRequest Javascript function).

{% include phone-see-also.md %}