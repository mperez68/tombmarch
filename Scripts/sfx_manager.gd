extends Node

enum Sfx { HIT, MISS, CHARGE, CLICK, DOUBLE_CLICK, DAMAGE, DEATH, EFFECT, HEAL, SHOOT, TURN, DOUBLE_TURN }

@onready var _sounds: Dictionary = {
	Sfx.HIT: $Hit,
	Sfx.MISS: $Miss,
	Sfx.CHARGE: $ChargeHit,
	Sfx.CLICK: $Click,
	Sfx.DOUBLE_CLICK: $DoubleClick,
	Sfx.DAMAGE: $Damage,
	Sfx.DEATH: $Death,
	Sfx.EFFECT: $Effect,
	Sfx.HEAL: $Heal,
	Sfx.SHOOT: $Shoot,
	Sfx.TURN: $Turn,
	Sfx.DOUBLE_TURN: $DoubleTurn
}

func play(s: Sfx):
	_sounds[s].play()
