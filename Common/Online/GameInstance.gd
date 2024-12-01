extends Node

@onready var _messageLabel:RichTextLabel = $CanvasLayer/Label;

func _ready() -> void:
	pass

func message(message:String):
	_messageLabel.text +="\n "+message;

func kill_log(killer,killed):
	_messageLabel.text +="\n "+killed + "was killed by" + killer;
