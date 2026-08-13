class_name RewardHandler
extends RefCounted

signal player_data_change_request(effect: PlayerDataEffect)

var rewards_manager: BattleRewardsManager
signal reward_interaction_requested(request)

func _init() -> void:
	rewards_manager = BattleRewardsManager.new()

func create_treasure_battle_won_context() -> BattleWonContext:
	var ctx := BattleWonContext.new()

	ctx.original_gold_reward_variance += 30
	ctx.has_card_reward = false
	ctx.has_item_reward = true

	return ctx

func process_reward(reward) -> void:
	if reward.card_reward:
		player_data_change_request.emit(
			AddCardPlayerDataEffect.new(reward.card_reward.id)
		)

	if reward.gold_reward:
		player_data_change_request.emit(
			GoldChangePlayerDataEffect.new(reward.gold_reward)
		)

	if reward.key_reward:
		player_data_change_request.emit(
			KeyChangePlayerDataEffect.new(1)
		)
		
	if reward.item_reward:
		var effect = AddItemPlayerDataEffect.new(reward.item_reward.get_item_id(), reward.item_slot_replace)
		effect.interaction_requested.connect(
			_on_effect_interaction_requested
		)
		player_data_change_request.emit(
			effect
		)

func _on_effect_interaction_requested(request) -> void:
	reward_interaction_requested.emit(request)
