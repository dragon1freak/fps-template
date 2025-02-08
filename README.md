# Dragon1Freak's FPS Template

This is a simple FPS template that should help get new FPS projects started quicker.  This is primarily for my own personal use, but anyone is welcome to download, fork, report bugs, etc, just don't expect regular support.  

The idea is also to keep this template simple but extensible, so anything more bespoke like extra movement states or other weapon states **won't** be added to the template.  This isn't intended to be a framework covering all the bases, but a way to skip the boilerplate that happens each time I start a new FPS project.

## What this **does** contain

A player controller with:

- a simple movement state machine
- basic stat block for things like health and speed
- movement sounds
- multiple weapon slots
- keyboard/mouse and gamepad support
- simple raycast based interaction

A weapon slot controller with:

- a simple weapon state machine
- a weapon config resource for weapon stats, models, etc
- a player specific version handling player related things like reload animations

A test gym scene with:

- ramps, doorways, and cubes for sizing and movement testing
- a panel for testing interaction actions
- a firing range for testing weapons at varying distances

As well as global scripts for Utils and simplified Audio handling

## What this **doesn't** contain

Enemy related logic

- while the WeaponSlot class can and should be used with enemies and other NPCs for handling attacks, enemy specific scripts are not included

Projectile based weapons

- the WeaponConfig _does_ contain a field for a projectile, but no weapons in the template currently use it.  This should be easy to implement in a weapon state

Complex movements such as sliding, double jumping, etc

- the goal here is a simple startup template, anything more bespoke would bloat the template.  Better to add what you do need than remove everything you don't
