class_name RancorousBoltCard
extends Card

var damage : int = 130
var status_turns : int = 2
var status_id : String = "rancorous_bolt_status"
var vuln_percent : float = 0.4
var damage_type : DamageType.Type = DamageType.Type.COLD

func play(context: BattleContext, controller: BattleController):
	super.play(context, controller)
	
	var target = context.get_selected_enemy()
	var effect =  DamageTakenAmplificationEffect.new(status_id, 
		status_turns, vuln_percent)
	
	EffectSequenceBuilder.new(context, controller)\
		.as_card(self)\
		.damage(target, damage, damage_type)\
		.apply_status(target, effect)\
		.enqueue()
