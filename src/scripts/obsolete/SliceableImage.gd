extends Resource
class_name SliceableImage

@export var texture : Texture2D
@export var VSlices : int
@export var HSlices : int

func create(parent: Node2D) -> Array:
	var slicepoints = []
	for x in range(VSlices):
		for y in range(HSlices):
			var sprite = Sprite2D.new()
			sprite.region_enabled = true
			sprite.texture = texture
			sprite.region_rect = Rect2(
				Vector2(texture.get_width() / VSlices * x, texture.get_height() / HSlices * y),
				texture.get_size() / Vector2(VSlices, HSlices)
			)
			parent.add_child(sprite)
			sprite.position = Vector2(texture.get_width() / VSlices * x, texture.get_height() / HSlices * y)
			if (x == 0 and y != 0) or (y == 0 and x != 0): 
				var opposite = sprite.position + Vector2(texture.get_width(), 0) if x == 0 else sprite.position + Vector2(0, texture.get_height())
				slicepoints.append([sprite.position,opposite])
	return slicepoints
