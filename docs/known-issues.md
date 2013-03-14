---
layout: default
title: Known Issues
---

This page contains known issues that you should be aware of when working with the Facebook SDK for .NET or general Facebook development on with the various Microsoft platforms and frameworks.

## Windows Phone

### Task Parallel Library is not supported in Windows Phone
You cannot use TPL on Windows Phone and as such the Facebook SDK for .NET does not contain TPL dependant methods in the Windows Phone build.

### System.IO.Compression in WP7
Windows Phone 7.1 Mango supports changing the Accept headers, but doesn't include System.IO.Compression (GZipStream). This means you can enable compression, but are required to use 3rd party library for decompressing/compressing gzip streams. You can use a third party compression library like "SharpCompress" as described in this blog post: 
http://blogs.msdn.com/b/astoriateam/archive/2011/10/04/odata-compression-in-windows-phone-7-5-mango.aspx

### Windows Phone does not support dynamic
You cannot use dynamic objects in Windows Phone. As such, you must use ```IDictionary<string, object>``` for argument and return types in the Facebook SDK for .NET.

### The Facebook Mobile Website (m.facebook.com) forces the WAP version on Windows Phone.
Regardless of whether you set display=touch or display=wap, Facebook will always render the display=wap version of the website. You cannot display the HTML5 touch version of the Facebook authentication or other dialogs when developing a Windows Phone Facebook app.

### All Dialogs except Authorization result in an error message
When attempting to display dialogs on Windows Phone the following error message is displayed:

<pre>
API Error Code: 3
API Error Description: Unknown method.
Error Message: This mesage isn't support on this display type.
</pre>

This error occurs when using display=wap or display=touch. There is currently no known work around for this issue. 

Facebook Bug: [291633774212504](https://developers.facebook.com/bugs/291633774212504)

## Windows 8 Metro Style Apps

### HttpWebRequest.AutomaticDecompression in WinRT
The HttpWebRequest object in Metro style apps does not contain AutomaticDecompression property.

### System.Security.Cryptography.HMACSHA256 in WinRT
Does not exist. Required to decode Facebook signed request.

## WPF
There are no known issues at this time.

## Silverlight
There are no known issues at this time.

## Internet Explorer
There are no known issues at this time.

## Windows Azure
There are no known issues at this time.