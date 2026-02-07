/atom/movable/screen/alert/status_effect/debuff/exposed
	name = "Exposed"
	desc = "My defenses are exposed. I can be hit through my parry and dodge!"
	icon_state = "exposed"

/datum/status_effect/debuff/exposed
	id = "nofeint"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/exposed
	duration = 10 SECONDS
	mob_effect_icon = 'icons/mob/mob_effects.dmi'
	mob_effect_icon_state = "eff_exposed"
	mob_effect_layer = MOB_EFFECT_LAYER_EXPOSED

/datum/status_effect/debuff/exposed/on_creation(mob/living/new_owner, new_dur)
	if(new_dur)
		duration = new_dur
	return ..()