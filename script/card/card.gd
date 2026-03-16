class_name Card
extends RefCounted

var id : String
var cost := 1
var texture : Texture2D
var target_drag := true
var title : String
var type : CardType
var description : String
var scaling_data : String # String of scaling data, i e STR (A), DEX (B)

signal played

func _init(_id : String):
	var card = CardDatabase.get_card(_id)
	
	id = card["CARD_ID"]
	
	cost = card["COST"]
	scaling_data = CardDatabase.get_all_scaling(id)
	texture = card["TEXTURE"]
	type = card["TYPE"]
	target_drag = (type == CardType.ATTACK)
	title = card["CARD_NAME"]
	description = card["DESCRIPTION"]
	
enum ResolveEffect {
	DISCARD,
	REMOVE
}

func on_discard(context, controller):
	pass
	
func effect_on_resolve(context, controller) -> ResolveEffect:
	return ResolveEffect.DISCARD

func can_play(context: BattleContext) -> bool:
	return context.get_current_energy() >= cost

func play(context: BattleContext, controller: BattleController):
	emit_signal("played")
	pass
	
func get_keywords() -> Array[String]:
	return []
	
# For enemies
func get_target_index(total_targets: int, target_index: int) -> Array[int]:
	return get_index_single(total_targets, target_index)

# For allies
func get_buff_target_index(total_targets: int) -> Array[int]:
	return []
	
func get_cost() -> int:
	return cost

# Callable by subclass

# Index 0 always center target
func get_index_blast(total_targets: int, target_index: int) -> Array[int]:
	var result : Array[int] = [target_index]
	
	if target_index != 0:
		result.append(target_index - 1)
	if target_index != total_targets - 1:
		result.append(target_index + 1)
	
	return result

# Index 0 always selected target
func get_index_aoe(total_targets: int, target_index: int) -> Array[int]:
	var result : Array[int] = [target_index]
	
	for i in range(total_targets):
		if not i == target_index:
			result.append(i)
	
	return result
		
func get_index_single(total_targets: int, target_index: int) -> Array[int]:
	var result : Array[int] = [target_index]
	
	return result
	
func get_index_buff_single_target(total_targets: int) -> Array[int]:
	return [ 0 ]
	
static func get_card_type_as_string(type: CardType) -> String:
	match type:
		CardType.ATTACK:
			return "Attack"
		CardType.BUFF:
			return "Buff"
		CardType.DEFENSE:
			return "Defense"
	return "Cannot Find Type"
	
static func get_string_as_card_type(string: String) -> CardType:
	match string:
		"ATTACK":
			return CardType.ATTACK
		"BUFF":
			return CardType.BUFF
		"DEFENSE":
			return CardType.DEFENSE
	return CardType.ATTACK

enum CardType {
	ATTACK,
	BUFF,
	DEFENSE
}
