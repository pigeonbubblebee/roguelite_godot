class_name BattleEventBus
extends RefCounted

# Event Bus for In Game Effects, like status effects, relic buffs, ect

signal before_damage_dealt(ctx: DamageContext, context: BattleContext, controller: BattleController)
signal damage_dealt(ctx: DamageContext, context: BattleContext, controller: BattleController)
signal turn_ended(actor: Actor, context: BattleContext, controller: BattleController)
signal turn_started(actor: Actor, context: BattleContext, controller: BattleController)
