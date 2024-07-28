extends Node
class_name State

signal Transitioned

var context : SharedContext

func set_context(ctx : SharedContext):
	context = ctx

func Enter():
	pass
	
func Exit():
	pass
	
func Update(_delta: float):
	pass
	
func Physics_Update(_delta: float):
	pass
