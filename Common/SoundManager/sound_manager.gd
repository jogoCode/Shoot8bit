extends Node

var is_activate:bool = true;
var num = 0;

var sounds:Dictionary;

@onready var sound_players:Array = get_children();

func _ready():
	await  get_tree().create_timer(0.1).timeout;
	init()
	
func init():
	var Audios = DirAccess.open("res://Assets/Audio");
	if Audios == null: printerr("Could not open folder"); return
	Audios.list_dir_begin();
	for file: String in Audios.get_files():
		
		var resource := load(Audios.get_current_dir() + "/" + file);
		if(!file.contains(".import")):
			sounds.get_or_add(file.get_basename(),load(Audios.get_current_dir() + "/" + file));

func play(sound_name:String,delay:float=0):
	if is_activate:
		await get_tree().create_timer(delay).timeout;
		if sound_name == "Impact":
			num+=1;
		var sound_to_play = sounds[sound_name];
		if(sounds[sound_name] is Array):# plusieur variante de son
			var rand = randf_range(0,sounds[sound_name].size());
			sound_to_play = sounds[sound_name][int(rand)];
		for sound_player in sound_players:
			sound_player.pitch_scale = randf_range(0.98,1);
			if(sound_player.playing and sound_player.stream == sound_to_play):
				sound_player.play();
				return;
			if(!sound_player.playing):
				sound_player.volume_db =0;
				sound_player.stream = sound_to_play;
				sound_player.pitch_scale = randf_range(0.98,1.5);
				sound_player.play();
				return;
			if(sound_player.playing and sound_name == "G_Slash"):
				sound_player.volume_db =0;
				sound_player.stream = sound_to_play;
				sound_player.pitch_scale = randf_range(0.98,1.05);
				sound_player.play();
				return;
		printerr("To many sound play at the same time, not enought sound player");
