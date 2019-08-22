/*/datum/surgery/bs_cavity
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

/*//blue-shift steps [XEON]
/datum/surgery_step/phasein //Phase into chest
	name = "BS Phase In"
	implements = list(/obj/item/clothing/gloves/color/latex/blueshift = 100)
	time = 15

/datum/surgery_step/phasein/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='notice'>You begin to phase into [target]'s [parse_zone(target_zone)]...</span>",
		"[user] begins to phase into [target]'s [parse_zone(target_zone)].",
		"[user] begins to phase into [target]'s [parse_zone(target_zone)].")

/datum/surgery_step/phasein/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='notice'>You phase into [target]'s [parse_zone(target_zone)].</span>",
		"[user] phases into [target]'s [parse_zone(target_zone)]!",
		"[user] phases into [target]'s [parse_zone(target_zone)]!")
	
/datum/surgery_step/phaseout //Phase out of chest
	name = "BS Phase Out"
	implements = list(/obj/item/clothing/gloves/color/latex/blueshift = 100)
	time = 15

/datum/surgery_step/phaseout/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='notice'>You begin to phase out of [target]'s [parse_zone(target_zone)]...</span>",
		"[user] begins to phase out of [target]'s [parse_zone(target_zone)].",
		"[user] begins to phase out of [target]'s [parse_zone(target_zone)].")

/datum/surgery_step/phaseout/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='notice'>You phase out of [target]'s [parse_zone(target_zone)].</span>",
		"[user] phases out of [target]'s [parse_zone(target_zone)]!",
		"[user] phases out of [target]'s [parse_zone(target_zone)]!")
*/

/obj/item/clothing/gloves/color/latex/blueshift //Blueshift gloves (item) [XEON]
	name = "Blueshift Gloves"
	desc = "A pair of unique gloves that manipulate a local blue-space fold in order to temporarily shift the wearers hands and any held objects out of the normal plane, into a localized pocket of blue-space, to allow for implantation of objects or removal of them, in order to speed along surgery."
	icon_state = "latex"
	item_state = "lgloves"
	item_color = "mime"
	transfer_prints = FALSE
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)
	resistance_flags = NONE
	siemens_coefficient = 0.05
	permeability_coefficient = 0.01
	var/phase = 0
	var/phasesafe = 0


/obj/item/clothing/gloves/color/latex/blueshift/screwdriver_act(mob/living/user, obj/item/I) //Blueshift gloves (phasing mechanic) [XEON]

	switch(phase)
		if(0)
			to_chat(user, "<span class='notice'>The gloves materialize, becomming solid.</span>")
			phase = 1
		if(1)
			to_chat(user, "<span class='notice'>The gloves become translucent, partially phasing.</span>")
			phase = 0
			
/*/obj/item/clothing/gloves/color/latex/blueshift/verb/swap(mob/living/user, obj/item/I)
	set category = "Object"
	set name = "Change mode"
	set src in usr
	if(!isliving(usr))
		return
	if(!can_use(usr))
		return*/

/obj/item/clothing/gloves/color/latex/blueshift/emag_act(mob/user as mob) //Blue-shift gloves, emag setting [XEON]
	switch(phasesafe)
		if(0)
			phasesafe = 1
			phase = 3
			to_chat(user, "<span class='warning'>You use the cryptographic sequencer on the [src]'s interface, causing it to flicker strangely.</span>")
		if(1)
			phasesafe = 0
			phase = 1
			to_chat(user, "<span class='warning'>You use the cryptographic sequencer on the [src]'s interface, reverting it to normal. They seem to solidify.</span>")

/obj/item/clothing/gloves/color/latex/blueshift/suicide_act(mob/user) //Commiting suicide with the gloves [XEON]
	user.visible_message("<span class='suicide'>[user] is phasing [user.p_their()] [pick("soul", "spirit", "ghost")] out of their body with the [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	user.gib()
	return
	
/*/obj/item/clothing/gloves/color/latex/blueshift/attack(mob/living/M, mob/user)
	if(!attempt_initiate_surgery(src, M, user))
		..()*/*/
