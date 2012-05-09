---
layout: default
title: Making Asynchronous Requests with the Facebook C# SDK
---

**For synchronous requests refer to [Making Synchronous Requests](Making-Synchronous-Requests).**

> **Use this only if you are using .NET 3.5, Silverlight 4 or Windows Phone 7 where Task Parallel Library (TPL)
in not supported**. It is always recommended to use the TPL alternatives (XTaskAsync) where possible. Refer to
[Making Asynchronous Requests with Task Parallel Library](Making-Asynchronous-Requests-with-Task-Parallel-Library) or
[Making Asynchronous Requests with async await](Making Asynchronous Requests with async await) for more details.

> For simplicity, handling exceptions are ignored in the following samples (Always handle exceptions in production).

