extends Node
class_name Utils
## Static utilities class


## Interpolates the look_at function, allowing nodes to slowly turn towards an object
static func interpolated_look_at(from: Transform3D, to: Vector3, weight: float) -> Transform3D:
	var xform := from
	xform = xform.looking_at(to, Vector3.UP, true)
	return from.interpolate_with(xform, weight)


## Determines if a position is within a line of sight cone starting at another position.
static func is_in_los(transform : Transform3D, pos_b : Vector3, los_angle := 180.0) -> bool:
	var starting_pos := transform.origin
	var rotation := transform.basis.z
	var dot_prod = starting_pos.direction_to(pos_b).dot(rotation)
	
	if dot_prod < 0:
		return false
	
	return dot_prod >= 1.0 - (los_angle / 180.0)


## Iterates through all connections on a signal and disconnects them.  Can be helpful
## if a signal might have an unknown connection.
static func signal_disconnect_all(target_signal : Signal) -> void:
	for n in target_signal.get_connections():
		target_signal.disconnect(n.get("callable"))
