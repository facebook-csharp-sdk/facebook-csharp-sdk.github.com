---
layout: default
title: Invoking the Facebook Dialgs using the SDK
---

##Introduction

Facebook helps developers get viral adoption by allowing people to invite their friends to  use a certain app, or to even send lives or other game content using Web UI. The Web UI is known as Facebook Dialogs. The SDK supports two dialogs:

1. AppRequests dialog: Invite friends to an application.

2. Feed dialog: Allow users to publish individual stories to their timeline


## Prerequisities
Before a user can use any feature with the SDK, they must login to Facebook using the SDK. This can be done by following the [LoginButton tutorial](/docs/windows/controls/login-ui-control)  or [Login API tutorial](/docs/windows/login)

## AppRequests dialog - within the app

The request dialog can be invoked with the following API:

    Session.ShowAppRequestsDialog(<callback>, <message>, <list of friends>);

The callback can be supplied as a non-null value and will be called after the user finishes with the dialog or cancels it. The signature of the callback is:

    public delegate void WebDialogFinishedDelegate(WebDialogResult result);

Where the WebDialogResult is an enum of the following form:

    public enum WebDialogResult
    {
        WebDialogResultDialogCompleted,
        WebDialogResultDialogNotCompleted
    };

## AppRequests dialog - out of the app, via browser

The request dialog can be invoked with the following API:

    Session.ShowAppRequestDialogViaBrowser();

## Feed Dialog

The request dialog can be invoked with the following API:

    Session.ShowFeedDialog();

> Note: To see a sample of the dialog usage, Look at the [Samples Folder](https://github.com/facebook-csharp-sdk/facebook-winclient-sdk/tree/master/Samples) of the SDK.