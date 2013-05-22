The Facebook SDK for .NET includes methods to access the [Graph API User](https://developers.facebook.com/docs/reference/api/user/) object. It also supports strongly-typed access to common _User_ properties.

The _LoginButton_ class event _UserInfoChanged_ can be used to obtain the user data from a Graph API call. When you log in, the control creates a call to the _/me_ Graph API endpoint. The permissions in the _access_token_ that are sent with the API call control the returned data (ex: if no access token is provided, only public info will be returned). See the [User doc](https://developers.facebook.com/docs/reference/api/user/) for more details on _User_ properties and permissions.

If the API call is successful, a _GraphUser_ object is passed in to the _UserInfoChanged_ event handler method that provides typed access to the following _User_ fields: _id, name, first_name, middle_name, last_name, link, username, birthday, location and picture_. You have access to other user properties using an _index_ on the result data.

This doc outlines how to use the SDK to request user data and retrieve user details for fields available via typed access and non-typed access.

This document walks through the following:

* [Prerequisites](#1)
* [Sample Overview](#2)
* [Step 1: Set Up the UI](#3)
* [Step 2: Ask for Permissions](#4)
* [Step 3: Fetch User Data](#5)
* [Additional Info](#6)


---

## Prerequisites

Before you begin, make sure you already set up [Facebook Login](#). This ensures you have the prerequisites and your app is ready for additional Facebook integration.

---

## Sample Overview


The completed sample lets users log in with Facebook and view a sample set of their data, including their name, birthday, current city and languages. This data illustrates the following combinations:

- Data that needs permissions other than basic permission.

- Data that is strongly typed through the _GraphUser_ interface.

- Data that is not strongly typed through the _GraphUser_ interface.

The sample builds on top of [Facebook Login](#), adding a non-editable text view that displays the returned user data:

->![Running solution](images/running-solution.png)<-

---


## Step 1: Set Up the UI

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
            this.userInfo.Visibility = Visibility.Visible;
        }
        else if (e.SessionState == Facebook.Client.Controls.FacebookSessionState.Closed)
        {
            this.userInfo.Visibility = Visibility.Collapsed;
        }
    }

---

## Step 2: Ask for Permissions

In this step, you'll configure your app to ask for permissions to display the sample set of user data. You'll ask for _user_location_ to get the user's current city, _user_birthday_ to get their birthday, and _user_likes_ to get their languages. The other user data you'll display are available publicly or with basic permissions.

If you followed the [Facebook Login](#) doc, you should have a LoginButton control instance set up in the Main.xaml file. Open up the Main.xaml page. To request additional permissions, set the permissions attribute of the "loginButton" button as shown below:

    <Button 
        x:Name="loginButton"
        ...
        Permissions="user_location, user_birthday, user_likes" />

---

## Step 3: Fetch User Data

In this step, you'll fetch the user info when the user authenticates. Again, the user data you can access depends on the permissions a user has granted your app along with the data a user has chosen to share with apps. To get an idea of the data you can access, here's an example Graph API raw response for the permissions in the previous step:

    {
        bio = "Love sports of all kinds.";
        birthday = "01/01/1980";
        "favorite_athletes" = (
            {
                id = 20242388857;
                name = "Usain Bolt";
            }
        );
        "first_name" = Chris;
        hometown = {
            id = 106033362761104;
            name = "Campbell, California";
        };
        id = 100003086810435;
        languages = (
            {
                id = 108106272550772;
                name = French;
            },
            {
                id = 312525296370;
                name = Spanish;
            }
        );
        "last_name" = Colm;
        link = "https://www.facebook.com/chris.colm";
        locale = "en_US";
        location =             {
            id = 104048449631599;
            name = "Menlo Park, California";
        };
        "middle_name" = Abe;
        name = "Chris Abe Colm";
        timezone = "-7";
        "updated_time" = "2012-08-09T03:33:32+0000";
        username = "chris.colm";
        verified = 1;
    }

Some of the data in this response can be accessed as strongly typed properties of the properties of the _GraphUser_ interface - example: _name_ and _birthday_. This step shows you how to access the user's _name_, _birthday_, _languages_, _location_ and _locale_.

Define a private helper method that takes in the returned user data and builds up the display string:

    private string BuildUserInfoDisplay(Facebook.Client.GraphUser user)
    {
        var userInfo = new System.IO.StringWriter();

        // Example: typed access (name)
        // - no special permissions required
        userInfo.WriteLine(string.Format("Name: {0}", user.Name));
        userInfo.WriteLine();

        // Example: typed access (birthday)
        // - requires user_birthday permission
        userInfo.WriteLine(string.Format("Birthday: {0}", user.Birthday));
        userInfo.WriteLine();

        // Example: partially typed access, to location field,
        // name key (location)
        // - requires user_location permission
        userInfo.WriteLine(string.Format("City: {0}", user.Location.City));
        userInfo.WriteLine();

        // Example: access via property name (locale)
        // - no special permissions required
        userInfo.WriteLine(string.Format("Locale: {0}", user["locale"] ?? string.Empty));
        userInfo.WriteLine();

        // Example: access via key for array (languages) 
        // - requires user_likes permission
        var languages = user["languages"] as List<object>;
        if (languages.Count > 0)
        {
            var languageNames = new List<string>();
            foreach (var languaje in languages)
            {
                var lang = languaje as dynamic;
                // Add the language name to a list.
                languageNames.Add(lang["name"]);
            }
            userInfo.WriteLine(string.Format("Languages: {0}", string.Join(", ",languageNames)));
        }

        return userInfo.ToString();
    }

Implement the "loginButton"'s UserInfoChanged event handler to fetch the user data. In the Main.xaml page, set the UserInfoChanged attribute of the "loginButton" button as shown below.

    <Button 
        x:Name="loginButton"
        ...
        Permissions="user_location, user_birthday, user_likes"
        UserInfoChanged="OnUserInfoChanged" />

Add the following code in the Main.xaml.cs file to implement the _OnUserInfoChanged()_ event handler by using the helper method to parse the data and then setting the TextBlock with the results:

    private void OnUserInfoChanged(object sender, Facebook.Client.Controls.UserInfoChangedEventArgs e)
    {
        this.userInfo.Text = this.BuildUserInfoDisplay(e.User);
    }

Build and run the project to make sure it runs without errors. Tap the _Login_ button to log in with Facebook.

During the authentication step, you should see a dialog asking for the permissions you requested. Once authenticated, you should see the sample set of user data.

---

## Additional Info

- [Scrumptious][1]: sample that shows an example of getting user info.
- [Handling Facebook API Errors][2]: Graph API topic on error handling
- [User][3]: Graph API User documentation.

[1]: ../../tutorial/
[2]: https://developers.facebook.com/docs/reference/api/errors/
[3]: https://developers.facebook.com/docs/reference/api/user/
