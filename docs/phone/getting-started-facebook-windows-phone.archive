---
layout: default
title: Getting Started with the Facebook Controls for Windows Phone
---

**Prerequisites: Visual Studio 2010 SP1, Windows Phone SDK 7.1**

This getting started guide will introduce the Facebook Controls for Windows Phone and help get the developer up to speed on how to incorporate the controls into their Windows Phone applications. The controls have a dependency on the Facebook C# SDK that can be found at http://facebooksdk.codeplex.com/. You will want to look into the Facebook C# SDK in order to interact with Facebook beyond showing dialogs.

[[images/wishlistScreen1.png|alt=Wishlist sample|height=300px]]  [[images/hackbookScreen1.png|alt=Hackbook sample|height=300px]]

## Install NuGet Package Manager

1.Install latest NuGet Package Manager software from http://nuget.org. NuGet is a Visual Studio extension that makes 
it easy to install and use many different frameworks, including the controls for Windows Phone. You can check to see 
if you have NuGet installed in Visual Studio from Tools | Extension Manager.

## Hello World

This sample shows how to quickly integrate the Facebook Controls into your Windows Phone application and show a Facebook dialog.

1.Create a new Facebook application and take note of the App ID.

[[images/phone1.png|height=250px]]

2.Load Visual Studio and select File | New | Project... from main menu.

3.Select 'Windows Phone Application' template, provide a name if desired, and then click OK.

4.Select 'Windows Phone OS 7.1' from the New Windows Phone Application dialog and then click OK.

[[images/phone2.png|height=150px]]

5.Right-click on the project node in Solution Explorer and select Manage NuGet Packages from the context menu.

[[images/phone3.png|height=70px]]

6.Search online for "Facebook Controls for Windows Phone" and click on Install to add the needed libraries to your project.

[[images/phone4.png|height=300px]]

Note: if the NuGet package is not currently available, you can download the Facebook Controls project from http://github.com/microsoft-dpe/wp-toolkit-facebook/tree/master/code/Facebook.Phone.

7.Load XAML view for MainPage.xaml and add the following XML namespace declaration to the page:  
```
xmlns:facebook="clr-namespace:Facebook.Phone.Dialogs;assembly=Facebook.Phone.Dialogs"
```

8.Also in MainPage.xaml, locate the StackPanel with name "TitlePanel" and add a FacebookLoginButton control after the last TextBlock. The StackPanel should now look like:  
```
<StackPanel x:Name="TitlePanel" Grid.Row="0" Margin="12,17,0,28">
    <TextBlock x:Name="ApplicationTitle" Text="MY APPLICATION" Style="{StaticResource PhoneTextNormalStyle}"/>
    <TextBlock x:Name="PageTitle" Text="page name" Margin="9,-7,0,0" Style="{StaticResource PhoneTextTitle1Style}"/>
    <facebook:FacebookLoginButton />
</StackPanel>
```

[[images/phone5.png|height=300px]]

9.Add the ExtendedPermissions property to the FacebookLoginButton with a CSV list of permissions that you would like to request from the user:  
```
<facebook:FacebookLoginButton ExtendedPermissions="user_status" />
```

10.In the Grid named "ContentPanel", add a FacebookAuthenticatedPanel with placeholders for content to be shown to the user when logged in or logged out:  
```
<Grid x:Name="ContentPanel" Grid.Row="1" Margin="12,0,12,0">
    <facebook:FacebookAuthenticatedPanel>
    <facebook:FacebookAuthenticatedPanel.LoggedInContent>
                    
    </facebook:FacebookAuthenticatedPanel.LoggedInContent>    
    <facebook:FacebookAuthenticatedPanel.LoggedOutContent>
                    
    </facebook:FacebookAuthenticatedPanel.LoggedOutContent>
    </facebook:FacebookAuthenticatedPanel>
</Grid>
```

11.Add a TextBlock to the LoggedOutContent section that prompts the user to log in:
```
<facebook:FacebookAuthenticatedPanel.LoggedOutContent>
    <TextBlock Text="Please log in to Facebook..." />
</facebook:FacebookAuthenticatedPanel.LoggedOutContent>
```

12.Add a Button with the text "Share" and a Click handler to the LoggedInContent section:
```
<facebook:FacebookAuthenticatedPanel.LoggedInContent>
    <Button Content="Share" Click="Button_Click" />
</facebook:FacebookAuthenticatedPanel.LoggedInContent>
```

13.Right-click on the share button Click property and select Navigate to Event Handler to navigate to MainPage.xaml.cs.

[[images/phone7.png|height=150px]]

14.In MainPage.xaml.cs, add the following using statement:
```
using Facebook.Phone.Dialogs;
```

15.In the MainPage constructor, set the App ID value:
```
public MainPage()
{
    InitializeComponent();
    FacebookDialogs.AppId = "314164518596456";
}
```

16.In the Button click handler, show the Feed dialog with some parameters:
```
private void Button_Click(object sender, RoutedEventArgs e)
{
    FacebookDialogs.ShowFeed(
        new Dictionary<string, object>()
        {
            {"to", "userNameOrID"},
            {"link", "http://www.facebook.com"}
        });
}
```

17.Build and run the application in the phone emulator by pressing F5. You should now be able to log in, authorize the application to have access to your email, and publish something to a user's feed.

[[images/phone8.png|height=300px]]

## Notes

To learn more about the Facebook Controls please see http://github.com/microsoft-dpe/wp-toolkit-facebook/wiki/Facebook-Controls-for-Windows-Phone-Overview

{% include phone-see-also.md %}