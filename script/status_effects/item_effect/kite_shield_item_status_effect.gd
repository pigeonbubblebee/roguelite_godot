extends ItemStatusEffect

var triggered := false
var armor := 40
var status_id := "rage_status"

# empowered by default
func _init(id: String, _stacks: int = 1):
	super._init(id, _stacks)

func status_applied(ctx: StatusEffectApplicationContext, context: BattleContext, controller: BattleController):
	if ctx.actor == _owner and not triggered:
		if not ctx.status.get_status_id() == status_id:
			return
		if not ctx.is_preview:
			triggered = true
			
			var custom_action = BattleRuntimeHelper.generate_basic_defense_action(context)

			EffectSequenceBuilder.new(context, controller)\
				.as_status(self)\
				.use_action(custom_action)\
				.armor(context.get_player(), armor * _stacks)\
				.enqueue()
		
func on_turn_end(actor: Actor, battle_context: BattleContext, controller: BattleController):
	super.on_turn_end(actor, battle_context, controller)
	
	if actor == _owner:
		triggered = false
