/datum/status_effect/debuff/baited
	id = "bait"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/baited
	duration = 20 SECONDS

/atom/movable/screen/alert/status_effect/debuff/baited
	name = "Baited"
	desc = "I fell for it. I'm exposed. I won't fall for it again. For now."
	icon_state = "bait"

/atom/movable/screen/alert/status_effect/debuff/baitedcd
	name = "Bait Cooldown"
	desc = "I used it. I must wait."
	icon_state = "baitcd"

/datum/status_effect/debuff/baitcd
	id = "baitcd"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/baitedcd
	duration = 30 SECONDS