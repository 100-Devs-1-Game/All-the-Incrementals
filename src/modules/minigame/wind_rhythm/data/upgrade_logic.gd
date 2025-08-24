class_name WindRhythmUpgradeLogic
extends BaseMinigameUpgradeLogic

enum UpgradeType {
	CONCENTRATION_DRAIN_RATE,
	CONCENTRATION_MAX_MULTIPLER,
	COMBO_MULT_ADD,
	COMBO_PROTECTION,
	PERFECT_PLAY_BONUS,
	CONDUCTOR_1,
	CONDUCTOR_2,
	CONDUCTOR_3,
	CONDUCTOR_4,
	CONDUCTOR_5,
	CONDUCTOR_6,
	CONDUCTOR_1_GREAT,
	CONDUCTOR_2_GREAT,
	CONDUCTOR_3_GREAT,
	CONDUCTOR_4_GREAT,
	CONDUCTOR_5_GREAT,
	CONDUCTOR_6_GREAT,
	CONDUCTOR_1_PERFECT,
	CONDUCTOR_2_PERFECT,
	CONDUCTOR_3_PERFECT,
	CONDUCTOR_4_PERFECT,
	CONDUCTOR_5_PERFECT,
	CONDUCTOR_6_PERFECT,
	ADD_LANE_1,
	ADD_LANE_2,
	ADD_LANE_3,
	ADD_LANE_4,
	ADD_LANE_5,
	ADD_LANE_6,
}

const NOTE_TYPE = preload("res://modules/minigame/wind_rhythm/chart/note_types.gd").NoteType
const JUDGMENT = preload("res://modules/minigame/wind_rhythm/chart/judgments.gd").Judgment

@export var upgrade_type: UpgradeType


func _apply_effect(game: BaseMinigame, upgrade: MinigameUpgrade):
	var my_game: RhythmGame = game

	match upgrade_type:
		UpgradeType.CONCENTRATION_DRAIN_RATE:
			my_game.drain_speed_mult = 1 - upgrade.get_current_effect_modifier()
		UpgradeType.CONCENTRATION_DRAIN_RATE:
			my_game.concentration_max_mult = upgrade.get_current_effect_modifier()
		UpgradeType.COMBO_MULT_ADD:
			my_game.combo_add = upgrade.get_current_effect_modifier()
		UpgradeType.COMBO_PROTECTION:
			my_game.combo_protection_level = int(upgrade.get_current_effect_modifier())
		UpgradeType.PERFECT_PLAY_BONUS:
			my_game.perfect_play_bonus = upgrade.get_current_effect_modifier()
		UpgradeType.CONDUCTOR_1:
			my_game.autoplay[NOTE_TYPE.UP] = JUDGMENT.OKAY
		UpgradeType.CONDUCTOR_2:
			my_game.autoplay[NOTE_TYPE.LEFT] = JUDGMENT.OKAY
		UpgradeType.CONDUCTOR_3:
			my_game.autoplay[NOTE_TYPE.RIGHT] = JUDGMENT.OKAY
		UpgradeType.CONDUCTOR_4:
			my_game.autoplay[NOTE_TYPE.DOWN] = JUDGMENT.OKAY
		UpgradeType.CONDUCTOR_5:
			my_game.autoplay[NOTE_TYPE.SPECIAL1] = JUDGMENT.OKAY
		UpgradeType.CONDUCTOR_6:
			my_game.autoplay[NOTE_TYPE.SPECIAL2] = JUDGMENT.OKAY

		UpgradeType.CONDUCTOR_1_GREAT:
			my_game.autoplay[NOTE_TYPE.UP] = JUDGMENT.GREAT
		UpgradeType.CONDUCTOR_2_GREAT:
			my_game.autoplay[NOTE_TYPE.LEFT] = JUDGMENT.GREAT
		UpgradeType.CONDUCTOR_3_GREAT:
			my_game.autoplay[NOTE_TYPE.RIGHT] = JUDGMENT.GREAT
		UpgradeType.CONDUCTOR_4_GREAT:
			my_game.autoplay[NOTE_TYPE.DOWN] = JUDGMENT.GREAT
		UpgradeType.CONDUCTOR_5_GREAT:
			my_game.autoplay[NOTE_TYPE.SPECIAL1] = JUDGMENT.GREAT
		UpgradeType.CONDUCTOR_6_GREAT:
			my_game.autoplay[NOTE_TYPE.SPECIAL2] = JUDGMENT.GREAT

		UpgradeType.CONDUCTOR_1_PERFECT:
			my_game.autoplay[NOTE_TYPE.UP] = JUDGMENT.PERFECT
		UpgradeType.CONDUCTOR_2_PERFECT:
			my_game.autoplay[NOTE_TYPE.LEFT] = JUDGMENT.PERFECT
		UpgradeType.CONDUCTOR_3_PERFECT:
			my_game.autoplay[NOTE_TYPE.RIGHT] = JUDGMENT.PERFECT
		UpgradeType.CONDUCTOR_4_PERFECT:
			my_game.autoplay[NOTE_TYPE.DOWN] = JUDGMENT.PERFECT
		UpgradeType.CONDUCTOR_5_PERFECT:
			my_game.autoplay[NOTE_TYPE.SPECIAL1] = JUDGMENT.PERFECT
		UpgradeType.CONDUCTOR_6_PERFECT:
			my_game.autoplay[NOTE_TYPE.SPECIAL2] = JUDGMENT.PERFECT

		UpgradeType.ADD_LANE_1:
			my_game.active_lanes[NOTE_TYPE.UP] = true
		UpgradeType.ADD_LANE_2:
			my_game.active_lanes[NOTE_TYPE.LEFT] = true
		UpgradeType.ADD_LANE_3:
			my_game.active_lanes[NOTE_TYPE.RIGHT] = true
		UpgradeType.ADD_LANE_4:
			my_game.active_lanes[NOTE_TYPE.DOWN] = true
		UpgradeType.ADD_LANE_5:
			my_game.active_lanes[NOTE_TYPE.SPECIAL1] = true
		UpgradeType.ADD_LANE_6:
			my_game.active_lanes[NOTE_TYPE.SPECIAL2] = true
