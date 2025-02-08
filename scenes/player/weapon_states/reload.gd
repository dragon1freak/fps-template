extends WeaponState
## Simple reload functions.  Plays the reload start sound, waits for half the reload time,
## plays the reload step sound, waits another half of the reload time, then plays the reload
## end sound and sets current weapon's magazine to the max amount.
##
## If only one reload sound is needed, use the sound_reload_start sound.


## Weapon to reload
var target_weapon : WeaponConfig
## Timer used to go through reload steps
var reload_timer : SceneTreeTimer
var reload_finished := false


func enter(_t) -> void:
	super(_t)
	do_reload()


func exit() -> void:
	if not reload_finished:
		cancel_reload()


func update(_delta) -> void:
	# If the players current weapon isnt the target weapon, cancel the reload
	if target_weapon != target.current_weapon:
		cancel_reload()
		transition_out()



func do_reload() -> void:
	reload_finished = false
	target.start_reload()
	
	target_weapon = current_weapon
	
	if target_weapon.sound_reload_start:
		Audio.play(target_weapon.sound_reload_start, "SFX")
	
	reload_timer = get_tree().create_timer(target_weapon.reload_time / 2.0)
	reload_timer.timeout.connect(do_reload_step)


func do_reload_step() -> void:
	target.on_reload_step()
	
	if target_weapon.sound_reload_step:
		Audio.play(target_weapon.sound_reload_step, "SFX")
	
	reload_timer = get_tree().create_timer(target_weapon.reload_time / 2.0)
	reload_timer.timeout.connect(do_reload_end)


func do_reload_end() -> void:
	target.end_reload()
	
	if target_weapon.sound_reload_end:
		Audio.play(target_weapon.sound_reload_end, "SFX")
	
	target_weapon.current_magazine = target_weapon.max_magazine_size
	reload_finished = true
	transition_out()


func cancel_reload() -> void:
	Utils.signal_disconnect_all(reload_timer.timeout)
	target.cancel_reload()


func transition_out() -> void:
	if target.is_shooting:
		return transition("shoot")
	else:
		return transition("idle")
