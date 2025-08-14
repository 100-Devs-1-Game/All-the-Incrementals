class_name WaterRowingRapidsMinigameUpgradeLogic
extends BaseMinigameUpgradeLogic

enum UpgradeType {
	## Increases player regular top speed by X%
	SPEED,
	## Increases speed bonus while boosting by X%
	BOOST_SPEED,
	## Increases boost duration by X%
	BOOST_DURATION,
	## Increases boat maximum stability by +X
	STABILITY_MAX,
	## Adds regeneration of stability over time (X stability/sec)
	STABILITY_REGEN,
	## Decreases the speed of the void by X%
	VOID_SPEED
}

const BASE_PREFIX: String = "base_"

@export var type: UpgradeType


## Registers a property's current value as its base to be retreived later
static func register_base(object: Object, property: StringName) -> void:
	assert(
		property in object,
		'Attempt to register nonexistent property &"%s" on base %s' % [property, object]
	)
	var value: Variant = object.get(property)
	assert(
		not object.has_meta(BASE_PREFIX + property),
		'Object %s has conflicting metadata item &"%s%s"' % [object, BASE_PREFIX, property]
	)
	object.set_meta(BASE_PREFIX + property, value)


## You'll NEVER guess what this does.
static func multiregister_base(object: Object, properties: Array[StringName]) -> void:
	for property in properties:
		register_base(object, property)


static func increase_from_base(object: Object, property: StringName, percentage: float) -> void:
	assert(
		not object.has_meta(property),
		'Attempt to add to unregistered property &"%s" on base %s' % [property, object]
	)
	var value = object.get_meta(BASE_PREFIX + property) * percentage
	print('setting property &"%s" to %s (%.1f%% of base)' % [property, value, percentage * 100])
	object.set(property, value)


func _apply_effect(p_game: BaseMinigame, upgrade: MinigameUpgrade):
	var game: WaterRowingRapidsMinigame = p_game
	var effect_modifier: float = upgrade.get_current_effect_modifier()

	match type:
		UpgradeType.SPEED:
			increase_from_base(game.player, &"speed", effect_modifier)
		UpgradeType.BOOST_SPEED:
			increase_from_base(game.player, &"boost_impulse", effect_modifier)
		UpgradeType.BOOST_DURATION:
			increase_from_base(game.player, &"boost_duration", effect_modifier)
		UpgradeType.STABILITY_MAX:
			game.player.boat_max_stability = effect_modifier
			game.player.boat_stability = effect_modifier
		UpgradeType.STABILITY_REGEN:
			game.player.stability_regen = effect_modifier
		UpgradeType.VOID_SPEED:
			increase_from_base(game.chase_void, &"speed", -effect_modifier)
