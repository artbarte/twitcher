@tool
extends RefCounted

class_name TwitchUpdateChannelStreamScheduleSegmentResponse

## The broadcaster’s streaming scheduled.
var data: Data;

static func from_json(d: Dictionary) -> TwitchUpdateChannelStreamScheduleSegmentResponse:
	var result = TwitchUpdateChannelStreamScheduleSegmentResponse.new();
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

## The broadcaster’s streaming scheduled.
class Data extends RefCounted:
	## A list that contains the single broadcast segment that you updated.
	var segments: Array[TwitchChannelStreamScheduleSegment];
	## The ID of the broadcaster that owns the broadcast schedule.
	var broadcaster_id: String;
	## The broadcaster’s display name.
	var broadcaster_name: String;
	## The broadcaster’s login name.
	var broadcaster_login: String;
	## The dates when the broadcaster is on vacation and not streaming. Is set to **null** if vacation mode is not enabled.
	var vacation: Dictionary;

	static func from_json(d: Dictionary) -> Data:
		var result = Data.new();
		result.segments = d["segments"];
		result.broadcaster_id = d["broadcaster_id"];
		result.broadcaster_name = d["broadcaster_name"];
		result.broadcaster_login = d["broadcaster_login"];
		result.vacation = d["vacation"];
		return result;

	func to_json() -> String:
		return JSON.stringify(to_dict());

	func to_dict() -> Dictionary:
		var d: Dictionary = {};
		d["segments"] = segments;
		d["broadcaster_id"] = broadcaster_id;
		d["broadcaster_name"] = broadcaster_name;
		d["broadcaster_login"] = broadcaster_login;
		d["vacation"] = vacation;
		return d;

