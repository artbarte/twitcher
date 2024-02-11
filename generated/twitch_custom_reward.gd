@tool
extends RefCounted

class_name TwitchCustomReward

## The ID that uniquely identifies the broadcaster.
var broadcaster_id: String;
## The broadcaster’s login name.
var broadcaster_login: String;
## The broadcaster’s display name.
var broadcaster_name: String;
## The ID that uniquely identifies this custom reward.
var id: String;
## The title of the reward.
var title: String;
## The prompt shown to the viewer when they redeem the reward if user input is required. See the `is_user_input_required` field.
var prompt: String;
## The cost of the reward in Channel Points.
var cost: int;
## A set of custom images for the reward. This field is **null** if the broadcaster didn’t upload images.
var image: Image;
## A set of default images for the reward.
var default_image: DefaultImage;
## The background color to use for the reward. The color is in Hex format (for example, #00E5CB).
var background_color: String;
## A Boolean value that determines whether the reward is enabled. Is **true** if enabled; otherwise, **false**. Disabled rewards aren’t shown to the user.
var is_enabled: bool;
## A Boolean value that determines whether the user must enter information when they redeem the reward. Is **true** if the user is prompted.
var is_user_input_required: bool;
## The settings used to determine whether to apply a maximum to the number of redemptions allowed per live stream.
var max_per_stream_setting: MaxPerStreamSetting;
## The settings used to determine whether to apply a maximum to the number of redemptions allowed per user per live stream.
var max_per_user_per_stream_setting: MaxPerUserPerStreamSetting;
## The settings used to determine whether to apply a cooldown period between redemptions and the length of the cooldown.
var global_cooldown_setting: GlobalCooldownSetting;
## A Boolean value that determines whether the reward is currently paused. Is **true** if the reward is paused. Viewers can’t redeem paused rewards.
var is_paused: bool;
## A Boolean value that determines whether the reward is currently in stock. Is **true** if the reward is in stock. Viewers can’t redeem out of stock rewards.
var is_in_stock: bool;
## A Boolean value that determines whether redemptions should be set to FULFILLED status immediately when a reward is redeemed. If **false**, status is set to UNFULFILLED and follows the normal request queue process.
var should_redemptions_skip_request_queue: bool;
## The number of redemptions redeemed during the current live stream. The number counts against the `max_per_stream_setting` limit. This field is **null** if the broadcaster’s stream isn’t live or _max\_per\_stream\_setting_ isn’t enabled.
var redemptions_redeemed_current_stream: int;
## The timestamp of when the cooldown period expires. Is **null** if the reward isn’t in a cooldown state. See the `global_cooldown_setting` field.
var cooldown_expires_at: Variant;

static func from_json(d: Dictionary) -> TwitchCustomReward:
	var result = TwitchCustomReward.new();
	if d.has("broadcaster_id") && d["broadcaster_id"] != null:
		result.broadcaster_id = d["broadcaster_id"];
	if d.has("broadcaster_login") && d["broadcaster_login"] != null:
		result.broadcaster_login = d["broadcaster_login"];
	if d.has("broadcaster_name") && d["broadcaster_name"] != null:
		result.broadcaster_name = d["broadcaster_name"];
	if d.has("id") && d["id"] != null:
		result.id = d["id"];
	if d.has("title") && d["title"] != null:
		result.title = d["title"];
	if d.has("prompt") && d["prompt"] != null:
		result.prompt = d["prompt"];
	if d.has("cost") && d["cost"] != null:
		result.cost = d["cost"];
	if d.has("image") && d["image"] != null:
		result.image = Image.from_json(d["image"]);
	if d.has("default_image") && d["default_image"] != null:
		result.default_image = DefaultImage.from_json(d["default_image"]);
	if d.has("background_color") && d["background_color"] != null:
		result.background_color = d["background_color"];
	if d.has("is_enabled") && d["is_enabled"] != null:
		result.is_enabled = d["is_enabled"];
	if d.has("is_user_input_required") && d["is_user_input_required"] != null:
		result.is_user_input_required = d["is_user_input_required"];
	if d.has("max_per_stream_setting") && d["max_per_stream_setting"] != null:
		result.max_per_stream_setting = MaxPerStreamSetting.from_json(d["max_per_stream_setting"]);
	if d.has("max_per_user_per_stream_setting") && d["max_per_user_per_stream_setting"] != null:
		result.max_per_user_per_stream_setting = MaxPerUserPerStreamSetting.from_json(d["max_per_user_per_stream_setting"]);
	if d.has("global_cooldown_setting") && d["global_cooldown_setting"] != null:
		result.global_cooldown_setting = GlobalCooldownSetting.from_json(d["global_cooldown_setting"]);
	if d.has("is_paused") && d["is_paused"] != null:
		result.is_paused = d["is_paused"];
	if d.has("is_in_stock") && d["is_in_stock"] != null:
		result.is_in_stock = d["is_in_stock"];
	if d.has("should_redemptions_skip_request_queue") && d["should_redemptions_skip_request_queue"] != null:
		result.should_redemptions_skip_request_queue = d["should_redemptions_skip_request_queue"];
	if d.has("redemptions_redeemed_current_stream") && d["redemptions_redeemed_current_stream"] != null:
		result.redemptions_redeemed_current_stream = d["redemptions_redeemed_current_stream"];
	if d.has("cooldown_expires_at") && d["cooldown_expires_at"] != null:
		result.cooldown_expires_at = d["cooldown_expires_at"];
	return result;

