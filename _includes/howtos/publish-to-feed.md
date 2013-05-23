The Facebook SDK for .NET provides a method to let you publish stories from your app to a user's timeline. You can also use this method to post a status update on your user's behalf. This method uses the Graph API, and is an alternative to using the [Feed Dialog](../feed-dialog); if you are trying to publish an Open Graph story, you can read the how to [here](../../tutorial/#5).

To publish a story to a user's timeline, you create a use the _PostTaskAsync_ method in the _FacebookClient_ class that includes the path to a user's feed and information about the story the app is about to post. Publishing a story will require write permissions to a user's account, so you'll pass the user through a reauthorization flow to get those permissions.

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


The completed sample application from this tutorial lets users log in with Facebook and publish a link to their Timeline. It builds on top of the sample from [Facebook Login](#), adding a button that posts a hard-coded story to the user's Timeline. If the post is successful, an alert pops up with the story's ID.

->![Running solution](images/running-solution.png)<-

---


## Step 1: Set Up the Share Button

In this step, you'll add the "share" button to the UI that will be visible only if the user has logged in.

First, open the Main.xaml file and add a Button control to the main page just below the login button.

{% if page.platform == 'phone' %}
    <Button
        x:Name="shareButton"
        Height="70"
        Width="300"
        VerticalAlignment="Top"
        HorizontalAlignment="Center"
        Margin="0,100,0,0"
        FontSize="20"
        Content="Share"
        Visibility="Collapsed" />
{% endif %}

{% if page.platform == 'windows' %}
    <Button
        x:Name="shareButton"
        Height="70"
        Width="200"
        VerticalAlignment="Top"
        HorizontalAlignment="Center"
        Margin="0,290,0,0"
        FontSize="20"
        Content="Share"
        Visibility="Collapsed" />
{% endif %}

The Button will be set to hidden initially.

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

In this step, you'll add logic to publish a story to Facebook.

In the _Main.xaml.cs_ class file define a new method called _PublishStory()_. The method will first check if the logged-in user has granted your app publish permissions; if they have not, they will be prompted to reauthorize the app and grant the missing permissions. The SDK provides methods and a standard UI to handle the reauthorization process.

Next, it creates a _FracebookClient_ object that will execute the _PostTaskAsync_ method call to publish a new story to Facebook. Here, you're making a _POST_ to the _Graph API_, so you pass in the current user's access token (in the FacebookClient object), the Graph endpoint we're posting to, a _Dictionary_ of _POST_ parameters, the HTTP method (_POST_) and a callback to handle the response when the call completes.

In a production app, you would add an interface to handle user input, including the ability to add a message. For simplicity, you're going to post a hard-coded story to the user's feed. Note that you will NOT add in a message in this example, as pre-filled messages are against [Facebook's Platform Policies](https://developers.facebook.com/policy/).

{% if page.platform == 'phone' %}
    private async void PublishStory()
    {
        await this.loginButton.RequestNewPermissions("publish_stream");

        var facebookClient = new Facebook.FacebookClient(this.loginButton.CurrentSession.AccessToken);

        var postParams = new
        {
            name = "Facebook SDK for .NET",
            caption = "Build great social apps and get more installs.",
            description = "The Facebook SDK for .NET makes it easier and faster to develop Facebook integrated .NET apps.",
            link = "http://facebooksdk.net/",
            picture = "http://facebooksdk.net/assets/img/logo75x75.png"
        };

        try
        {
            dynamic fbPostTaskResult = await facebookClient.PostTaskAsync("/me/feed", postParams);
            var result = (IDictionary<string, object>)fbPostTaskResult;

            Dispatcher.BeginInvoke(() =>
            {
                MessageBox.Show("Posted Open Graph Action, id: " + (string)result["id"], "Result", MessageBoxButton.OK);
            });
        }
        catch (Exception ex)
        {
            Dispatcher.BeginInvoke(() =>
            {
                MessageBox.Show("Exception during post: " + ex.Message, "Error", MessageBoxButton.OK);
            });
        }
    }
{% endif %}

{% if page.platform == 'windows' %}
    private async void PublishStory()
    {
        await this.loginButton.RequestNewPermissions("publish_stream");

        var facebookClient = new Facebook.FacebookClient(this.loginButton.CurrentSession.AccessToken);

        var postParams = new {
            name = "Facebook SDK for .NET",
            caption = "Build great social apps and get more installs.",
            description = "The Facebook SDK for .NET makes it easier and faster to develop Facebook integrated .NET apps.",
            link = "http://facebooksdk.net/",
            picture = "http://facebooksdk.net/assets/img/logo75x75.png"
        };

        try
        {
            dynamic fbPostTaskResult = await facebookClient.PostTaskAsync("/me/feed", postParams);
            var result = (IDictionary<string, object>)fbPostTaskResult;

            var successMessageDialog = new Windows.UI.Popups.MessageDialog("Posted Open Graph Action, id: " + (string)result["id"]);
            await successMessageDialog.ShowAsync();
        }
        catch (Exception ex)
        {
            var exceptionMessageDialog = new Windows.UI.Popups.MessageDialog("Exception during post: " + ex.Message);
            exceptionMessageDialog.ShowAsync();
        }
    }
{% endif %}

You may have noticed a few things in the code above. First, the response you get from the API call is dynamic type. You can fetch the story ID from the response object by casting it as a _IDictionary<string, object>_ and getting the value asociated with the _id_ key.

You also called a LoginButton control method _RequestNewPermissions_ that will determine whether or not the user has granted the necessary permissions to publish the story and in the case that it doesn't, it will try to add the new permissions to the session.

---

## Step 3: Connect the Share Button

To actually call _publishStory()_ initially, we'll need to implement the click event handler of our Share button. In the Main.xaml page, set the Click attribute of the "Share" button as shown below.


    <Button 
        x:Name="shareButton"
        ...
        Click="OnShareButtonClick" />

Add the following code in the _Main.xaml.cs_ file to implement the _OnShareButtonClick_ event handler:

    private void OnShareButtonClick(object sender, RoutedEventArgs e)
    {
        this.PublishStory();
    }

Build and run the project to make sure it runs without errors. Tap the _Log In_ button to log in with Facebook. Once authenticated, tap _Share_ and verify that you are prompted to reauthorize the app. Afterward, you should see a success alert with the posted story ID. Check your Timeline to verify the story published correctly.

---

## Troubleshooting

If you're having trouble posting to a user's feed, the [Graph API Explorer](https://developers.facebook.com/tools/explorer) can give you more detailed error information to help you debug the issue. Be sure that you have asked for the publish actions permission, and that all the fields in your _postParams_ variable are valid.

---

## Additional Info

- [Scrumptious][1]: sample that shows an example of getting user info.

[1]: ../../tutorial/
