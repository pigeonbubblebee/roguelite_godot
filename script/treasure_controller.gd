class_name TreasureController
extends RefCounted

var data
var rewards_manager

signal player_data_change_request(data)

func _init() -> void:
	rewards_manager = BattleRewardsManager.new()

func bind_player_data(d):
	data = d

func can_open():
	if data.keys >= 1:
		return true
	return false

# for reward
func create_battle_won_context() -> BattleWonContext:
	var ctx = BattleWonContext.new()
	ctx.original_gold_reward_variance += 30

	ctx.has_card_reward = false
	
	return ctx

func request_player_data_modification(effect : PlayerDataEffect):
	player_data_change_request.emit(effect)
