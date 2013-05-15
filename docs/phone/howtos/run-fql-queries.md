---
layout: default
title: Run FQL Queries
---

FQL, the [Facebook Query Language](https://developers.facebook.com/docs/reference/fql/), allows you to use a SQL-style interface to query data exposed by the Graph API. It provides advanced features not available in the Graph API, including batching multiple queries into a single call.

You can use FQL with the Graph API by adding an additional parameter to the HTTP request:

	GET /fql?q=<QUERY>

In the Facebook SDK for .NET, you can use the [FacebookClient](/docs/reference/SDK/Facebook.FacebookClient.html) class to make the FQL call with the Graph API. You can instantiate the client and then invoke the [GetTaskAsync(string path, object parameters)][1] method, passing _fql_ as the path parameter and set a parameter named _q_ that has your query as its value.

[1]: http://localhost:4000/docs/reference/SDK/Facebook.FacebookClient.html#GetTaskAsync(string,object)

This document covers the following topics:

* [Prerequisites](#1)
* [Sample Overview](#2)
* [Step 1: Set Up The User Interface](#3)
* [Step 2: Add FQL to Fetch Friend Info](#4)
* [Troubleshooting](#5)

---

## Prerequisites

Before you begin, make sure you already set up [Facebook Login](#). This ensures you have the prerequisites and your app is ready for additional Facebook integration.

---

## Sample Overview

The completed sample allows users to log in with Facebook and run a query to output a limited set of friends.

The implementation builds on top of [Facebook Login](#) with two buttons that make FQL calls to fetch essentially the same information. One button runs a query that includes a sub query. The second button splits the call up into a multi-query. This shows how you can take data from one query and use it in the second. The completed app allows you to retrieve similar information from the query and multi-query call:

->![FQL Sample](/docs/phone/howtos/images/fql-howto-sample.png)<-

---

## Step 1: Set Up the User Interface

In this step, you'll add two buttons to the main page. One button runs a query and the second runs a multi-query. Both queries get friend data and output the friend list.

First, open the Main.xaml file and add two button controls to the main page just below the login button:

	<Button 
		x:Name="queryButton"
		Height="80"
		VerticalAlignment="Top"
		Margin="0,80,0,0"
		Content="Query"
		Visibility="Collapsed" />

	<Button
		x:Name="multiQueryButton"
		Height="80"
		VerticalAlignment="Top"
		Margin="0,180,0,0"
		Content="Multi-query"
		Visibility="Collapsed" />

The buttons will be set to hidden initially.

If you followed the [Facebook Login](#) doc, you should have a _OnSessionStateChange()_ event handler in your Main.xaml.cs class file that is invoked whenever the user session state changes. Modify this method to show the buttons only when the user is authenticated:

	private void OnSessionStateChanged(object sender, Facebook.Client.Controls.SessionStateChangedEventArgs e)
	{
		if (e.SessionState == Facebook.Client.Controls.FacebookSessionState.Opened)
		{
			this.queryButton.Visibility = System.Windows.Visibility.Visible;
			this.multiQueryButton.Visibility = System.Windows.Visibility.Visible;
		}
		else if (e.SessionState == Facebook.Client.Controls.FacebookSessionState.Closed)
		{
			this.queryButton.Visibility = System.Windows.Visibility.Collapsed;
			this.multiQueryButton.Visibility = System.Windows.Visibility.Collapsed;
		}
	}

---

## Step 2: Add FQL to Fetch Friend Info

In this step, you'll link up the buttons you set up to make the query calls. When you've completed this step you'll know how to make FQL API calls using query and multi-query. In this step, the data you retrieve will simply log to the Visual Studio output console.

The query you're using gets the user's friends, limits results to 25, and returns the id, name and profile picture info:

	SELECT uid, name, pic_square FROM user WHERE uid IN 
	(SELECT uid2 FROM friend WHERE uid1 = me() LIMIT 25)

### Step 2a: Query

Implement the query button's _click_ event handler to instantiate the _FacebookClient_ object and make the query FQL call. In the Main.xaml page, set the _Click_ attribute of the "Query" button as shown below:

    <Button 
        x:Name="queryButton"
		...
        Click="OnQueryButtonClick" />

Add the following code in the Main.xaml.cs to implement the _OnQueryButtonClick_ event handler:

    private async void OnQueryButtonClick(object sender, RoutedEventArgs e)
    {
        var fb = new Facebook.FacebookClient(this.loginButton.AccessToken);
        var result = await fb.GetTaskAsync("fql",
            new
            { 
                q = "SELECT uid, name, pic_square FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me() LIMIT 25)" 
            });

        System.Diagnostics.Debug.WriteLine("Result: " + result.ToString());
    }

Build and run the project to make sure it runs without errors. Tap the "Log In" button to log in with Facebook. Once you're authenticated, you should see the "Query" and "Multi-query" buttons. Tap "Query" and view the results in the Visual Studio console. Your log output should look similar to this:

	{
		"data":[
			{
				"uid":100005652937870,
				"name":"Christen Anderson",
				"pic_square":"http://profile.ak.fbcdn.net/static-ak/rsrc.php/v2/y9/r/IB7NOFmPw2a.gif"
			},
			{
				"uid":100005695327652,
				"name":"Ryan Ihrig",
				"pic_square":"http://profile.ak.fbcdn.net/static-ak/rsrc.php/v2/yo/r/UlIqmHJn-SK.gif"
			}
		]
	}

### Step 2b: Multi-query

Implement the multi-query button's _click_ event handler to instantiate the _FacebookClient_ object and make the multi-query FQL call. In the Main.xaml page, set the _Click_ attribute of the "Multi-query" button as shown below:

	<Button 
		x:Name="multiQueryButton"
		...
		Click="OnMultiQueryButtonClick" />

Add the following code in the Main.xaml.cs to implement the _OnMultyQueryButtonClick_ event handler:

    private async void OnMultiQueryButtonClick(object sender, RoutedEventArgs e)
    {
        var fb = new Facebook.FacebookClient(this.loginButton.AccessToken);
        var result = await fb.GetTaskAsync("fql",
            new
            {
                q = new
                {
                    friends = "SELECT uid2 FROM friend WHERE uid1 = me() LIMIT 25",
                    friendinfo = "SELECT uid, name, pic_square FROM user WHERE uid IN (SELECT uid2 FROM #friends)"
                }
            });

        System.Diagnostics.Debug.WriteLine("Result: " + result.ToString());
    }

Build and run the project to make sure it runs without errors. Once you're authenticated, tap ''Multi-query'' and view the results in the console. Notice that there are two sets of results: one for the user's friends and one for friend details. Your log output should look similar to this:

	{
		"data":[
			{
				"name":"friends",
				"fql_result_set":[
					{
						"uid2":"100005652937870"
					},
					{
						"uid2":"100005695327652"
					}
				]
			},
			{
				"name":"friendinfo",
				"fql_result_set":[
					{
						"uid":100005652937870,
						"name":"Christen Anderson",
						"pic_square":"http://profile.ak.fbcdn.net/static-ak/rsrc.php/v2/y9/r/IB7NOFmPw2a.gif"
					},
					{
						"uid":100005695327652,
						"name":"Ryan Ihrig",
						"pic_square":"http://profile.ak.fbcdn.net/static-ak/rsrc.php/v2/yo/r/UlIqmHJn-SK.gif"
					}
				]
			}
		]
	}

---

## Troubleshooting

The [Graph API Explorer](https://developers.facebook.com/tools/explorer) has an FQL tab that you can use to debug your FQL queries.

->![Graph API Explorer](/docs/phone/howtos/images/graph-api-explorer.png)<-

This will help you to troubleshoot any issues with your queries.