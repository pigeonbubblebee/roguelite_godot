class_name CracklingStrikeCard
extends Card

var damage : int = 80
var damage_type : DamageType.Type = DamageType.Type.LIGHTNING

var is_discarded = false

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var target = context.get_selected_enemy()

	if is_discarded:
		target = context.get_actors_of_faction(Faction.Type.ENEMY).pick_random()
	
	EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.damage(target, damage, damage_type)\
		.enqueue()
	
	

func on_discard(context: BattleContext, controller: BattleController):
	super.on_discard(context, controller)
	
	is_discarded = true
	
	var fua = CardPlayFollowUp.new(play, self.id)
	
	fua.execute(context, controller)	
