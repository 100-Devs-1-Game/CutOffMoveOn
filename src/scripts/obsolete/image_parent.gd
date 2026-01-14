extends Node2D

const DEBUGSLICEABLE = preload("uid://cu6sdnvdnt0s")

@export var spawn_list : Array[SliceableImage] = []
var slicepoints = []

func _ready() -> void:
	if spawn_list.is_empty():
		slicepoints = DEBUGSLICEABLE.create(self)
		print(slicepoints)
