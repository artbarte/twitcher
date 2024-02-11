extends RefCounted

## Will load badges, icons and profile images
class_name TwitchIconLoader

## Will be sent when the emotes and badges got preloaded
signal preload_done;

const ALLOW_EMPTY = true;
const MAX_SPLITS = 1;

var api: TwitchRestAPI;

## Badge definition for global and the channel.
var cached_badges : Dictionary = {};
## Emote definition for global and the channel.
var cached_emotes : Dictionary = {};

## All cached emotes with emote_id as key and spriteframes as value.
## Is needed that the garbage collector isn't deleting our cache.
var _cached_images : Array[SpriteFrames] = [];

func _init(twitch_api : TwitchRestAPI) -> void:
	api = twitch_api;

func do_preload():
	var broadcaster_id = TwitchSetting.broadcaster_id;
	await preload_emotes();
	await preload_emotes(broadcaster_id);
	await preload_badges();
	await preload_badges(broadcaster_id);
	preload_done.emit();

	_fireup_cache();

## Loading all images from the directory into the memory cache
func _fireup_cache() -> void:
	_cache_directory(TwitchSetting.cache_emote);
	_cache_directory(TwitchSetting.cache_badge);

func _cache_directory(path: String):
	var files = DirAccess.get_files_at(path);
	for file in files:
		if file.ends_with(".res"):
			var res_path = path.path_join(file);
			var sprite_frames: SpriteFrames = ResourceLoader.load(res_path, "SpriteFrames");
			sprite_frames.take_over_path(res_path.trim_suffix(".res"))
			_cached_images.append(sprite_frames);

#region Emotes

func preload_emotes(channel_id: String = "global") -> void:
	if (!cached_emotes.has(channel_id)):
		var response;
		if channel_id == "global":
			response = await api.get_global_emotes();
		else:
			response = await api.get_channel_emotes(channel_id);
		cached_emotes[channel_id] = _map_emotes(response);

func get_emotes(emote_ids : Array[String]) -> Dictionary:
	var response: Dictionary = {};
	var requests: Dictionary = {};

	for emote_id in emote_ids:
		var emote_path: String = TwitchSetting.cache_emote.path_join(emote_id);
		if ResourceLoader.has_cached(emote_path):
			response[emote_id] = ResourceLoader.load(emote_path);
		else:
			var request : BufferedHTTPClient.RequestData = _load_emote(emote_id);
			requests[emote_id] = request;

	for emote_id in requests:
		var emote_path: String = TwitchSetting.cache_emote.path_join(emote_id);
		var request = requests[emote_id];
		var sprite_frames = await _convert_response(request, emote_path);
		response[emote_id] = sprite_frames;
		_cached_images.append(sprite_frames);
	return response;

func _load_emote(emote_id : String) -> BufferedHTTPClient.RequestData:
	var request_path = "/emoticons/v2/%s/default/dark/1.0" % [emote_id];
	var client = HttpClientManager.get_client(TwitchSetting.twitch_image_cdn_host);
	return client.request(request_path, HTTPClient.METHOD_GET, BufferedHTTPClient.HEADERS, "");

func _map_emotes(result: Variant) -> Dictionary:
	var mappings : Dictionary = {};
	var emotes : Array = result.get("data");
	if emotes == null:
		return mappings;
	for emote in emotes:
		mappings[emote.get("id")] = emote;
	return mappings;

func get_cached_emotes(channel_id) -> Dictionary:
	if not cached_emotes.has(channel_id):
		await preload_emotes(channel_id);
	return cached_emotes[channel_id];

#endregion

#region Badges

class BadgeData extends RefCounted:
	var badge_set: String;
	var badge_id: String;
	var scale: String;
	var channel: String;

	## badge_composite example: "subscriber/6;"
	func _init(badge_composite: String, badge_scale: String, badge_channel: String) -> void:
		var badge_data : PackedStringArray = badge_composite.split("/", ALLOW_EMPTY, MAX_SPLITS);
		badge_set = badge_data[0];
		badge_id = badge_data[1];
		scale = badge_scale;
		channel = badge_channel;

	func get_cache_id() -> String:
		return "_".join([
			channel,
			badge_set,
			badge_id,
			scale
		]);

func preload_badges(channel_id: String = "global") -> void:
	if not cached_badges.has(channel_id):
		var response;
		if channel_id == "global":
			response = await(api.get_global_chat_badges());
		else:
			response = await(api.get_channel_chat_badges(channel_id));
		cached_badges[channel_id] = _cache_badges(response);

func get_badges(badge_composites : Array[String], channel_id : String = "global", scale : String = "1x") -> Dictionary:
	var response: Dictionary = {};
	var requests: Dictionary = {};

	for badge_composite in badge_composites:
		var badge_data : BadgeData = BadgeData.new(badge_composite, scale, channel_id);
		var cache_id : String = badge_data.get_cache_id();
		var badge_path : String = TwitchSetting.cache_badge.path_join(cache_id);
		if ResourceLoader.has_cached(badge_path):
			response[badge_composite] = ResourceLoader.load(badge_path);
		else:
			var request = _load_badge(badge_data);
			requests[badge_composite] = request;

	for badge_composite in requests:
		var badge_data: BadgeData = BadgeData.new(badge_composite, scale, channel_id);
		var request = requests[badge_composite];
		var id : String = badge_data.get_cache_id();
		var badge_path : String = TwitchSetting.cache_badge.path_join(id);
		var sprite_frames = await _convert_response(request, badge_path);
		response[badge_composite] = sprite_frames;
		_cached_images.append(sprite_frames);

	return response;

func _load_badge(badge_data: BadgeData) -> BufferedHTTPClient.RequestData:
	var channel_id = badge_data.channel;
	var badge_set = badge_data.badge_set;
	var badge_id = badge_data.badge_id;
	var scale = badge_data.scale;

	var is_global_chanel = channel_id == "global";
	var channel_has_badge = cached_badges[channel_id].has(badge_set) && cached_badges[channel_id][badge_set]["versions"].has(badge_id);
	if (!is_global_chanel && !channel_has_badge):
		badge_data.channel = "global";
		return _load_badge(badge_data);

	var base_url = TwitchSetting.twitch_image_cdn_host;
	var request_path = cached_badges[channel_id][badge_set]["versions"][badge_id]["image_url_%s" % scale].trim_prefix(base_url);
	var client = HttpClientManager.get_client(base_url);
	return client.request(request_path, HTTPClient.METHOD_GET, BufferedHTTPClient.HEADERS, "");

# Maps the badges into a dict of category / versions / badge_id
func _cache_badges(result: Variant) -> Dictionary:
	var mappings : Dictionary = {};
	var badges : Array = result["data"];
	for badge in badges:
		if not mappings.has(badge["set_id"]):
			mappings[badge["set_id"]] = {
				"set_id": badge["set_id"],
				"versions" : {}
			};
		for version in badge["versions"]:
			mappings[badge["set_id"]]["versions"][version["id"]] = version;
	return mappings;

func get_cached_badges(channel_id) -> Dictionary:
	if(!cached_badges.has(channel_id)):
		await preload_badges(channel_id);
	return cached_badges[channel_id];
#endregion

#region Utilities

func _convert_response(request: BufferedHTTPClient.RequestData, output_path: String) -> SpriteFrames:
	var client = request.client;
	var response = await client.wait_for_request(request);
	var image_transformer = TwitchSetting.image_transformer;
	var response_data = response.response_data;
	var cache_path = output_path + ".res"
	var sprite_frames = await image_transformer.convert_image(output_path, response_data, cache_path) as SpriteFrames;
	return sprite_frames;

#endregion
