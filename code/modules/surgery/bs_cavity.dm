/datum/surgery/bs_cavity
	name = "BS Glove Cavity Implant"
	steps = list(/datum/surgery_step/phasein, /datum/surgery_step/handle_cavity, /datum/surgery_step/phaseout)
	target_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	possible_locs = list(BODY_ZONE_CHEST)
	ignore_clothes = TRUE
	can_cancel = FALSE
	self_operable = TRUE


//handle cavity
/datum/surgery_step/handle_cavity
	name = "BS Implant item"
	accept_hand = 1
	implements = list(/obj/item = 100)
	repeatable = TRUE
	time = 20
	var/obj/item/IC = null

/datum/surgery_step/handle_cavity/tool_check(mob/user, obj/item/tool)
	if(istype(tool, /obj/item/cautery) || istype(tool, /obj/item/gun/energy/laser))
		return FALSE
	return !tool.is_hot()

/datum/surgery_step/handle_cavity/preop(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/bodypart/chest/CH = target.get_bodypart(BODY_ZONE_CHEST)
	IC = CH.cavity_item
	if(tool)
		display_results(user, target, "<span class='notice'>You begin to phase [tool] into [target]'s [target_zone]...</span>",
			"[user] begins to phase [tool] into [target]'s [target_zone].",
			"[user] begins to phase [tool.w_class > WEIGHT_CLASS_SMALL ? tool : "something"] into [target]'s [target_zone].")
	else
		display_results(user, target, "<span class='notice'>You check for items in [target]'s [target_zone]...</span>",
			"[user] checks for items in [target]'s [target_zone].",
			"[user] looks for something in [target]'s [target_zone].")

/datum/surgery_step/handle_cavity/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/bodypart/chest/CH = target.get_bodypart(BODY_ZONE_CHEST)
	if(tool)
		if(IC || tool.w_class > WEIGHT_CLASS_NORMAL || HAS_TRAIT(tool, TRAIT_NODROP) || istype(tool, /obj/item/organ))
			to_chat(user, "<span class='warning'>You can't seem to phase [tool] in [target]'s [target_zone]!</span>")
			return 0
		else
			display_results(user, target, "<span class='notice'>You phase [tool] into [target]'s [target_zone].</span>",
				"[user] phases [tool] into [target]'s [target_zone]!",
				"[user] phases [tool.w_class > WEIGHT_CLASS_SMALL ? tool : "something"] into [target]'s [target_zone].")
			user.transferItemToLoc(tool, target, TRUE)
			CH.cavity_item = tool
			return 1
	else
		if(IC)
			display_results(user, target, "<span class='notice'>You phase [IC] out of [target]'s [target_zone].</span>",
				"[user] phases [IC] out of [target]'s [target_zone]!",
				"[user] phases [IC.w_class > WEIGHT_CLASS_SMALL ? IC : "something"] out of [target]'s [target_zone].")
			user.put_in_hands(IC)
			CH.cavity_item = null
			return 1
		else
			to_chat(user, "<span class='warning'>You don't find anything in [target]'s [target_zone].</span>")
			return 0
