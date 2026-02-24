class_name EnergyManager
extends Node2D

var energy : int

var max_energy : int = 3

signal energy_change(current: int)

func reset_energy():
	energy = max_energy
	emit_signal("energy_change", energy)
	
func use_energy(energy_use: int):
	energy -= energy_use
	
	if energy < 0:
		energy = 0
	
	emit_signal("energy_change", energy)
