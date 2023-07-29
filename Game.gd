extends Node2D


@onready var background: Sprite2D = $ParallaxBackground/ParallaxLayer/Background
@onready var background_stars: Sprite2D = $ParallaxBackground/ParallaxLayer2/Stars1
@onready var player: PlayerShip = Globals.player


func _process(_delta: float) -> void:
	background.position = floor(player.position / 500) * 500
	background_stars.position = floor(player.position / 1000) * 1000
