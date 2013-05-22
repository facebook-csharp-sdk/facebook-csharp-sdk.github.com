The Facebook SDK for Android provides a method to let you publish stories from your app to a user's timeline. You can also use this method to post a status update on your user's behalf. This method uses the Graph API, and is an alternative to using the Feed Dialog; if you are trying to publish an Open Graph story, you can read the how to here.

To publish a story to a user's timeline, you create a Request object that includes the path to a user's feed and information about the story the app is about to post. Publishing a story will require write permissions to a user's account, so you'll pass the user through a reauthorization flow to get those permissions.

This document walks through the following:

* [Prerequisites](#1)
* [Sample Overview](#2)
* [Step 1: Set Up the Share Button](#3)
* [Step 2: Add Publishing Logic](#4)
* [Step 3: Connect the Share Button](#5)
* [Troubleshooting](#6)
* [Additional Info](#7)


---

## Prerequisites

Before you begin, make sure you already set up [Facebook Login](#). This ensures you have the prerequisites and your app is ready for additional Facebook integration.

---

## Sample Overview


The completed sample application from this tutorial lets users log in with Facebook and publish a link to their Timeline. It builds on top of the sample from Facebook Login, adding a button that posts a hard-coded story to the user's Timeline. If the post is successful, an alert pops up with the story's ID.

->![Running solution](images/running-solution.png)<-

---


## Step 1: Set Up the Share Button

In this step, you'll add the text view that displays the user data.

First, open the Main.xaml file and add a TextBlock control to the main page just below the login button.

{% if page.platform == 'phone' %}
    <TextBlock 
        x:Name="userInfo"
        Width="400"
        VerticalAlignment="Top"
        HorizontalAlignment="Center"
        Margin="0,90,0,0"
        TextWrapping="Wrap"
        Text=""
        FontSize="20"
        Visibility="Collapsed" />
{% endif %}

{% if page.platform == 'windows' %}
    <TextBlock 
        x:Name="userInfo"
        Width="500"
        VerticalAlignment="Top"
        HorizontalAlignment="Center"
        Margin="0,320,0,0"
        TextWrapping="Wrap"
        Text=""
        FontSize="20"
        Visibility="Collapsed" />
{% endif %}

The TextBlock will be set to hidden initially.

If you followed the [Facebook Login](#) doc, you should have a _OnSessionStateChange()_ event handler in your Main.xaml.cs class file that is invoked whenever the user session state changes. Modify this method to show the buttons only when the user is authenticated:

    private void OnSessionStateChanged(object sender, Facebook.Client.Controls.SessionStateChangedEventArgs e)
    {
        if (e.SessionState == Facebook.Client.Controls.FacebookSessionState.Opened)
        {
            this.shareButton.Visibility = Visibility.Visible;
        }
        else if (e.SessionState == Facebook.Client.Controls.FacebookSessionState.Closed)
        {
            this.shareButton.Visibility = Visibility.Collapsed;
        }
    }

---

## Step 2: Add Publishing Logic


---

## Step 3: Connect the Share Button

---

## Troubleshooting

If you're having trouble posting to a user's feed, the Graph API Explorer can give you more detailed error information to help you debug the issue. Be sure that you have asked for the publish actions permission, and that all the fields in your postParams variable are valid.

---

## Additional Info

- [Scrumptious][1]: sample that shows an example of getting user info.
- [Handling Facebook API Errors][2]: Graph API topic on error handling
- [User][3]: Graph API User documentation.

[1]: ../../tutorial/
[2]: https://developers.facebook.com/docs/reference/api/errors/
[3]: https://developers.facebook.com/docs/reference/api/user/
