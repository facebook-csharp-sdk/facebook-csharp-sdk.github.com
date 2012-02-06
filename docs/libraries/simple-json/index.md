---
layout: default
title: Getting Started with SimpleJson
---

# Getting Started with SimpleJson

## Serialize a JSON object

```csharp
JsonObject jsonObject = new JsonObject();
jsonObject["name"] = "foo";
jsonObject["num"] = 10;
jsonObject["is_vip"] = true;
jsonObject["nickname"] = null;

string jsonString = jsonObject.ToString();
```

Result is: 

```json
{"name":"foo","num":10,"is_vip":true,"nickname":null}
```

## Serialize a JSON object - Using IDictionary<string,object>

```csharp
IDictionary<string, object> jsonObject = new Dictionary<string, object>();
jsonObject["name"] = "foo";
jsonObject["num"] = 10;
jsonObject["is_vip"] = true;
jsonObject["nickname"] = null;

string jsonString = SimpleJson.SerializeObject(jsonObject);
```

Result is: 

```json
{"name":"foo","num":10,"is_vip":true,"nickname":null}
```

## Serialize a JSON object - Using anonymous object

```csharp
object jsonObject = new { name = "foo", num = 10, is_vip = true, nickname = (object)null };

string jsonString = SimpleJson.SerializeObject(jsonObject);
```

Result is:
 
```json
{"name":"foo","num":10,"is_vip":true,"nickname":null}
```

## Serialize a JSON array

```csharp
JsonArray jsonArray = new JsonArray();
jsonArray.Add("foo");
jsonArray.Add(10);
jsonArray.Add(true);
jsonArray.Add(null);

string json = jsonArray.ToString();
```

Result is: 

```json
["foo",10,true,null]
```

## Serialize a JSON array - Using IList<object>

```csharp
IList<object> jsonArray = new List<object>();
jsonArray.Add("foo");
jsonArray.Add(10);
jsonArray.Add(true);
jsonArray.Add(null);

string json = SimpleJson.SerializeObject(jsonArray);
```

Result is: 

```json
["foo",10,true,null]
```

## Serialize a JSON array - Using array initializers

```csharp
var jsonArray = new object[] { "foo", 10, true, null };

string json = SimpleJson.SerializeObject(jsonArray);
```

Result is: 

```json
["foo",10,true,null]
```


## Serialize combination of JSON primitives, JSON object and JSON array

```csharp
JsonArray list1 = new JsonArray();
list1.Add("foo");
list1.Add(10);

JsonArray list2 = new JsonArray();
list2.Add(true);
list2.Add(null);

JsonObject obj = new JsonObject();
obj["name"] = "foo";
obj["num"] = 10;
obj["list1"] = list1;
obj["list2"] = list2;

string json = obj.ToString();
```

Result is: 

```
"{"name":"foo","num":10,"list1":["foo",10],"list2":[true,null]}"
```

## Serialize combination of JSON primitives, IDictionary<string,object> and IList<object>

```csharp
var list1 = new List<object>();
list1.Add("foo");
list1.Add(10);

var list2 = new List<object>();
list2.Add(true);
list2.Add(null);

var obj = new Dictionary<string, object>();
obj["name"] = "foo";
obj["num"] = 10;
obj["list1"] = list1;
obj["list2"] = list2;

string json = SimpleJson.SerializeObject(obj);
```

Result is:

```
"{"name":"foo","num":10,"list1":["foo",10],"list2":[true,null]}"
```