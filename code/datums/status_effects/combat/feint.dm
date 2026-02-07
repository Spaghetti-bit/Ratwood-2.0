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

/atom/movable/screen/alert/status_effect/buff/feint
	name = "Feint!"
	desc = "They fell for it! Now's my time to capitalize, I'm at my peak! (+20% chance to bypass parry / dodge, +20% chance to parry / dodge)"
	icon_state = "buff"

/datum/status_effect/buff/feint
	id = "feintbuff"
	alert_type = /atom/movable/screen/alert/status_effect/buff/feint
	duration = 10 SECONDS

/datum/status_effect/buff/feint/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_GUIDANCE, TRAIT_STATUS_EFFECT)

/datum/status_effect/buff/feint/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_GUIDANCE, TRAIT_STATUS_EFFECT)