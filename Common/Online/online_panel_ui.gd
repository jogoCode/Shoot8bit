extends CanvasLayer


@onready var _addressField:LineEdit = get_node("MainMenu/MarginContainer/VBoxContainer/AddressField");
@onready var _pseudoField:LineEdit = get_node("MainMenu/MarginContainer/VBoxContainer/PseudoField");


const PLAYER = preload("res://Entities/Actor/Player/player.tscn");
const PORT = 6000;
var _enet_peer = ENetMultiplayerPeer.new();

func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	pass


func _on_host_button_pressed() -> void:
	if !has_pseudo():
		return;
	get_child(0).hide();
	_enet_peer.create_server(PORT);
	multiplayer.multiplayer_peer = _enet_peer;
	multiplayer.peer_connected.connect(add_player);
	multiplayer.peer_disconnected.connect(remove_player);
	add_player(multiplayer.get_unique_id());
	upnp_setup();


func _on_join_button_pressed() -> void:
	if !has_pseudo():
		return;
	get_child(0).hide();
	var peer_errors = _enet_peer.create_client(_addressField.text,PORT);
	print("Peer start status: ", peer_errors);
	print(_addressField.text);
	multiplayer.multiplayer_peer = _enet_peer;
	add_player(multiplayer.get_unique_id());

func has_pseudo()->bool:
	if(_pseudoField.text == "" or _pseudoField.text.contains("_")):
		_pseudoField.placeholder_text = "Enter a pseudo";
		_pseudoField.flat = true;
		return false;
	return true;

func add_player(peer_id):
	var player = PLAYER.instantiate();
	player.name = str(peer_id);
	player._pseudo = _pseudoField.text;
	player.get_node("Label").text = player._pseudo;
	get_tree().current_scene.add_child(player);

func remove_player(peer_id):
	var player = get_tree().current_scene.get_node_or_null(str(peer_id));
	print("disconnect ",player._pseudo);
	if player:
		player.queue_free();

func upnp_setup():
	var upnp = UPNP.new();
	var discoverResult = upnp.discover();
	assert(discoverResult == UPNP.UPNP_RESULT_SUCCESS,\
		"UPNP Discover Failed ! Error %s"% discoverResult)
	
	assert(upnp.get_gateway() and upnp.get_gateway().is_valid_gateway(),\
		"UNPN INVALID GATEWAY !")
	
	var mapResult = upnp.add_port_mapping(PORT);
	assert(mapResult == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Port mapping failed! Error %s" % mapResult);
	
	print("Succes ! Join Address: %s" % upnp.query_external_address());
	get_node("IP").text = str(upnp.query_external_address());
