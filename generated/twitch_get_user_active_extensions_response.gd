@tool
extends RefCounted

class_name TwitchGetUserActiveExtensionsResponse

## The active extensions that the broadcaster has installed.
var data: Data;

static func from_json(d: Dictionary) -> TwitchGetUserActiveExtensionsResponse:
	var result = TwitchGetUserActiveExtensionsResponse.new();
	if d.has("data") && d["data"] != null:
		result.data = Data.from_json(d["data"]);
	return result;

func to_dict() -> Dictionary:
	var d: Dictionary = {};
	if data != null:
		d["data"] = data.to_dict();
	return d;

func to_json() -> String:
	return JSON.stringify(to_dict());

## The active extensions that the broadcaster has installed.
class Data extends RefCounted:
	## A dictionary that contains the data for a panel extension. The dictionary’s key is a sequential number beginning with 1\. The following fields contain the panel’s data for each key.
	var panel: Dictionary;
	## A dictionary that contains the data for a video-overlay extension. The dictionary’s key is a sequential number beginning with 1\. The following fields contain the overlay’s data for each key.
	var overlay: Dictionary;
	## A dictionary that contains the data for a video-component extension. The dictionary’s key is a sequential number beginning with 1\. The following fields contain the component’s data for each key.
	var component: Dictionary;

	static func from_json(d: Dictionary) -> Data:
		var result = Data.new();
		result.panel = d["panel"];
		result.overlay = d["overlay"];
		result.component = d["component"];
		return result;

	func to_json() -> String:
		return JSON.stringify(to_dict());

	func to_dict() -> Dictionary:
		var d: Dictionary = {};
		d["panel"] = panel;
		d["overlay"] = overlay;
		d["component"] = component;
		return d;

