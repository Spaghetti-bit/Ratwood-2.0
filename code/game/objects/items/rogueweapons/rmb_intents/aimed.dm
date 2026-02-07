/datum/rmb_intent/aimed
	name = "aimed"
	desc = "Your attacks are more precise but have a longer recovery time. Higher critrate with precise attacks.\n(RMB WHILE COMBAT MODE IS ACTIVE) Bait out your targeted limb to the enemy. If it matches where they're aiming, they will be thrown off balance after two successful baits."
	icon_state = "rmbaimed"

/datum/rmb_intent/aimed/special_attack(mob/living/user, atom/target)
	if(!user)
		return
	if(user.incapacitated())
		return
	if(!ishuman(user))
		return
	if(!ishuman(target))
		return
	if(user == target)
		return

	var/mob/living/carbon/human/HT = target
	var/mob/living/carbon/human/HU = user
	var/target_zone = HT.zone_selected
	var/user_zone = HU.zone_selected

	if(HT.has_status_effect(/datum/status_effect/debuff/baited) || HU.has_status_effect(/datum/status_effect/debuff/baitcd))
		return	//We don't do anything if either of us is affected by bait statuses

	HU.visible_message(span_danger("[HU] baits an attack from [HT]!"))
	HU.apply_status_effect(/datum/status_effect/debuff/baitcd)

	var/target_in_riposte = istype(HT.rmb_intent, /datum/rmb_intent/riposte) // Special intent interaction. Aimed counters Riposte aiming chest only.

	if((target_zone == BODY_ZONE_CHEST) || (user_zone == BODY_ZONE_CHEST) && !target_in_riposte)
		to_chat(HU, span_danger("It didn't work! [HT.p_their(TRUE)] footing returned!"))
		to_chat(HT, span_notice("I fooled [HU.p_them()]! I've regained my footing!"))
		HU.emote("groan")
		HU.stamina_add(HU.max_stamina * 0.2)
		HT.bait_stacks = 0
		return
	
	var/list/body_zone_list
	if(user_zone in BODY_ZONE_LIST_HEAD)
		body_zone_list = BODY_ZONE_LIST_HEAD
	// Groin, stomach
	else if(user_zone in BODY_ZONE_LIST_CHEST_EXCLUSIVE)
		body_zone_list = BODY_ZONE_LIST_CHEST_EXCLUSIVE
	// Chest, groin, stomach + Target in Riposte intent
	else if(user_zone in BODY_ZONE_LIST_CHEST)
		if(target_in_riposte) // Special interaction with riposte intent where if your target is only sitting in that intent you can bait their chest.
			body_zone_list = BODY_ZONE_LIST_CHEST
	// Arms
	else if(user_zone in BODY_ZONE_LIST_R_ARM)
		body_zone_list = BODY_ZONE_LIST_R_ARM
	else if(user_zone in BODY_ZONE_LIST_L_ARM)
		body_zone_list = BODY_ZONE_LIST_L_ARM
	// Legs
	else if(user_zone in BODY_ZONE_LIST_R_LEG)
		body_zone_list = BODY_ZONE_LIST_R_LEG
	else if(user_zone in BODY_ZONE_LIST_L_LEG)
		body_zone_list = BODY_ZONE_LIST_L_LEG

	// Our target isn't aiming in the same zone.
	if(!(target_zone in body_zone_list))
		to_chat(HU, span_danger("It didn't work! [HT.p_their(TRUE)] footing returned!"))
		to_chat(HT, span_notice("I fooled [HU.p_them()]! I've regained my footing!"))
		HU.emote("groan")
		HU.stamina_add(HU.max_stamina * 0.2)
		HT.bait_stacks = 0
		return

	var/fatiguemod	//The heavier the target's armor, the more fatigue (green bar) we drain.
	var/targetac = HT.highest_ac_worn()
	switch(targetac)
		if(ARMOR_CLASS_NONE)
			fatiguemod = 5
		if(ARMOR_CLASS_LIGHT, ARMOR_CLASS_MEDIUM)
			fatiguemod = 4
		if(ARMOR_CLASS_HEAVY)
			fatiguemod = 3

	HT.apply_status_effect(/datum/status_effect/debuff/baited)
	HT.apply_status_effect(/datum/status_effect/debuff/exposed)
	HT.apply_status_effect(/datum/status_effect/debuff/clickcd, 5 SECONDS)
	HT.bait_stacks++
	if(HT.has_status_effect(/datum/status_effect/buff/clash))
		HT.remove_status_effect(/datum/status_effect/buff/clash)
		to_chat(user, span_notice("[HT.p_their(TRUE)] has their guard disrupted!"))
	if(HT.bait_stacks <= 1)
		// Target
		HT.Immobilize(0.5 SECONDS)
		HT.stamina_add(HT.max_stamina / fatiguemod)
		HT.Slowdown(3)
		HT.emote("huh")
		// User
		HU.purge_peel(BAIT_PEEL_REDUCTION)
		HU.changeNext_move(0.1 SECONDS, override = TRUE)
		// Chat response
		to_chat(HU, span_notice("[HT.p_they(TRUE)] fell for my bait <b>perfectly</b>! One more!"))
		to_chat(HT, span_danger("I fall for [HU.p_their()]'s bait <b>perfectly</b>! I'm losing my footing! <b>I can't let this happen again!</b>"))

	if(HU.has_duelist_ring() && HT.has_duelist_ring() || HT.bait_stacks >= 2)	//We're explicitly (hopefully non-lethally) dueling. Flavor.
		HT.emote("gasp")
		HT.Immobilize(2 SECONDS)
		HT.OffBalance(4 SECONDS)
		to_chat(HU, span_notice("[HT.p_they(TRUE)] fell for it again and is off-balanced! NOW!"))
		to_chat(HT, span_danger("I fall for [HU.p_their()] bait <b>perfectly</b>! My balance is GONE!</b>"))
		HT.bait_stacks = 0


	if(!HT.pulling)
		return

	HT.stop_pulling()
	to_chat(HU, span_notice("[HT.p_they(TRUE)] fell for my dirty trick! I am loose!"))
	to_chat(HT, span_danger("I fall for [HU.p_their()] dirty trick! My hold is broken!"))
	HU.OffBalance(2 SECONDS)
	HT.OffBalance(4 SECONDS)
	playsound(user, 'sound/combat/riposte.ogg', 100, TRUE)