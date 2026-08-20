class_name BattleEventBus
extends RefCounted

# Event Bus for In Game Effects, like status effects, relic buffs, ect

signal before_damage_dealt(ctx: DamageContext, context: BattleContext, controller: BattleController)
signal damage_dealt(ctx: DamageContext, context: BattleContext, controller: BattleController)

signal turn_ended(actor: Actor, context: BattleContext, controller: BattleController)
signal turn_started_after_action(actor: Actor, context: BattleContext, controller: BattleController)
signal turn_started(actor: Actor, context: BattleContext, controller: BattleController)

signal before_armor_applied(ctx: ArmorGainContext, context: BattleContext, controller: BattleController)
signal armor_applied(ctx: ArmorGainContext, context: BattleContext, controller: BattleController)
signal on_armor_reset_request(ctx: ArmorResetContext, context: BattleController, controller: BattleController)

signal on_card_discarded(card : Card, context: BattleContext, controller: BattleController)
signal on_card_added_to_deck(card : Card, context: BattleContext, controller: BattleController)

signal on_card_played(card : Card, context: BattleContext, controller: BattleController)
signal before_card_played(card : Card, context: BattleContext, controller: BattleController)

signal actor_died(actor: Actor, context: BattleContext, controller: BattleController)

signal before_modifier_applied(card: Card, mod: CardModifier, context: BattleContext, controller: BattleController)
signal modifier_applied(card: Card, mod: CardModifier, context: BattleContext, controller: BattleController)

signal before_status_applied(ctx: StatusEffectApplicationContext, context: BattleContext, controller: BattleController)
signal status_applied(ctx: StatusEffectApplicationContext, context: BattleContext, controller: BattleController)

signal card_cost_request(ctx: CardCostRequestContext)