func to_dict() -> Dictionary:
	var d: Dictionary = {};
	d["broadcaster_id"] = broadcaster_id;
	d["broadcaster_login"] = broadcaster_login;
	d["broadcaster_name"] = broadcaster_name;
	d["id"] = id;
	d["title"] = title;
	d["prompt"] = prompt;
	d["cost"] = cost;
	if image != null:
		d["image"] = image.to_dict();
	if default_image != null:
		d["default_image"] = default_image.to_dict();
	d["background_color"] = background_color;
	d["is_enabled"] = is_enabled;
	d["is_user_input_required"] = is_user_input_required;
	if max_per_stream_setting != null:
		d["max_per_stream_setting"] = max_per_stream_setting.to_dict();
	if max_per_user_per_stream_setting != null:
		d["max_per_user_per_stream_setting"] = max_per_user_per_stream_setting.to_dict();
	if global_cooldown_setting != null:
		d["global_cooldown_setting"] = global_cooldown_setting.to_dict();
	d["is_paused"] = is_paused;
	d["is_in_stock"] = is_in_stock;
	d["should_redemptions_skip_request_queue"] = should_redemptions_skip_request_queue;
	d["redemptions_redeemed_current_stream"] = redemptions_redeemed_current_stream;
	d["cooldown_expires_at"] = cooldown_expires_at;
	return d;

func to_json() -> String:
	return JSON.stringify(to_dict());

## A set of custom images for the reward. This field is **null** if the broadcaster didn’t upload images.
class Image extends RefCounted:
	## The URL to a small version of the image.
	var url_1x: String;
	## The URL to a medium version of the image.
	var url_2x: String;
	## The URL to a large version of the image.
	var url_4x: String;

	static func from_json(d: Dictionary) -> Image:
		var result = Image.new();
		result.url_1x = d["url_1x"];
		result.url_2x = d["url_2x"];
		result.url_4x = d["url_4x"];
		return result;

	func to_json() -> String:
		return JSON.stringify(to_dict());

	func to_dict() -> Dictionary:
		var d: Dictionary = {};
		d["url_1x"] = url_1x;
		d["url_2x"] = url_2x;
		d["url_4x"] = url_4x;
		return d;

## A set of default images for the reward.
class DefaultImage extends RefCounted:
	## The URL to a small version of the image.
	var url_1x: String;
	## The URL to a medium version of the image.
	var url_2x: String;
	## The URL to a large version of the image.
	var url_4x: String;

	static func from_json(d: Dictionary) -> DefaultImage:
		var result = DefaultImage.new();
		result.url_1x = d["url_1x"];
		result.url_2x = d["url_2x"];
		result.url_4x = d["url_4x"];
		return result;

	func to_json() -> String:
		return JSON.stringify(to_dict());

	func to_dict() -> Dictionary:
		var d: Dictionary = {};
		d["url_1x"] = url_1x;
		d["url_2x"] = url_2x;
		d["url_4x"] = url_4x;
		return d;

## The settings used to determine whether to apply a maximum to the number of redemptions allowed per live stream.
class MaxPerStreamSetting extends RefCounted:
	## A Boolean value that determines whether the reward applies a limit on the number of redemptions allowed per live stream. Is **true** if the reward applies a limit.
	var is_enabled: bool;
	## The maximum number of redemptions allowed per live stream.
	var max_per_stream: int;

	static func from_json(d: Dictionary) -> MaxPerStreamSetting:
		var result = MaxPerStreamSetting.new();
		result.is_enabled = d["is_enabled"];
		result.max_per_stream = d["max_per_stream"];
		return result;

	func to_json() -> String:
		return JSON.stringify(to_dict());

	func to_dict() -> Dictionary:
		var d: Dictionary = {};
		d["is_enabled"] = is_enabled;
		d["max_per_stream"] = max_per_stream;
		return d;

## The settings used to determine whether to apply a maximum to the number of redemptions allowed per user per live stream.
class MaxPerUserPerStreamSetting extends RefCounted:
	## A Boolean value that determines whether the reward applies a limit on the number of redemptions allowed per user per live stream. Is **true** if the reward applies a limit.
	var is_enabled: bool;
	## The maximum number of redemptions allowed per user per live stream.
	var max_per_user_per_stream: int;

	static func from_json(d: Dictionary) -> MaxPerUserPerStreamSetting:
		var result = MaxPerUserPerStreamSetting.new();
		result.is_enabled = d["is_enabled"];
		result.max_per_user_per_stream = d["max_per_user_per_stream"];
		return result;

	func to_json() -> String:
		return JSON.stringify(to_dict());

	func to_dict() -> Dictionary:
		var d: Dictionary = {};
		d["is_enabled"] = is_enabled;
		d["max_per_user_per_stream"] = max_per_user_per_stream;
		return d;

## The settings used to determine whether to apply a cooldown period between redemptions and the length of the cooldown.
class GlobalCooldownSetting extends RefCounted:
	## A Boolean value that determines whether to apply a cooldown period. Is **true** if a cooldown period is enabled.
	var is_enabled: bool;
	## The cooldown period, in seconds.
	var global_cooldown_seconds: int;

	static func from_json(d: Dictionary) -> GlobalCooldownSetting:
		var result = GlobalCooldownSetting.new();
		result.is_enabled = d["is_enabled"];
		result.global_cooldown_seconds = d["global_cooldown_seconds"];
		return result;

	func to_json() -> String:
		return JSON.stringify(to_dict());

	func to_dict() -> Dictionary:
		var d: Dictionary = {};
		d["is_enabled"] = is_enabled;
		d["global_cooldown_seconds"] = global_cooldown_seconds;
		return d;

