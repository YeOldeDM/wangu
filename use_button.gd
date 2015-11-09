
extends TextureButton





func _on_use_toggled( pressed ):
	get_node('../../..')._skill_select(self,pressed)
