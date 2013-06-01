Facebook Login allows you to obtain a token to access Facebook's API on behalf of someone using your app. You can use this feature in place of building your own account system or to add Facebook services to your existing accounts.

This document walks through the following topics:

* [Prerequisites](#1)
* [Sample Overview](#2)
* [Step 1: Adding the LoginButton Control to your App](#3)
* [Additional Info](#4)

---

## Prerequisites

Before you get started, you need to register a Facebook Application by visiting the [App Dashboard](http://developers.facebook.com/apps) and obtaining an application ID. For more information, see for example, [Register and Configure a Facebook Application](https://developers.facebook.com/docs/samples/meals-with-friends/register-facebook-application/).

---

## Sample Overview


The completed sample allows people to log in with Facebook by tapping a button. After someone authenticates, they can tap the same button to log out. If the person already authenticated when the app launched, the app remembers the logged-in state and displays a logout button.


->![Running solution](images/running-solution.png)<-

The Facebook SDK for .NET provides a [LoginButton](/docs/windows/controls/login-ui-control/) control that is a custom implementation of a Button. You can use this button in your app to implement Facebook Login. The LoginButton class maintains the session state, which allows it to display the correct text in the button based on the authentication state. Adding LoginButton to your application is a quick way to implement Facebook Login.

---

## Step 1: Adding the LoginButton Control to your App

At the end of this section, someone using your app will be able to click a button to log in with Facebook.

1.	Add the Facebook Client Library to your new project. Open the Package Manager Console from **Tools | Library Package Manager | Package Manager Console**, and then type the following command to install the **Facebook.Client NuGet package**.
	
		Install-Package Facebook.Client -pre
		
	![image](images/image2.png)

1.	Open **MainPage.xaml** in your project and switch to its XAML view.

1.	Add the following namespace mapping to the root element of the page allowing you to reference the controls in the Facebook Client Library by using the namespace prefix “_Controls_:”.

		xmlns:Controls="clr-namespace:Facebook.Client.Controls;assembly=Facebook.Client"

	![image](images/image3.png)

1.	Insert a [LoginButton](/docs/reference/client/Client.Controls.LoginButton.html) control from the Facebook Client Library into your page, as shown below.

{% if page.platform == 'windows' %}
        <Controls:LoginButton
            x:Name="loginButton"
            HorizontalAlignment="Center"
            VerticalAlignment="Top"
            Margin="0,200,0,0"/>
{% endif %}

{% if page.platform == 'phone' %}
		<Controls:LoginButton
			x:Name="loginButton"
			VerticalAlignment="Top"
			HorizontalAlignment="Center"/>
{% endif %}

1.	Set the **ApplicationId** property of the [LoginButton](/docs/reference/client/Client.Controls.LoginButton.html) to the ID obtained when you registered your application in the Facebook portal. 
 
	![image](images/image5.png)

1.	In its current state, the application has no useful content that needs to be displayed. In its place, insert a **TextBlock** element with a welcome message into the content area to be shown once the user logs in.

        <TextBlock 
            x:Name="welcomeMessage"
            Visibility="Collapsed"
			FontSize="32"
            HorizontalAlignment="Left" 
            VerticalAlignment="Center" 
            Text="welcome"/>

1.	Now, insert code to make the content panel visible after the user logs in. To determine when the user has successfully opened the session, use the **SessionStateChanged** event of the [LoginButton](/docs/reference/client/Client.Controls.LoginButton.html) control.

	Add a handler for this event by selecting the button on the design surface, and then showing its Events view in the Properties window. Locate the **SessionStateChanged** event entry, type _OnSessionStateChanged_ as the name of the event handler, then press **Enter** to create it and switch focus to the code-behind file.
	 
	![image](images/image8.png)

1.	The code-behind file should already contain an empty implementation for the **OnSessionStateChanged** event handler. Insert the following code into the event handler body to make the welcome message visible.

		private void OnSessionStateChanged(object sender, Facebook.Client.Controls.SessionStateChangedEventArgs e)
		{
			if (e.SessionState == Facebook.Client.Controls.FacebookSessionState.Opened)
			{
				this.welcomeMessage.Visibility = (e.SessionState == Facebook.Client.Controls.FacebookSessionState.Opened) ?
					Visibility.Visible : Visibility.Collapsed;
			}
		}

Build and run the project to make sure it runs without errors. Tap the _Login_ button to log in with Facebook.

Once authenticated, you should see the welcome message on the page. Notice that the caption on the button changes to **Log Out**. 

Click the button again to close the session.

---

## Additional Info

- [LoginButton][1] - Reference for the LoginButton control

[1]: /docs/windows/controls/login-ui-control/
