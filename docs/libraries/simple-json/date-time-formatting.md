---
layout: default
title: Date and Time Formatting
---

Serializing/Deserializing Date and Time to specific format for Strongly Typed Objects

Since SimpleJson is a strict JSON parser, it does not support serializing/deserializing DateTime to specific formats. (This is due to the fact that JSON specification's does not include DateTime support.)

This limitation can be overcome by using DataContract classes.

Let us assume we have the following JSON string.

```json
{"message":"hello world","created_time":"2011-04-27T12:55:38+0000"} }}
```

We first need to create the strongly typed wrapper for the above json object.

```csharp
[DataContract]
public class Post
{
    [DataMember(Name = "message")]
    public string Message { get; set; }

    [DataMember(Name = "created_time")]
    private string ActualCreatedTime { get; set; }

    public DateTime CreatedTime
    {
        get { return DateTime.ParseExact(ActualCreatedTime, @"yyyy-MM-dd\Thh:mm:ssK", CultureInfo.InvariantCulture, DateTimeStyles.AssumeUniversal | DateTimeStyles.AdjustToUniversal); }
        set { ActualCreatedTime = value.ToUniversalTime().ToString(@"yyyy-MM-dd\Thh:mm:ssK", CultureInfo.InvariantCulture); }
    }
}
```

You can then deserialize and serialize the object in the following way.

```csharp
var deserializedObject = SimpleJson.DeserializeObject<Post>(json);
Console.WriteLine(deserializedObject.Message);
Console.WriteLine(deserializedObject.CreatedTime);
Console.WriteLine();
var serializedObject = SimpleJson.SerializeObject(deserializedObject);
Console.WriteLine(serializedObject);
```

The above code assumes that current serializer is *DataContractJsonSerializerStrategy*.

You can change the current serializer to DataContractJsonSerializerStrategy by:

```csharp
SimpleJson.CurrentJsonSerializerStrategy = SimpleJson.DataContractJsonSerializerStrategy;
```