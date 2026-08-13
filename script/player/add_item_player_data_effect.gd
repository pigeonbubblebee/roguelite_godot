class_name AddItemPlayerDataEffect
extends PlayerDataEffect

var item_id
var slot := -1

func _init(item : String, _slot = slot):
	item_id = item
	slot = _slot

func apply(player_data : PlayerData):
	if slot > -1 and slot < player_data.max_items:
		player_data.items[slot] = ItemDatabase.get_item(item_id)
		return
		
	if not player_data.has_item_capacity():
		var request := ItemReplacementRequestContext.new(
			ItemDatabase.get_item(item_id),
			player_data.items
		)

		interaction_requested.emit(request)
		return
	
	player_data.items.append(ItemDatabase.get_item(item_id))
	
	
