extends ItemStatusEffect

var card_id := "thrust_card"
var card_amt := 2
var vuln_bonus := 0.25

# empowered by default
func _init(id: String, _stacks: int = 1):
	super._init(id, _stacks)
	
func on_apply(_context: BattleContext, _controller: BattleController):
	super.on_apply(_context, _controller)
	
	EffectSequenceBuilder.new(_context, _controller)\
		.as_status(self)\
		.shuffle_card_to_deck(card_id, card_amt)\
		.enqueue()

func before_damage_dealt(context: DamageContext, battle_context: BattleContext, controller: BattleController):
	for actor in context.hit_actors:
		if actor.get_actor_faction() == _owner.get_actor_faction():
			continue
			
		var statuses = actor.get_status_manager().get_active_status()
		
		for status in statuses:
			if status.get_status_id() == "vulnerable_status":
				context.add_vulnerable(vuln_bonus * _stacks, actor)
