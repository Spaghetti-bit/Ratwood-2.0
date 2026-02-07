/atom/movable/screen/alert/status_effect/debuff/feintcd
	name = "Feint Cool down"
	desc = "I used it. I must wait, or risk a lower chance of success."
	icon_state = "feintcd"

/datum/status_effect/debuff/feintcd
	id = "feintcd"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/feintcd
	duration = 15 SECONDS

/datum/status_effect/debuff/feintcd/on_creation(mob/living/new_owner, new_dur)
	if(new_dur)
		duration = new_dur
	return ..()