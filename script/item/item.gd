class_name Item
extends RefCounted

var _item_id : String

var attributes_data : String # String of scaling data, i e STR (A), DEX (B)
var attributes_data_as_dic

var title : String
var texture : Texture2D
var description : String

const SCRIPT_PATH := "res://script/status_effects/item_effect/"

func _init(_id : String):
	var item = ItemDatabase.get_item(_id)
	
	_item_id = item["ITEM_ID"]
	
	attributes_data = ItemDatabase.get_all_attributes(_item_id)
	attributes_data_as_dic = ItemDatabase.get_attributes_as_dic(_item_id)
	texture = item["TEXTURE"]
	title = item["ITEM_NAME"]
	description = item["DESCRIPTION"]
	
func get_item_id() -> String:
	return _item_id
	
func get_item_status_effect_id() -> String:
	return _item_id + "_status"
	
func get_description() -> String:
	return title + ":\n" + description
	
func create_status(context: BattleContext, controller: BattleController) -> StatusEffect:
	var script_path = SCRIPT_PATH + get_item_status_effect_id() + "_effect.gd"

	if ResourceLoader.exists(script_path):
		return load(script_path).new(get_item_status_effect_id(), 1)
	else:
		push_warning("Missing item status for: " + _item_id)
		return null

func on_battle_start(context: BattleContext, controller: BattleController) -> void:
	if not _item_id:
		return
		
	controller.battle_started.connect(func(): apply_item_status(context, controller))
	
func apply_item_status(context, controller):
	var effect = create_status(context, controller)
	var ctx = StatusEffectApplicationContext.new(context.get_player(), effect, self)
	controller.apply_status(ctx)
