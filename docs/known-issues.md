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

## WinRT (Windows Store)

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
