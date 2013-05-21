If your application needs the ability to access significant amounts of data in a single go - or you need to make changes to several objects at once, it is often more efficient to batch your requests rather than make multiple individual requests.

This document walks through the following topics:

* [Prerequisites](#1)
* [Sample Overview](#2)
* [Step 1: Set Up the User Interface](#3)
* [Step 2: Send the Batch Request](#4)
* [Best Practices](#5)
* [Additional Info](#6)

---

## Prerequisites

Before you begin, make sure you already set up [Facebook Login](#). This ensures you have the prerequisites and your app is ready for additional Facebook integration.

---

## Sample Overview


The completed sample demonstrates fetching user information via a Batch Request.

The implementation builds on top of Facebook Login, adding a button that initiates a Batch Request and displays the retrieved data.


->![Running solution](images/running-solution.png)<-

---

## Step 1: Set Up the User Interface

In this step, you'll add a button in the initial layout that launches the Batch Request.

First, open the Main.xaml file and add a button control to the main page just below the login button as well as a TextBlock to hold the results of our Batch Request.

{% if page.platform == 'phone' %}
    <Button
        x:Name="queryButton"
        Height="70"
        Width="300"
        VerticalAlignment="Top"
        HorizontalAlignment="Center"
        Margin="0,100,0,0"
        FontSize="20"
        Content="Batch Request"
        Visibility="Collapsed" />
    
    <TextBlock 
        x:Name="txtResults"
        Width="400"
        VerticalAlignment="Top"
        HorizontalAlignment="Center"
        Margin="0,190,0,0"
        TextWrapping="Wrap"
        Text=""
        FontSize="20" />

{% endif %}

{% if page.platform == 'windows' %}
    <Button
        x:Name="queryButton"
        Height="70"
        Width="200"
        VerticalAlignment="Top"
        HorizontalAlignment="Center"
        Margin="0,290,0,0"
        FontSize="20"
        Content="Batch Request"
        Visibility="Collapsed" />
    
    <TextBlock 
        x:Name="txtResults"
        Width="400"
        VerticalAlignment="Top"
        HorizontalAlignment="Center"
        Margin="0,390,0,0"
        TextWrapping="Wrap"
        Text=""
        FontSize="20" />
{% endif %}

The button will be set to hidden initially.

If you followed the [Facebook Login](#) doc, you should have a _OnSessionStateChange()_ event handler in your Main.xaml.cs class file that is invoked whenever the user session state changes. Modify this method to show the buttons only when the user is authenticated:

    private void OnSessionStateChanged(object sender, Facebook.Client.Controls.SessionStateChangedEventArgs e)
    {
        if (e.SessionState == Facebook.Client.Controls.FacebookSessionState.Opened)
        {
            this.queryButton.Visibility = Visibility.Visible;
        }
        else if (e.SessionState == Facebook.Client.Controls.FacebookSessionState.Closed)
        {
            this.queryButton.Visibility = Visibility.Collapsed;
        }
    }

---

## Step 2: Send the Batch Request

In this step, you'll add the logic to send the Batch Request.

Let's assume you have a list of ids that you want to get names for. For this example, we'll simply use a list consisting of the logged-in user and Mark Zuckerberg.

Implement the query button's click event handler to instantiate the FacebookClient object and sends the Batch Request. In the Main.xaml page, set the Click attribute of the "Batch Request" button as shown below.

    <Button 
        x:Name="queryButton"
        ...
        Click="OnBatchRequestButtonClick" />

Add the following code in the Main.xaml.cs file to implement the OnBatchRequestButtonClick event handler:

    private async void OnBatchRequestButtonClick(object sender, RoutedEventArgs e)
    {
        var fb = new Facebook.FacebookClient(this.loginButton.AccessToken);

        dynamic result = await fb.BatchTaskAsync(
            new Facebook.FacebookBatchParameter("me"),
            new Facebook.FacebookBatchParameter("4"));

        txtResults.Text = string.Format("{0}: {1}\n{2}: {3}", result[0].id, result[0].name, result[1].id, result[1].name);
    }

Build and run the project to make sure it runs without errors. Tap the _Log In_ button to log in with Facebook. Once authenticated, tap _Batch Request_ and verify that you see your id and name as well as Mark Zuckerberg's info.

---

## Best Practices

Execute your batch requests asynchronously (with _facebookClient.BatchTaskAsync()_) to avoid running your requests in the UI Thread. This improves performance.

---

## Additional Info

- [BatchTaskAsync][1] - Reference for BatchTaskAsync Methods in Facebook Client class
- [FacebookBatchParameter][2] - Reference for FacebookBatchParameter class
- [Handling Facebook API Errors][3]: Graph API topic on error handling

[1]: /docs/reference/SDK/Facebook.FacebookClient.html#BatchTaskAsync(FacebookBatchParameter[])
[2]: /docs/reference/SDK/Facebook.FacebookBatchParameter.html
[3]: https://developers.facebook.com/docs/reference/api/errors/
