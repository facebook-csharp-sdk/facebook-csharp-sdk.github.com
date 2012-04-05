---
layout: default
title: DateTimeConverter Class Reference
---

The ```DateTimeConverter``` class contains some useful helper methods to interact with Facebook's date and time format. Below you will find several common uses of this object.

> Always make sure that the .NET DateTime is in UTC format before conversion.

### Get the Epoch Date and Time

	DateTime epoch = DateTimeConverter.Epoch;

### Convert from Unix time to .NET DateTime

	//From double to .NET UTC DateTime:
	DateTime result = DateTimeConvertor.FromUnixTime(1327774473);

	//From string to .NET UTC DateTime:
	DateTime result = DateTimeConvertor.FromUnixTime("1327774473");

### Convert from .NET UTC DateTime to Unix time

	// From UTC DateTime
	DateTime dateTime = new DateTime(2012, 1, 28, 18, 14, 33, DateTimeKind.Utc);
	double unixTime = DateTimeConvertor.ToUnixTime(dateTime);

### Convert from .NET DateTimeOffset to Unix time

	// From DateTimeOffset
	DateTime dateTime = new DateTime(2012, 04, 05, 06, 33, 57);
	int pdtOffset = -25200; // pacific daylight time offset in seconds
	double unixTime = DateTimeConvertor.ToUnixTime(new DateTimeOffset(dateTime, TimeSpan.FromSeconds(pdtOffset)));

### Convert .NET UTC DateTime to ISO8601 Formatted Date and Time String

	DateTime dateTime = new DateTime(2012, 1, 28, 18, 14, 33, DateTimeKind.Utc);
	string iso8601FormattedDateTime = DateTimeConvertor.ToIso8601FormattedDateTime(dateTime);
	// iso8601FormattedDateTime = "2012-01-28T18:14:33Z"

### Convert from ISO8601 Date and Time from String to .NET UTC DateTime

	DateTime dateTime = DateTimeConvertor.FromIso8601FormattedDateTime("2012-01-28T18:14:33Z");