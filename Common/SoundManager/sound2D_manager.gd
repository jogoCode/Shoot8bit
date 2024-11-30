@tool
extends Node

var is_activate:bool = true;
var num = 0;

@export var sounds:Dictionary;
@onready var sound_players:Array = get_children();

func _ready():
	await  get_tree().create_timer(0.1).timeout;
	init()
	print(sounds);
	
func init():
	var Audios = DirAccess.open("res://Assets/Audio");
	if Audios == null: printerr("Could not open folder"); return
	Audios.list_dir_begin();
	for file: String in Audios.get_files():
		if(!file.contains(".import")):
			var resource := load(Audios.get_current_dir() + "/" + file);
			sounds.get_or_add(file.get_basename(),load(Audios.get_current_dir() + "/" + file));

func play(sound_name:String,position:Vector2,delay:float=0):
	if is_activate:
		await get_tree().create_timer(delay).timeout;
		if sound_name == "Impact":
			num+=1;
		var audioStreamPlayer2D:AudioStreamPlayer2D = AudioStreamPlayer2D.new();
		var sound_to_play = sounds[sound_name];
		audioStreamPlayer2D.stream = sound_to_play;
		audioStreamPlayer2D.autoplay = true;
		audioStreamPlayer2D.attenuation = 4;
		audioStreamPlayer2D.global_position = position;
		audioStreamPlayer2D.max_distance = 750;
		get_tree().current_scene.add_child(audioStreamPlayer2D);
		await get_tree().create_timer(audioStreamPlayer2D.stream.get_length()).timeout;
		audioStreamPlayer2D.queue_free()
