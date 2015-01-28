---
layout: default
title: LoginButton Control
platform: windows
---

In this document:

* [Overview](#1)
* [Using the LoginButton Control](#2)
* [See Also](#3)

---

## Overview

The [LoginButton](/docs/reference/client/Client.Controls.LoginButton.html) control displays a user interface that allows users to log in or out of a Facebook session.

It keeps track of the authentication status presenting a caption that reflects whether the user is currently authenticated. When a user logs in, it can optionally retrieve basic information from their Facebook profile including first, middle, and last names, user name, birthday, location, and the user’s Facebook URL.

![image](images/image1.png)

---

## Using the LoginButton Control

In this tutorial, you will create an application that you can later reuse as a starting point for completing other tutorials in this series. The application defines a standard layout that includes a [LoginButton](/docs/reference/client/Client.Controls.LoginButton.html) control. Using this control, users log in and obtain an access token which can then be used to retrieve information from Facebook using the controls in the Facebook Client Library.

Before you get started, you need to register a Facebook Application by visiting the Facebook developer portal and obtaining an application ID. For more information, see for example, [Register and Configure a Facebook Application](https://developers.facebook.com/docs/samples/meals-with-friends/register-facebook-application/).

1.	In Visual Studio, create a new project using the **Windows Store Blank App (XAML)** project template. 

1.	Add the Facebook Client Library to your new project. Open the Package Manager Console from **Tools | Library Package Manager | Package Manager Console**, and then type the following command to install the **Facebook.Client NuGet package**.
	
		Install-Package Facebook.Client -pre

		
	![image](images/image2.png)

1.	Open **MainPage.xaml** in your project and switch to its XAML view.

1.	Add the following namespace mapping to the root element of the page allowing you to reference the controls in the Facebook Client Library by using the namespace prefix “_facebookControls_:”.

		xmlns:facebookControls=”using:Facebook.Client.Controls”

	![image](images/image3.png)

1.	Now, insert a new **Grid** control inside the page’s root layout container-the layout root should also be a Grid, assuming you started with one of the standard templates-and define three rows within this grid, as shown below.

		<Grid Background="{StaticResource ApplicationPageBackgroundThemeBrush}">
			<Grid Margin="20">
				<Grid.RowDefinitions>
					<RowDefinition Height="Auto"/>
						<RowDefinition/>
						<RowDefinition Height="Auto"/>
					</Grid.RowDefinitions>
			</Grid>
		</Grid>

	In this layout, the top row will be used to display information about the logged in user, the bottom row will contain a login button, whereas the center row will be used for content and to place other controls in the library as you explore them.

1.	First, define the content of the top row by inserting a panel that will, for the time being, be used to display the name of the user currently logged in. In another tutorial, you will learn how to display the user’s picture in this area using the [ProfilePicture](/docs/reference/client/Client.Controls.ProfilePicture.html) control. 
Use the following XAML markup that defines a **TextBlock** element nested inside a **StackPanel** container.

        <!-- user information -->
        <StackPanel 
            Grid.Row="0"
            HorizontalAlignment="Right">
            <TextBlock 
                HorizontalAlignment="Center" />
        </StackPanel>

1.	Next, insert a **Grid** element to display content in the page. Notice that this element is initially hidden by setting its **Visibility** property to _Collapsed_. It will be made visible only after the user has logged in.

        <!--ContentPanel - place additional content here-->
        <Grid x:Name="ContentPanel" 
            Grid.Row="1"
            Visibility="Collapsed">
        </Grid>

1.	Finally, insert a [LoginButton](/docs/reference/client/Client.Controls.LoginButton.html) control from the Facebook Client Library and assign it to the bottom row of the layout, as shown below.

		<facebookControls:LoginButton 
			x:Name="loginButton" 
			Grid.Row="2" 
			HorizontalAlignment="Right" />

1.	Whenever a user clicks the [LoginButton](/docs/reference/client/Client.Controls.LoginButton.html) and proceeds to log in, the control retrieves profile information about the user and makes it available through its **CurrentUser** property, which returns an instance of a **GraphUser** object. Using this object, you can access information such as the user’s ID, their first, middle, and last name, birthday, location, and profile picture URL, among other values. Note that you can prevent the control from retrieving any information by setting its **FetchUserInfo** property to _false_.

	As mentioned previously, the top row in the page’s layout displays user information, in this case, their name. To set it up, locate the **TextBlock** that you previously inserted into the user information panel in the top row and bind its **Text** property to the **Name** of the **CurrentUser** property provided by the [LoginButton](/docs/reference/client/Client.Controls.LoginButton.html) control, as shown below.
 
	![image](images/image7.png)

1.	Now, insert code to make the content panel visible after the user logs in. To determine when the user has successfully opened the session, use the **SessionStateChanged** event of the [LoginButton](/docs/reference/client/Client.Controls.LoginButton.html) control.

	Add a handler for this event by selecting the button on the design surface, and then showing its Events view in the Properties window. Locate the **SessionStateChanged** event entry, type _OnSessionStateChanged_ as the name of the event handler, then press **ENTER** to create it and switch focus to the code-behind file.
	 
	![image](images/image8.png)

1.	The code-behind file should already contain an empty implementation for the **OnSessionStateChanged** event handler. Complete this implementation by adding the following code that makes the content panel visible when the session state changes to _Opened_.

		private void OnSessionStateChanged(object sender, Facebook.Client.Controls.SessionStateChangedEventArgs e)
		{
			this.ContentPanel.Visibility = (e.SessionState == Facebook.Client.Controls.FacebookSessionState.Opened) ?
										Visibility.Visible : Visibility.Collapsed;
		}

1.	In its current state, the application has no useful content that needs to be displayed. In its place, insert a **TextBlock** element with a welcome message into the content area to be shown once the user logs in.

		<!--ContentPanel - place additional content here-->
		<Grid x:Name="ContentPanel" 
			Grid.Row="1"
			Visibility="Collapsed">
			<TextBlock FontSize="48" 
						HorizontalAlignment="Left" 
						VerticalAlignment="Center" 
						Text="welcome"/>
		</Grid>

1.	The page is ready and you can now test it, but before you do that, verify that you have completed the previous steps successfully by comparing your work with the following XAML markup.

		<Page
			x:Class="FacebookControls.MainPage"
			xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
			xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
			xmlns:local="using:FacebookControls"
			xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
			xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
			xmlns:facebookControls="using:Facebook.Client.Controls"
			mc:Ignorable="d">
		
			<Grid Background="{StaticResource ApplicationPageBackgroundThemeBrush}">
				<Grid Margin="20">
					<Grid.RowDefinitions>
						<RowDefinition Height="Auto"/>
						<RowDefinition/>
						<RowDefinition Height="Auto"/>
					</Grid.RowDefinitions>
		
					<!--user information-->
					<StackPanel HorizontalAlignment="Right">
						<TextBlock 
							HorizontalAlignment="Center"
							Text="{Binding CurrentUser.Name, ElementName=loginButton}" />
					</StackPanel>
					
						<!--ContentPanel - place additional content here-->
						<Grid x:Name="ContentPanel" 
							Grid.Row="1"
							Visibility="Collapsed">
							<TextBlock FontSize="48" 
										HorizontalAlignment="Left" 
										VerticalAlignment="Center" 
										Text="welcome"/>
						</Grid>
		
					<!-- login control -->
					<facebookControls:LoginButton 
						x:Name="loginButton" 
						Grid.Row="2" 
						HorizontalAlignment="Right" 
						ApplicationId="[INSERT-YOUR-FACEBOOK-APPLICATION-ID-HERE]"
						SessionStateChanged="OnSessionStateChanged" />
				</Grid>
			</Grid>
		</Page>
	
1.	Build and run the application. Click **Log In** to start the Facebook authentication process. 
 
	![image](images/image9.png)

1.	Enter your Facebook credentials and click **Log In**.
 
	![image](images/image10.png)

1.	Once the log in dialog window closes, notice that the caption of the button changes to **Log Out** and your user name is displayed in the upper right corner of the page. Lastly, observe the welcome message in the page confirming that the **SessionStateChanged** event was raised to indicate that the session was opened successfully.
 
	![image](images/image11.png)

1.	Click **Log Out** to close the session. 
	Keep in mind that the Facebook access token is cached. If you stop the application in the debugger while the session is open, the next time you run the application and click **Log In**, if the cached token has not expired, you will be logged in without being prompted again for credentials. Clicking **Log Out** closes the session and clears the access token.

---

## See Also

