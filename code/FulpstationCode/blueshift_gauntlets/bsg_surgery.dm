//--[BSG SURGERY TOOLS]--
/obj/item/clothing/gloves/color/latex/phantom_hand
	name = "phased manipulators"
	desc = "Your fingers, immaterial!"
	icon_state = "latex"
	item_state = "latex"
	w_class = WEIGHT_CLASS_TINY
	attack_verb = list("groped","phased","warped")
	toolspeed = 0.5

/obj/item/clothing/gloves/color/latex/phantom_hand/dropped(mob/user, silent)
	. = ..()
	if(isPhased == TRUE)
		isPhased = FALSE
		qdel(src)

/obj/item/surgical_drapes/holographic
	name = "holographic drapes"
	desc = "Holographic surgery drapes created by the Blueshift Gauntlets for designating the phase area. Disappears when dropped."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "surgical_drapes"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	item_state = "drapes"
	w_class = WEIGHT_CLASS_TINY
	attack_verb = list("slapped")

/obj/item/surgical_drapes/holographic/dropped(mob/user, silent)
	. = ..()
	if(isDrapeSpawned == TRUE)
		isDrapeSpawned = FALSE
		qdel(src)

/obj/item/cautery/augment/holographic
	name = "holographic cautery"
	desc = "A holographic cauterization targeter that designates where a wound will be cauterized by the Blueshift Gauntlets. Disappears when dropped."
	toolspeed = 0.1

/obj/item/cautery/augment/holographic/dropped(mob/user, silent)
	. = ..()
	if(isCauterySpawned == TRUE)
		isCauterySpawned = FALSE
		qdel(src)



proc/selectimplement(owner)
	var/zone
	var/obj/item/holder = null
	var/choicea = /obj/item/surgical_drapes/holographic
	var/choiceb = /obj/item/cautery/augment/holographic
	var/list/choices = list("Holographic Drapes", "Holographic Cautery")
	var/P = input(owner, "Summon what implement?","Implements", null) as null|anything in sortList(choices)
	to_chat(owner,"<span class ='danger'>bruh, [owner] is the user, and [P] is their choice!</span>")
	var/mob/living/carbon/A = owner
	var/side = zone == BODY_ZONE_R_ARM? RIGHT_HANDS : LEFT_HANDS
	var/hand = A.get_empty_held_index_for_side(side)
	if(hand)
		A.put_in_hand(holder, hand)
	else
		var/list/hand_items = A.get_held_items_for_side(side, all = TRUE)
		var/success = FALSE
		var/list/failure_message = list()
		holder = P
		for(var/i in 1 to hand_items.len) //Can't just use *in* here.
			var/I = hand_items[i]
			if(!A.dropItemToGround(I))
				failure_message += "<span class='warning'>Your [I] interferes with [holder]!</span>"
				continue
			to_chat(owner, "<span class='notice'>You drop [I] to create the [holder]!</span>")
			success = A.put_in_hand(owner, A.get_empty_held_index_for_side(side))
			break
		if(!success)
			for(var/i in failure_message)
				to_chat(owner, i)
			return
