class_name BattleItemManager
extends Node

var _items : Array[Item]
var _weapon : Item

signal items_updated(items)
signal weapon_updated(item)

func create_items(ids:Array[String], context: BattleContext, controller:BattleController):
	for entry in ids:
		var item_instance = init_item_script_from_id(entry)
		
		_items.append(item_instance)
	items_updated.emit(_items)
	
func create_weapon(id, context: BattleContext, controller:BattleController):
	_weapon = init_item_script_from_id(id)
	weapon_updated.emit(_weapon)
	
func initialize_items(context: BattleContext, controller:BattleController):
	for item_instance in _items:
		item_instance.on_battle_start(context, controller)
	
	_weapon.on_battle_start(context, controller)

func get_items() -> Array[Item]:
	return _items
	
func get_weapon() -> Item:
	return _weapon

func init_item_script_from_id(id : String) -> Item:
	var item = ItemDatabase.get_item(id)
	if(item["SCRIPT"]):
		return item["SCRIPT"].new(id)
	else:
		return ItemDatabase.get_item("iron_helm")["SCRIPT"].new(id)
