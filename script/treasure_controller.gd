class_name TreasureController
extends RefCounted

var data

signal player_data_change_request(data)
var reward_handler: RewardHandler

func _init() -> void:
	reward_handler = RewardHandler.new()
	reward_handler.player_data_change_request.connect(
		func(t): player_data_change_request.emit(t)
	)

func bind_player_data(d):
	data = d

func can_open():
	if data.keys >= 1:
		return true
	return false

# for reward
func create_battle_won_context() -> BattleWonContext:
	return reward_handler.create_treasure_battle_won_context()

func request_player_data_modification(effect : PlayerDataEffect):
	player_data_change_request.emit(effect)

func process_reward(reward) -> void:
	reward_handler.process_reward(reward)
