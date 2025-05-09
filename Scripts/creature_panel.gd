extends Control

func set_bars(this: Creature):
	%HPBar.max_value = this.max_hp
	%HPBar.value = this.hp
	if this.max_mp > 0:
		%MPBar.max_value = this.max_mp
		%MPBar.value = this.mp
	else:
		%MPBar.visible = false

func set_hp(value: int):
	%HPBar.value = clampi(value, 0, %HPBar.max_value)

func set_mp(value: int):
	%MPBar.value = clampi(value, 0, %MPBar.max_value)
