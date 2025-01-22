extends Node
class_name Utils


static func interpolated_look_at(from: Transform3D, to: Vector3, weight: float) -> Transform3D:
	var xform := from
	xform = xform.looking_at(to, Vector3.UP, true)
	return from.interpolate_with(xform, weight)


static func is_in_los(transform : Transform3D, pos_b : Vector3, los_angle := 180.0) -> bool:
	var starting_pos := transform.origin
	var rotation := transform.basis.z
	var dot_prod = starting_pos.direction_to(pos_b).dot(rotation)
	
	if dot_prod < 0:
		return false
	
	return dot_prod >= 1.0 - (los_angle / 180.0)
