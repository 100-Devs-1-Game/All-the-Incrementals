class_name WTFMinigameUpgradeLogic
extends BaseMinigameUpgradeLogic

enum UpgradeType { INVALID, TODO }

@export var type: UpgradeType = UpgradeType.INVALID


func _apply_effect(_game: BaseMinigame, _upgrade: MinigameUpgrade):
	if _game != WTFGlobals.minigame:
		push_error("WTF - minigame is invalid")
		assert(false)
		return

	match type:
		UpgradeType.TODO:
			print("todo")
		_:
			push_error("WTF - upgrade %s is unknown (%s)" % [_upgrade.name, _upgrade.resource_path])
			assert(false)
