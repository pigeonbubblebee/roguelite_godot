class_name BattleEventBus
extends RefCounted

signal before_damage_dealt(ctx: DamageContext, context: BattleContext, controller: BattleController)
signal damage_dealt(ctx: DamageContext, context: BattleContext, controller: BattleController)
signal turn_ended(actor: Actor, context: BattleContext, controller: BattleController)
