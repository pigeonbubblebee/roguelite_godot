class_name EnergyManager
extends Node2D

var energy : int

var max_energy : int = 3

signal energy_change(current: int)
signal energy_used(current, amount)

func reset_energy():
	energy = max_energy
	emit_signal("energy_change", energy)
	
func gain_energy(amt : int = 1):
	energy += amt
	emit_signal("energy_change", energy)
	
func use_energy(energy_use: int):
	var energy_amt = min(energy, energy_use)
	energy -= energy_amt
	
	emit_signal("energy_change", energy)
	energy_used.emit(energy, energy_amt)
