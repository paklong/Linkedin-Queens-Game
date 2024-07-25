extends ParallaxBackground

# Speed of the parallax scrolling
var scroll_speed = Vector2(-10, 0)

func _process(delta):
	scroll_offset += scroll_speed * delta
