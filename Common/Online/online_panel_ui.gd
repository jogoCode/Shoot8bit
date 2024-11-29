extends CanvasLayer


@onready var _addressField:LineEdit = get_node("MainMenu/MarginContainer/VBoxContainer/AddressField");

const PLAYER = preload("res://Entities/Actor/Player/player.tscn");
const PORT = 9999;
var _enet_peer = ENetMultiplayerPeer.new();

func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	pass


func _on_host_button_pressed() -> void:
	hide();
	_enet_peer.create_server(PORT);
	multiplayer.multiplayer_peer = _enet_peer;
	multiplayer.peer_connected.connect(add_player);
	add_player(multiplayer.get_unique_id());
	pass


func _on_join_button_pressed() -> void:
	hide();
	_enet_peer.create_client("localhost",PORT);
	multiplayer.multiplayer_peer = _enet_peer;
	add_player(multiplayer.get_unique_id());
	pass


func add_player(peer_id):
	var player = PLAYER.instantiate();
	player.name = str(peer_id);
	get_tree().current_scene.add_child(player);
