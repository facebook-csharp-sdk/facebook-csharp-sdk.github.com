---
layout: default
title: Publishing a Release
---

This document outlines the process for creating and publishing a new release of the Facebook C# SDK. These steps are only needed for administrators of this project. If you are looking to build your own version of the Facebook C# SDK you should read the document titled [Building Facebook C# SDK from Source](/docs/build).

# Steps to Publish a Release

1. Set the version number in VERSION. Only change the second version number unless this is a major release.
1. git clean 
1. git clean -xdf
1. jake
1. jake nuget:push:symbolsource[apikey]
1. jake nuget:push:nuget[apikey]
1. git tag vX.X.X
1. git push --tags
