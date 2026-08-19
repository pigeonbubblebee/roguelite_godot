class_name RestController
extends RefCounted

var _player_data
var heal_amount = 200

signal finish_rest

signal player_data_change_request(data)

#func _init() -> void:
	#reward_handler = RewardHandler.new()
	#reward_handler.player_data_change_request.connect(
	#	func(t): player_data_change_request.emit(t)
	#)
	#reward_manager = BattleRewardsManager.new()

#func get_reward_manager():
#	return reward_manager

func bind_player_data(player_data : PlayerData):
	_player_data = player_data
	#reward_manager.bind_items(player_data.items, player_data.weapon)
	
func get_current_deck() -> Array:
	return _player_data.deck

# for reward
#func create_battle_won_context() -> BattleWonContext:
#	return reward_handler.create_treasure_battle_won_context()

func request_player_data_modification(effect : PlayerDataEffect):
	player_data_change_request.emit(effect)

#func process_reward(reward) -> void:
#	reward_handler.process_reward(reward)

func process_heal() -> void:
	request_player_data_modification(
		HealthChangePlayerDataEffect.new(min(_player_data.max_health, _player_data.health + heal_amount))
	)
	
	finish_rest.emit()
	
func remove_card(index) -> void:
	request_player_data_modification(
		RemoveCardPlayerDataEffect.new(index)
	)
	
	finish_rest.emit()
