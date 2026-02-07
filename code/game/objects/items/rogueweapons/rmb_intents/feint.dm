/datum/rmb_intent/feint
	name = "feint"
	desc = "(RMB WHILE DEFENSE IS ACTIVE) A deceptive half-attack with no follow-through, meant to force your opponent to open their guard."
	icon_state = "rmbfeint"

/datum/rmb_intent/feint/special_attack(mob/living/user, atom/target)
	if(!isliving(target))
		return
	if(!user)
		return
	if(user.incapacitated())
		return
	if(!user.mind)
		return
	if(user.has_status_effect(/datum/status_effect/debuff/feintcd))
		return

	var/mob/living/HT = target
	var/mob/living/HU = user

	// Riposte counters feint, but if an active riposte is up, feint counters it.
	if(istype(HT.rmb_intent, /datum/rmb_intent/riposte) && !HT.has_status_effect(/datum/status_effect/buff/clash)) 
		playsound(user, 'sound/combat/feint.ogg', 100, TRUE)
		to_chat(HU, span_notice("[HT] looks at me like I'm some sort of fool!"))
		to_chat(HT, span_danger("[HU] tried to feint an attack at me, what a fool!"))
		HU.apply_status_effect(/datum/status_effect/debuff/feintcd)
		return

	if(!HT.cmode) // You attempted to bait someone who wasn't in combat mode.
		playsound(user, 'sound/combat/feint.ogg', 100, TRUE)
		HU.visible_message(span_danger("[HU] feints an attack at [HT], and makes a fool of themselves!"))
		HU.Slowdown(3)
		HU.OffBalance(4 SECONDS)
		HU.apply_status_effect(/datum/status_effect/debuff/feintcd)
		return
	
	if(!(HT.can_see_cone(HU)))
		playsound(user, 'sound/combat/feint.ogg', 100, TRUE)
		HU.visible_message(span_danger("[HU] feints an attack at [HT]... who was looking the other way."))
		HU.apply_status_effect(/datum/status_effect/debuff/feintcd)
		return


	HU.visible_message(span_danger("[HU] feints an attack at [HT]!"))

	var/perc = 50
	var/obj/item/I = HU.get_active_held_item()
	var/ourskill = 0
	var/theirskill = 0
	var/skill_factor = 0
	if(HT.has_status_effect(/datum/status_effect/debuff/exposed))
		perc = 0
	else
		if(I)
			if(I.associated_skill)
				ourskill = HU.get_skill_level(I.associated_skill)
			if(HT.mind)
				I = HT.get_active_held_item()
				if(I?.associated_skill)
					theirskill = HT.get_skill_level(I.associated_skill)
		perc += (ourskill - theirskill) * 20    //skill is of the essence
		perc += (HU.STAINT - HT.STAINT) * 4
		if(HT.IsOffBalanced())
			perc += 10
		if(HU.IsOffBalanced() || !(HU.mobility_flags & MOBILITY_STAND)) // Feinter is off balanced or lying down? Shoddy feint
			perc -= 30
		skill_factor = (ourskill - theirskill)/2
		perc = CLAMP(perc, 10, 90) // Min of 10%, Max of 90%

	HU.apply_status_effect(/datum/status_effect/debuff/feintcd)

	if(HT.has_status_effect(/datum/status_effect/buff/clash)) // Guaranteed feint on an active guard. 
		HT.remove_status_effect(/datum/status_effect/buff/clash)
		to_chat(HU, span_notice("[HT.p_their(TRUE)] Guard disrupted!"))
	else if(!prob(perc))
		playsound(HU, 'sound/combat/feint.ogg', 100, TRUE)
		HU.stamina_add(HU.stamina * 0.1) // Failed? Lose some stamina.
		if(HU.client?.prefs.showrolls)
			to_chat(HU, span_warning("[HT.p_they(TRUE)] did not fall for my feint... [perc]%"))
		return
	// +20% parry / dodge and +20% hit chance.
	HU.apply_status_effect(/datum/status_effect/buff/feint) // 10 second buff

	HT.apply_status_effect(/datum/status_effect/debuff/exposed, 3 SECONDS)
	HT.apply_status_effect(/datum/status_effect/debuff/clickcd, max(1.5 SECONDS + skill_factor, 2.5 SECONDS))
	HT.Immobilize(0.5 SECONDS)
	HT.stamina_add(HT.stamina * 0.1)
	HT.Slowdown(2)
	to_chat(HU, span_notice("[HT.p_they(TRUE)] fell for my feint attack!"))
	to_chat(HT, span_danger("I fall for [HU.p_their()] feint attack!"))
	playsound(HU, 'sound/combat/riposte.ogg', 100, TRUE)