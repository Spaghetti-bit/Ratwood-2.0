/datum/rmb_intent/riposte
	name = "defend"
	desc = "No delay between dodge and parry rolls.\n(RMB WHILE NOT GRABBING ANYTHING AND HOLDING A WEAPON)\nEnter a defensive stance, guaranteeing the next hit is defended against.\nTwo people who hit each other with the Guard up will have their weapons Clash, potentially disarming them.\nLetting it expire or hitting someone with it who has no Guard up is tiresome."
	icon_state = "rmbdef"
	adjacency = FALSE
	bypasses_click_cd = TRUE

/datum/rmb_intent/riposte/special_attack(mob/living/user, atom/target)	//Wish we could breakline these somehow.
	if(!user.has_status_effect(/datum/status_effect/buff/clash) && !user.has_status_effect(/datum/status_effect/debuff/clashcd))
		if(!user.get_active_held_item()) //Nothing in our hand to Guard with.
			return
		if(user.r_grab || user.l_grab || length(user.grabbedby)) //Not usable while grabs are in play.
			return
		if(user.IsImmobilized() || user.IsOffBalanced()) //Not usable while we're offbalanced or immobilized
			return
		if(user.m_intent == MOVE_INTENT_RUN)
			to_chat(user, span_warning("I can't focus on this while running."))
			return
		if(user.magearmor == FALSE && HAS_TRAIT(user, TRAIT_MAGEARMOR))	//The magearmor is ACTIVE, so we can't Guard. (Yes, it's active while FALSE / 0.)
			to_chat(user, span_warning("I'm already focusing on my mage armor!"))
			return
		user.apply_status_effect(/datum/status_effect/buff/clash)