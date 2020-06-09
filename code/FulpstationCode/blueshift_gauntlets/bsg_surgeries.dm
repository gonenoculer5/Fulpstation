/*//--[BLUESHIFT GAUNTLET SURGERY]--
//--LAST MODIFIED: 6/4/2020, BY GONENOCULER5(AUTHOR)--

//--[OPERATIONS]--
/datum/surgery/bsg_organ_removal
	name = "Organ Removal"
	steps = list(
		/datum/surgery_step/bsg_locate,
		/datum/surgery_step/bsg_translocate,
		/datum/surgery_step/bsg_remove
	)
	target_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	possible_locs = list(BODY_ZONE_PRECISE_GROIN,BODY_ZONE_CHEST,BODY_ZONE_HEAD)
	requires_bodypart_type = 0
	ignore_clothes = TRUE
	var/obj/item/organ/I = null

//--[SURGERY STEPS]--
/datum/surgery_step/bsg_locate
	name = "locate"
	accept_hand = TRUE
	time = 1
	experience_given = MEDICAL_SKILL_EASY

/datum/surgery_step/bsg_locate/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='notice'>You begin to phase into [target]'s [parse_zone(target_zone)]...</span>",
		"<span class='notice'>[user] begins to phase into [target]'s [parse_zone(target_zone)]!</span>",
		"<span class='notice'>[user] begins to phase into [target]'s [parse_zone(target_zone)]!</span>")

/datum/surgery_step/bsg_locate/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/mob/living/carbon/human/L = target
	display_results(user, target, "<span class='notice'>You located [L]'s organ!.</span>",
		"<span class='notice'>[user] locates [L]'s organ!</span>",
		"<span class='notice'>[user] locates [L]'s organ!</span>")
	if(user.mind)
		user.mind.adjust_experience(/datum/skill/medical, experience_given)
	return ..()

/datum/surgery_step/bsg_translocate
	name = "translocate"
	accept_hand = TRUE
	time = 1
	experience_given = MEDICAL_SKILL_EASY

/datum/surgery_step/bsg_translocate/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/mob/living/carbon/human/L = target
	display_results(user, target, "<span class='notice'>You begin to translocate [L]'s organ...</span>",
		"<span class='notice'>[user] begins to translocate [L]'s organ!</span>",
		"<span class='notice'>[user] begins to translocate [L]'s organ!</span>")

/datum/surgery_step/bsg_translocate/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/mob/living/carbon/human/L = target
	display_results(user, target, "<span class='notice'>You translocated [L]'s organ!</span>",
		"<span class='notice'>[user] translocates [L]'s organ!</span>",
		"<span class='notice'>[user] translocates [L]'s organ!</span>")
	if(user.mind)
		user.mind.adjust_experience(/datum/skill/medical, experience_given)
	return ..()

/datum/surgery_step/bsg_remove
	name = "remove"
	accept_hand = TRUE
	time = 1
	experience_given = MEDICAL_SKILL_MEDIUM

/datum/surgery_step/bsg_remove/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/mob/living/carbon/human/I = target
	var/list/organs = target.getorganszone(target_zone)
	if(!organs.len)
		to_chat(user, "<span class='warning'>There are no removable organs in [target]'s [parse_zone(target_zone)]!</span>")
		return -1
	else
		for(var/obj/item/organ/O in organs)
			O.on_find(user)
			organs -= O
			organs[O.name] = O

		I = input("Remove which organ?", "Surgery", null, null) as null|anything in sortList(organs)
		if(I && user && target && user.Adjacent(target) && user.get_active_held_item() == tool)
			I = organs[I]
			if(!I)
				return -1
			display_results(user, target, "<span class='notice'>You begin to extract [I] from [target]'s [parse_zone(target_zone)]...</span>",
				"<span class='notice'>[user] begins to extract [I] from [target]'s [parse_zone(target_zone)].</span>",
				"<span class='notice'>[user] begins to extract something from [target]'s [parse_zone(target_zone)].</span>")
		else
			return -1

/datum/surgery_step/bsg_remove/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/mob/living/carbon/human/I = target
	if(I == target)
		display_results(user, target, "<span class='notice'>You successfully extract [I] from [target]'s [parse_zone(target_zone)].</span>",
			"<span class='notice'>[user] successfully extracts [I] from [target]'s [parse_zone(target_zone)]!</span>",
			"<span class='notice'>[user] successfully extracts something from [target]'s [parse_zone(target_zone)]!</span>")
		log_combat(user, target, "surgically removed [I.name] from", addition="INTENT: [uppertext(user.a_intent)]")
		I.Remove(target)
		I.forceMove(get_turf(target))
	else
		display_results(user, target, "<span class='warning'>You can't extract anything from [target]'s [parse_zone(target_zone)]!</span>",
			"<span class='notice'>[user] can't seem to extract anything from [target]'s [parse_zone(target_zone)]!</span>",
			"<span class='notice'>[user] can't seem to extract anything from [target]'s [parse_zone(target_zone)]!</span>")
	return 0
	if(user.mind)
		user.mind.adjust_experience(/datum/skill/medical, experience_given)
	return ..()

/datum/surgery_step/bsg_remove
	name = "remove"
	time = 1
	experience_given = MEDICAL_SKILL_MEDIUM
	repeatable = TRUE
	implements = list(/obj/item/organ = 100, /obj/item/organ_storage = 100)
	var/implements_extract = list(TOOL_HEMOSTAT = 100, TOOL_CROWBAR = 55)
	var/current_type
	var/obj/item/organ/I = null

/datum/surgery_step/bsg_remove/New()
	..()
	implements = implements + implements_extract

/datum/surgery_step/bsg_remove/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	I = null
	if(istype(tool, /obj/item/organ_storage))
		if(!tool.contents.len)
			to_chat(user, "<span class='warning'>There is nothing inside [tool]!</span>")
			return -1
		I = tool.contents[1]
		if(!isorgan(I))
			to_chat(user, "<span class='warning'>You cannot put [I] into [target]'s [parse_zone(target_zone)]!</span>")
			return -1
		tool = I
	if(isorgan(tool))
		current_type = "insert"
		I = tool
		if(target_zone != I.zone || target.getorganslot(I.slot))
			to_chat(user, "<span class='warning'>There is no room for [I] in [target]'s [parse_zone(target_zone)]!</span>")
			return -1
		var/obj/item/organ/meatslab = tool
		if(!meatslab.useable)
			to_chat(user, "<span class='warning'>[I] seems to have been chewed on, you can't use this!</span>")
			return -1
		display_results(user, target, "<span class='notice'>You begin to insert [tool] into [target]'s [parse_zone(target_zone)]...</span>",
			"<span class='notice'>[user] begins to insert [tool] into [target]'s [parse_zone(target_zone)].</span>",
			"<span class='notice'>[user] begins to insert something into [target]'s [parse_zone(target_zone)].</span>")

	else if(implement_type in implements_extract)
		current_type = "extract"
		var/list/organs = target.getorganszone(target_zone)
		if(!organs.len)
			to_chat(user, "<span class='warning'>There are no removable organs in [target]'s [parse_zone(target_zone)]!</span>")
			return -1
		else
			for(var/obj/item/organ/O in organs)
				O.on_find(user)
				organs -= O
				organs[O.name] = O

			I = input("Remove which organ?", "Surgery", null, null) as null|anything in sortList(organs)
			if(I && user && target && user.Adjacent(target) && user.get_active_held_item() == tool)
				I = organs[I]
				if(!I)
					return -1
				display_results(user, target, "<span class='notice'>You begin to extract [I] from [target]'s [parse_zone(target_zone)]...</span>",
					"<span class='notice'>[user] begins to extract [I] from [target]'s [parse_zone(target_zone)].</span>",
					"<span class='notice'>[user] begins to extract something from [target]'s [parse_zone(target_zone)].</span>")
			else
				return -1

/datum/surgery_step/bsg_remove/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results)
	if(current_type == "insert")
		if(istype(tool, /obj/item/organ_storage))
			I = tool.contents[1]
			tool.icon_state = initial(tool.icon_state)
			tool.desc = initial(tool.desc)
			tool.cut_overlays()
			tool = I
		else
			I = tool
		user.temporarilyRemoveItemFromInventory(I, TRUE)
		I.Insert(target)
		display_results(user, target, "<span class='notice'>You insert [tool] into [target]'s [parse_zone(target_zone)].</span>",
			"<span class='notice'>[user] inserts [tool] into [target]'s [parse_zone(target_zone)]!</span>",
			"<span class='notice'>[user] inserts something into [target]'s [parse_zone(target_zone)]!</span>")

	else if(current_type == "extract")
		if(I && I.owner == target)
			display_results(user, target, "<span class='notice'>You successfully extract [I] from [target]'s [parse_zone(target_zone)].</span>",
				"<span class='notice'>[user] successfully extracts [I] from [target]'s [parse_zone(target_zone)]!</span>",
				"<span class='notice'>[user] successfully extracts something from [target]'s [parse_zone(target_zone)]!</span>")
			log_combat(user, target, "surgically removed [I.name] from", addition="INTENT: [uppertext(user.a_intent)]")
			I.Remove(target)
			I.forceMove(get_turf(target))
		else
			display_results(user, target, "<span class='warning'>You can't extract anything from [target]'s [parse_zone(target_zone)]!</span>",
				"<span class='notice'>[user] can't seem to extract anything from [target]'s [parse_zone(target_zone)]!</span>",
				"<span class='notice'>[user] can't seem to extract anything from [target]'s [parse_zone(target_zone)]!</span>")
	return 0

/datum/surgery_step/bsg_replace
	name = "replace"
	implements = list()
	time = 1
	experience_given = MEDICAL_SKILL_EASY


/proc/attempt_initiate_surgery_bsg(obj/item/I, mob/living/M, mob/user)
	if(!istype(M))
		return

	var/mob/living/carbon/C
	var/obj/item/bodypart/affecting
	var/selected_zone = user.zone_selected

	if(iscarbon(M))
		C = M
		affecting = C.get_bodypart(check_zone(selected_zone))

	var/datum/surgery/current_surgery

	for(var/datum/surgery/S in M.surgeries)
		if(S.location == selected_zone)
			current_surgery = S

	if(!current_surgery)
		var/list/all_surgeries = GLOB.surgeries_list.Copy()
		var/list/available_surgeries = list()

		for(var/datum/surgery/S in all_surgeries)
			if(!S.possible_locs.Find(selected_zone))
				continue
			if(affecting)
				if(!S.requires_bodypart)
					continue
				if(S.requires_bodypart_type && affecting.status != S.requires_bodypart_type)
					continue
				if(S.requires_real_bodypart && affecting.is_pseudopart)
					continue
			else if(C && S.requires_bodypart) //mob with no limb in surgery zone when we need a limb
				continue
			if(S.lying_required && (M.mobility_flags & MOBILITY_STAND))
				continue
			if(!S.can_start(user, M))
				continue
			for(var/path in S.target_mobtypes)
				if(istype(M, path))
					available_surgeries[S.name] = S
					break

		if(!available_surgeries.len)
			return

		var/P = input("Begin which procedure?", "Surgery", null, null) as null|anything in sortList(available_surgeries)
		if(P && user && user.Adjacent(M) && (I in user))
			var/datum/surgery/S = available_surgeries[P]

			for(var/datum/surgery/other in M.surgeries)
				if(other.location == selected_zone)
					return //during the input() another surgery was started at the same location.

			//we check that the surgery is still doable after the input() wait.
			if(C)
				affecting = C.get_bodypart(check_zone(selected_zone))
			if(affecting)
				if(!S.requires_bodypart)
					return
				if(S.requires_bodypart_type && affecting.status != S.requires_bodypart_type)
					return
			else if(C && S.requires_bodypart)
				return
			if(S.lying_required && (M.mobility_flags & MOBILITY_STAND))
				return
			if(!S.can_start(user, M))
				return

			if(S.ignore_clothes || get_location_accessible(M, selected_zone))
				var/datum/surgery/procedure = new S.type(M, selected_zone, affecting)
				user.visible_message("<span class='notice'>[user] drapes [I] over [M]'s [parse_zone(selected_zone)] to prepare for surgery.</span>", \
					"<span class='notice'>You drape [I] over [M]'s [parse_zone(selected_zone)] to prepare for \an [procedure.name].</span>")

				log_combat(user, M, "operated on", null, "(OPERATION TYPE: [procedure.name]) (TARGET AREA: [selected_zone])")
			else
				to_chat(user, "<span class='warning'>You need to expose [M]'s [parse_zone(selected_zone)] first!</span>")

	else if(!current_surgery.step_in_progress)
		attempt_cancel_surgery(current_surgery, I, M, user)

	return TRUE
*/
