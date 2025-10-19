extends Resource

@export var action_name := 'Default Action'
@export var description := 'Default Description'

#will be overridden in the child action resources. performs the action.
func execute(source, target):
	pass 
	
func initialize(name,desc):
	action_name = name
	description = desc
 	
