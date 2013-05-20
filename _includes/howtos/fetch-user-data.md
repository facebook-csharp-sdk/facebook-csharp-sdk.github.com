The Facebook SDK for .NET includes methods to access the [Graph API User](https://developers.facebook.com/docs/reference/api/user/) object. It also supports strongly-typed access to common _User_ properties.

The _Request_ class method _executeMeRequestAsync()_ can be used to initiate a Graph API call for user data. This is essentially a call to the _/me_ Graph API endpoint. The permissions in the _access_token_ that are sent with the API call control the returned data (ex: if no access token is provided, only public info will be returned). See the [User doc](https://developers.facebook.com/docs/reference/api/user/) for more details on _User_ properties and permissions.

The _executeMeRequestAsync()_ method takes in a _Request.GraphUserCallback_ callback parameter. The callback's _onCompleted()_ method is called when the request completes. If the API call is successful, a _GraphUser_ object is passed in to the _onCompleted()_ method that provides typed access to the following _User_ fields: _id, name, first_name, middle_name, ast_name, link, username, birthday and location_. You have access to other user properties with the _getProperty()_ method on the result data. You can also extend the _GraphUser_ interface to get typed access to user properties that are not part of the default list.

This doc outlines how to use the SDK to request user data and retrieve user details for fields available via typed access and non-typed access. You'll also learn how to extend the _GraphUser_ interface and how to use the _GraphObjectList_ interface to help fetch graph objects that are returned in an array.

This document walks through the following:

* [Prerequisites](#1)
* [Sample Overview](#2)
* [Step 1: Set Up the UI](#3)
* [Step 2: Ask for Permissions](#4)
* [Step 3: Fetch User Data](#5)
* [Troubleshooting](#6)
* [Additional Info](#7)


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


---


## Step 1: Set Up the UI

---

## Step 2: Ask for Permissions

---

## Step 3: Fetch User Data

---

## Troubleshooting

---

## Additional Info

