extends ItemStatusEffect

var triggered := false

func before_status_applied(ctx: StatusEffectApplicationContext, context: BattleContext, controller: BattleController):
	if triggered:
		return
	if ctx.status.status_type == StatusEffect.TYPE_DEBUFF and ctx.status.get_is_visible():
		ctx.status.add_stacks(ctx.status.get_stacks())
		
func status_applied(ctx: StatusEffectApplicationContext, context: BattleContext, controller: BattleController):
	if ctx.status.status_type == StatusEffect.TYPE_DEBUFF and ctx.status.get_is_visible():
		triggered = true

func on_turn_end(actor: Actor, battle_context: BattleContext, controller: BattleController):
	super.on_turn_end(actor, battle_context, controller)
	
	if actor == _owner:
		triggered = false
