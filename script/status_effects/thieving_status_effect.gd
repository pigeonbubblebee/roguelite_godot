class_name ThievingStatusEffect
extends StatusEffect

var gold_taken : int = 0
var triggered := false

func _init(id: String, _stacks: int = 1):
	super._init(id, _stacks)

func damage_dealt(context: DamageContext, battle_context: BattleContext, controller: BattleController):
	if context.damage_owner == _owner:
		var effect = GoldChangePlayerDataEffect.new(-_stacks)
		
		gold_taken += min(_stacks, controller.get_player_data().gold)
		controller.request_player_data_modification(effect)
		
func on_actor_died(actor: Actor, context: BattleContext, controller: BattleController):
	if actor == _owner and not triggered:
		controller.battle_won_context.bonus_gold_reward += gold_taken * 0.5
		triggered = true

func get_is_turn_based() -> bool:
	return false
