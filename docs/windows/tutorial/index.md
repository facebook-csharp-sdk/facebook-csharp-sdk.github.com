---
layout: default
title: Facebook Scrumptious tutorial for Windows 8
---

##Introduction

This multipart tutorial walks you through integrating Facebook into a C#/XAML based Windows Store app. You'll create a timeline app that lets people post about meals they ate.

This sample app is based on the Scrumptious sample app provided by Facebook for other mobile platforms.  The completed sample is present at [https://github.com/facebook-csharp-sdk/facebook-windows8-sample.git](https://github.com/facebook-csharp-sdk/facebook-windows8-sample.git "https://github.com/facebook-csharp-sdk/facebook-windows8-sample.git") Once you clone the repository, open the project Facebook.Scrumptious.Windows8 This is how the completed sample should look like. 

Facebook Login page

![Facebook Login page](images/Page1/1-FBLoginPage.png)

Scrumptious Landing Page

![Scrumptious Landing Page](images/Page1/2-ScrumptiousLandingPage.png)

Posted event on your timeline

![Posted event on your timeline](images/Page1/3-EventOnTimeline.png)

To complete the tutorial, you'll need some familiarity with Windows Store development. In particular, you will need familiarity with Visual Studio 2012 and being able to create and debug Windows Store projects in C# and XAML. Familiarity with Expression Blend for Visual Studio will be of additional benefit.

### Setting up your Facebook Application
Before you can get started with the Windows 8 Application, you have to create a _Facebook Application_ and obtain a Facebook AppId on the Facebook developer portal. To do this, first you need to go to [Facebook Developer Portal](http://developers.facebook.com/apps) and create a Facebook App.

![Create Facebook App](images/FacebookAppWebsite/1-CreateFBApp.png)

Once you have created the app, you need to edit the app and change a few settings. Make sure to set the _DisplayName_ and _namespace_ appropriately. Also, make sure to set the _email address_. One of the crucial things is the _App Domain_ box. In this box, you should add a domain without the _http://_ prefix. Make sure you have control of the website because later in this tutorial, you will need to place some static pages there. As of yet, Facebook does not have a dedicated section for Windows 8/WP8, so for now, select the section "Website with Facebook Login". in the _Site URL_ field, put the website that you earlier picked for the App Domain, except make sure that you prefix it with an "https://" this time. Don't worry,  you will not have to configure your website with a real SSL functionality. This is just to make the _Facebook Website with Facebook Login_ dialog happy.

![Create Facebook App](images/FacebookAppWebsite/2-EditFBAppBasic.png)

> ATTENTION: You may have to wait 5-10 minutes for the App you just created to propagate through the Facebook system before it becomes Active. If your app's facebook login is not working immediately after you created the App, give it 10 minutes and try again.

### Getting Started on the Application
To get started, create a Visual Studio project using the Visual C# -> Windows Store -> Blank App. Let us call our app the Facebook.Scrumptious.Windows8. Install the Facebook nuget package into the solution by starting the Package Manager powershell by following:

Tools->Library Package Manager->Package Manager console

Once the powershell command prompt is running, type

"Install-Package Facebook"

This will download the nuget package and install the SDK into your project and add it to the references.

![Intall Nuget](images/Introduction/1.1-AddingFacebookNuget.png)

![Facebook Reference](images/Introduction/1.2-AddingFacebook-References.png)

Once you've done that, work through the following steps of the tutorial:

*	Authenticate: Implement Facebook Login and ask the user for the permissions your app needs.
*	Personalize: Personalize the user's experience with their profile picture and name when they log in.
*	Show Friends: Display the user's friend list and let them select one or more friends.
*	Show Nearby Places: Display a list of nearby places and let the user tag their location.
*	Publish an Open Graph Action: Publish activity from your app to timeline and news feed, and set up the back-end server for Open Graph objects.

By the end of this tutorial, you should have a working understanding of how to log a user into to Facebook, personalize their experience and make an app social. Let's start the tutorial.

##Authenticate

###Setup the project

Create two folders called ViewModel and  Views in the project. This is how it will look like:

![Create Folder](images/Authenticate/2-CreateFolders.png)

Delete the MainPage.xaml and MainPage.xaml.cs from the project. We will keep all our views in the Views Folder. Right click on the "Views" folder and select "Add New Item".  

Select Blank Page and name it HomePage.xaml. This page will host our Facebook login button.

![Add Home Page](images/Authenticate/2.1-AddHomePage.png)

Now in App.xaml.cs, change where it says MainPage to HomePage. This will make the application use the HomePage as the default page to start up with.

    if (!rootFrame.Navigate(typeof(MainPage), args.Arguments))

to 

    if (!rootFrame.Navigate(typeof(HomePage), args.Arguments))

This will show a Red line under the HomePage showing Visual Studio does not know where HomePage class is located. This can easily be resolved by right clicking on HomePage and selecting 'Resolve". 

![Resolve Home Page](images/Authenticate/2.2-ResolveHomePage.png)

You can also resolve this  by manually typing:

    using Facebook.Scrumptious.Windows8.Views; 

at the top of the page. In future references, I will assume that you know how to resolve a reference.

The HomePage will host our Facebook login button and the Facebook login code.

At this point, we will additionally add another page that we want to navigate to once the authentication has succeeded. To do so, just like before add another page using "Add new Item". This time, select Visual C# on the left in the Add Dialog and then select "Basic Page" in the middle pane. Name this page "LandingPage.xaml" 

![Add Landing Page](images/Authenticate/3-AddLandingPage.png)

This will show a prompt saying that to satisfy dependencies, more files will be automatically added. Say yes to this. This steps automatically adds files that allow easy navigation within Windows Store apps by providing Navigation Stack functionality. It automatically adds a back button to the landing page as well. The dependencies are brought in only once, so once you have added them, the next time you add a Basic page, you will not need to add them again. In future references, I will assume you know how to add Pages to the Views folder.

![Add Dependencies](images/Authenticate/4-AddDependencies.png)

### Setup the User Interface

In App.xaml.cs add the following two variables to hold the Facebook OAuth Access Token and the User's ID once they have logged in into Facebook:

    internal static string AccessToken = String.Empty;
    internal static string FacebookId = String.Empty;

Now Replace the contents of HomePage.xaml with the following. All the following does is to add some text to the Page and a button for facebook login. Additionally, it says that the button click will be handled by an event handler named "btnFacebookLogin_Click".
    
    <Page
        x:Class="Facebook.Scrumptious.Windows8.Views.HomePage"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:local="using:Facebook.Scrumptious.Windows8.Views"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        mc:Ignorable="d">
    
        <Grid>
    
            <Grid.RowDefinitions>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="*"/>
            </Grid.RowDefinitions>
            <TextBlock Text="Facebook Scrumptious Sample for Windows 8" FontSize="50"/>
            <Button Grid.Row="1" Content="Login To Facebook" Height="73" HorizontalAlignment="Center" Name="btnFacebookLogin" VerticalAlignment="Center" Width="276" Click="btnFacebookLogin_Click" />
    
        </Grid>
    </Page>

In HomePage.xaml.cs, add the following two internal variables. The _permissions_ variable to hold a reference to all the extended permissions our application will require i.e. ability to access the user's profile, the ability to read their news feed and the publish to their news feed. The _fb_ variable of type FacebookClient to instantiate the SDK defined facebook client that we will use in the rest of the tutorial to interact with the Facebook APIs. 

    string _permissions = "user_about_me,read_stream,publish_stream";
    FacebookClient _fb = new FacebookClient();
    
Additionally, add the following code which defines the event handlers for the facebook login button. The following code

        private async void btnFacebookLogin_Click(object sender, RoutedEventArgs e)
        {
            var redirectUrl = "https://www.facebook.com/connect/login_success.html";
            try
            {
                //fb.AppId = facebookAppId;
                var loginUrl = _fb.GetLoginUrl(new
                {
                    client_id = Constants.FacebookAppId,
                    redirect_uri = redirectUrl,
                    scope = _permissions,
                    display = "popup",
                    response_type = "token"
                });

                var endUri = new Uri(redirectUrl);

                WebAuthenticationResult WebAuthenticationResult = await WebAuthenticationBroker.AuthenticateAsync(
                                                        WebAuthenticationOptions.None,
                                                        loginUrl,
                                                        endUri);
                if (WebAuthenticationResult.ResponseStatus == WebAuthenticationStatus.Success)
                {
                    var callbackUri = new Uri(WebAuthenticationResult.ResponseData.ToString());
                    var facebookOAuthResult = _fb.ParseOAuthCallbackUrl(callbackUri);
                    var accessToken = facebookOAuthResult.AccessToken;
                    if (String.IsNullOrEmpty(accessToken))
                    {
                        // User is not logged in, they may have canceled the login
                    }
                    else
                    {
                        App.AccessToken = accessToken;

                        // User is logged in and token was returned
                        LoginSucceded();
                    }

                }
                else if (WebAuthenticationResult.ResponseStatus == WebAuthenticationStatus.ErrorHttp)
                {
                    throw new InvalidOperationException("HTTP Error returned by AuthenticateAsync() : " + WebAuthenticationResult.ResponseErrorDetail.ToString());
                }
                else
                {
                    // The user canceled the authentication
                }
            }
            catch (Exception ex)
            {
                //
                // Bad Parameter, SSL/TLS Errors and Network Unavailable errors are to be handled here.
                //
                throw ex;
            }
        }

Also add the following code to set the User's FacebookId in _App.FacebookId_ and to navigate to the LandingPage when the login has succeeded:
 
        private async void LoginSucceded()
        {
            FacebookClient _fb = new FacebookClient(App.AccessToken);

            dynamic parameters = new ExpandoObject();
            parameters.access_token = App.AccessToken;
            parameters.fields = "id";

            dynamic result = await _fb.GetTaskAsync("me", parameters);

            App.FacebookId = result.id;
            Frame.Navigate(typeof(LandingPage));
        }

At this step, also add a new item of type _class_ to the _ViewModel_ folder. Call the class _Constants.cs_ and add the following code to it. Make sure to replace the string _Your Facebook App ID here_ with your Facebook App ID that you obtained earlier when you created your app on the Facebook Developer Portal.

    class Constants
    {
        public static readonly string FacebookAppId = "Your Facebook App ID here";
    }

        
Make sure to resolve any missing dependencies as illustrated earlier to ensure that the code builds without errors. You should now be able to run the app and login to Facebook. You should also see the dialog to add extended permissions. When executed, your app should present you with the following dialogs. When you are successfully logged in, you should be naviated to a blank page - LandingPage.

Login Page

![Login and Extended Permissions Page](images/Authenticate/5-LoginPage.png)

Basic Permissions Page

![Login and Extended Permissions Page](images/Authenticate/6-BasicPermission.png)

Extended Permissions Page

![Login and Extended Permissions Page](images/Authenticate/7-ExtendedPermissions.png)

[Todo] Logout - reset App.AccessToken = String.Empty


##Personalize

This tutorial outlines how to personalize your app experience with the Facebook SDK for Windows 8 by displaying the user's profile picture and name.

### Setup the UI. 

Insert the following code to LandingPage.xaml with the following content, which merely adds an image control and a TextBlock to hold the User's profile picture and name. Make sure to insert this right after the declaration of the back button and page title Grid:

        <Grid Grid.Row="1">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="208*"/>
                <ColumnDefinition Width="475*"/>
            </Grid.ColumnDefinitions>
            <StackPanel HorizontalAlignment="Center" VerticalAlignment="Center">
                <Image x:Name="MyImage" Height="100" Width="100"/>
                <TextBlock x:Name="MyName" TextWrapping="Wrap" Text="TextBlock" FontFamily="Segoe UI" FontSize="29.333"/>
            </StackPanel>
        </Grid>
        
Also, give a correct name to the page by changing the AppName from _My Application_ to _Scrumptious_ in the XAML file.

### Retrieve the User's profile data and display it

At this point, the user has been Authenticated and their AccessToken and FacebookId is stored in App.xaml.cs static variables and hence it is available throughout the program. Now copy the following code into LandingPage.xaml.cs:

        private async void LoadUserInfo()
        {
            FacebookClient _fb = new FacebookClient(App.AccessToken);

            dynamic parameters = new ExpandoObject();
            parameters.access_token = App.AccessToken;
            parameters.fields = "name";

            dynamic result = await _fb.GetTaskAsync("me", parameters);

            string profilePictureUrl = string.Format("https://graph.facebook.com/{0}/picture?type={1}&access_token={2}", App.FacebookId, "large", _fb.AccessToken);

            this.MyImage.Source = new BitmapImage(new Uri(profilePictureUrl));
            this.MyName.Text = result.name;
        }
        
The above code retrieves the user profile data. It additionally creates a URL for the user's profile picture and sets it as the source of the image. This causes the image to automatically retrieve the profile picture and load it correctly.

As a Final step in personalization, we have to invoke the function as soon as the page has been loaded. To do this, add the following line in the Constructor after the InitializeComponent call:

    LoadUserInfo();
            
As before, make sure to resolve any missing dependencies as illustrated earlier to ensure that the code builds and runs without errors. At the end of this step, your UI for landing page will look like the following:

![Personalized Page](images/Personalize/Personalized-Page.png)


##Show Friends

### Creating the UI

Download the file [dl]: Assets/icons.zip to get the icons for the tutorial. Uncompress the file and drag all the icons to the Assets folder in Visual Studio project window.

After that, add the following code to LandingPage.xaml. This adds an icon and Text for _Selecting Friends_. Additionally, it wires up the tap event on the _Select Friends_ TextBlock via an event handler named selectFriendsTextBox_Tapped.


            <StackPanel Grid.Column="1" Margin="10,0,0,0" VerticalAlignment="Center">
                <Grid x:Name="WithWhomGrid" >
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="150"/>
                        <ColumnDefinition Width="
						*"/>
                    </Grid.ColumnDefinitions>
                    <Image HorizontalAlignment="Center" Height="150" VerticalAlignment="Center" Width="150"  Grid.Column="0" Stretch="None" Source="ms-appx:///Assets/PersonWin8.png" />
                    <StackPanel Grid.Column="1">
                        <TextBlock TextWrapping="Wrap" Text="With Whom?" FontFamily="Segoe UI" FontSize="48"/>
                        <TextBlock x:Name="selectFriendsTextBox" TextWrapping="Wrap" Text="Select Friends" FontFamily="Segoe UI" FontSize="26.667" Foreground="#FF6DB7C7" Tapped="selectFriendsTextBox_Tapped"/>
                    </StackPanel>
                </Grid>
            </StackPanel>

We will now make the app a bit more interactive and let the user pick out their friends.

### Create the ViewModel class

Create an static ObservableCollection of friends that you will later use to connect the UI to the data. Making it ObservableCollection allows you to use one of the strongest points of XAML, data binding.
In the ViewModel folder, create a new item of type Class and set its name to be _FacebookDataModel.cs_ Inside this file, remove the class FacebookDataModel and paste the following code which defines a class representing a _Facebook Friend_. We are also declaring an _ObservableCollection of Friend_ inside another class called _FacebookData_ which will represent the list of our friends. Declaring this as an _ObservableCollection_ has the added advantage that we can use Expression Blend to easily bind the collection data to the UI without having to write complicated DataModel<->UI synchronization logic.

        public class Friend
        {
            public string id { get; set; }
            public string Name { get; set; }
            public Uri PictureUri { get; set; }
        }

        public class FacebookData
        {
            private static ObservableCollection<Friend> friends = new ObservableCollection<Friend>();
            public static ObservableCollection<Friend> Friends
            {
                get
                {
                    return friends;
                }
            }
        }

### Create the Friend Picker Page
To the Views directory, add a Basic Page called FriendSelector.xaml. This page will hold the UI for showing and picking friends.

Now finally, create the handler for the tapping event on the _Select Friends_ text box. Paste the following in the LandingPage.xaml.cs, which brings down the list of friends from Facebook.

        async private void selectFriendsTextBox_Tapped(object sender, TappedRoutedEventArgs evtArgs)
        {
            FacebookClient fb = new FacebookClient(App.AccessToken);

            dynamic friendsTaskResult = await fb.GetTaskAsync("/me/friends");
            var result = (IDictionary<string, object>)friendsTaskResult;
            var data = (IEnumerable<object>)result["data"];
            foreach (var item in data)
            {
                var friend = (IDictionary<string, object>)item;

                FacebookData.Friends.Add(new Friend { Name = (string)friend["name"], id = (string)friend["id"], PictureUri = new Uri(string.Format("https://graph.facebook.com/{0}/picture?type={1}&access_token={2}", (string)friend["id"], "square", App.AccessToken)) });
            }

            Frame.Navigate(typeof(FriendSelector));
        }

Let's take a deeper look at the code to fetch the list of Friends. The following line follows the async/await pattern in .NET 4.5, which is to say, that the GetTaskAsync function suspends execution of the selectFriendsTextBox_Tapped function and waits for the results of GetTaskAsync function to become available. One more thing to note is that the type of friendsTaskResult is _dynamic_ which means that the actual type of the variable will be interpreted at runtime. If the operation being performed on the data type is not valid, the runtime will issue an error.

        dynamic friendsTaskResult = await fb.GetTaskAsync("/me/friends");

Thus, when we want to unravel the friendsTaskResult, we have to understand it's schema. The [Graph Explorer on facebook](https://developers.facebook.com/tools/explorer/) is an invaluable tool for this purpose. Navigate to the above Graph Explorer website, login and fetch the URL _/me/friends_ to see how facebook sends the data back in JSON format:

![Graph Explorer](images/Friends/1-graphexplorer.png)

The data returned is similar to the following:
        
        {
            "data": [
                        {
                            "name": "Ashu Razdan", 
                            "id": "2516036"
                        }, 
                        {
                            "name": "Jessie Rymph", 
                            "id": "3103754"
                        }
                    ]
        }
    
You can navigate data similar to above using _dynamic_ data type and _dictionaries_ pretty simply as shown below. The following typecasts the dynamic data returned into a dictionary of _<string,object>_. From that, we retrieve the value corresponding to the key _data_ in the dictionary.

        var result = (IDictionary<string, object>)friendsTaskResult;
        var data = (IEnumerable<object>)result["data"];
            
Following similar logic, we can retrieve each of our friends as a single object in the _foreach_ statement. Once we have obtained each object, we again typecast it to another dictionary and pick up the individual properties as shown below. This style of parsing data allows you to pick data from JSON objects without needing to create DeSerializer classes. We now, create _Friend_ objects and add them to the _static ObservableCollection_ named _Friends_ in the _FacebookData_ class. We will shortly use this Collection to create our Friend Selector page.

            foreach (var item in data)
            {
                var friend = (IDictionary<string, object>)item;

                FacebookData.Friends.Add(new Friend { Name = (string)friend["name"], id = (string)friend["id"], PictureUri = new Uri(string.Format("https://graph.facebook.com/{0}/picture?type={1}&access_token={2}", (string)friend["id"], "square", App.AccessToken)) });
            }
            
### Create the Friend Picker

Now that we have the Friends list as an ObservableCollection, we can create and bind it to the  UI using code, but it is much easier doing that using Expression Blend, so let's instead do that. To use Expression Blend on the project, right click on the project in Visual Studio and select _Open in Blend_. 

>NOTE: Expression blend is one of the tools that makes developing UI in XAML extremely easy. Additionally, binding list data to UI becomes extremely easy with Blend. It is worth learning Expression Blend if you plan to do any long term development in C#/XAML. 


3. Create the UI. Add a Listview to the UI. Edit item template in blend and add image and text box for friend names. Create data binding. Showcase what is happening under the hood. Allow multiselect on the list.

4. Hook into the listview select event and creaet a list of all the selected friends in the model for later use. Save it in the Data Model.

### Next Steps
Create three panels, one each for the restaurant, meal and friends. You can do this manually as well, but blend is a lot easier and faster. Setup event handlers for all the tap events.

Connecting to open graph actions

Look at the Open Graph API for reference on how to fetch various kinds of data. Use the GetDataAsync or PostDataAsync to navigate to the URL depending on operation. Passing the parameters is pretty easy by just creating a new object with properties set to the parameter names etc. No need to pre-create these objects.

Wire up so that as soon as user navigates to this page, their usename and picture is fetched and connected to the interface.


##Show Nearby Places

1. Add the UI on the Landing page to navigate to the place picking page and

2. In the event handler, write the code to initialize the Location sensor and get a location fix. We keep a default location in case the sensor has trouble getting a fix.

3. Using the location, make a graph query for restaurants. 

4. Update the data model with the list of restaurants

5. Create the Page for picking a location. Setup the UI for that. Drop a listbox, Setup the data binding for that. Pick the "additional templates", Create a template, - setup the UI by using an image, two textboxes and multiple grid/stack panels. See if you can update the UI to pick the dark blue state on selected state. On selection event, update the DataModel with the element that has been selected.

## Publish Open Graph Story

In this tutorial, you'll bring everything together and publish an Open Graph story. The previous steps let the user specify where they are and who they're with. Now, we'll implement a flow that lets the user select a meal and share what they're doing on their timeline.

Copy these three steps as is:

Step 1: Configure Open Graph in the App Dashboard
Step 2: Set Up Your Backend Server
Step 3: Publish a Test Action
 

Add the meal selection flow:

Setup the Data Model.
Setup the UI - listview, bound to the Data Model. On Select event, change the data model with what was selected
On Navigated event in Landing Page change the meal to the one you just selected.
Wire up the Appbar button to post the action to facebook
Congratulations, you just finished the Windows 8 tutorial.