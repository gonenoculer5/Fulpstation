//--[BSG SURGERY TOOLS]--
/obj/item/clothing/gloves/color/latex/phantom_hand
	name = "phased manipulators"
	desc = "Your fingers, immaterial!"
	icon_state = "latex"
	item_state = "latex"
	w_class = WEIGHT_CLASS_TINY
	attack_verb = list("groped","phased","warped")
	toolspeed = 0.5
	item_flags = ABSTRACT | DROPDEL

/obj/item/clothing/gloves/color/latex/phantom_hand/dropped(mob/user, silent)
	. = ..()
	if(isPhased == TRUE)
		isPhased = FALSE
		qdel(src)

/obj/item/clothing/gloves/color/latex/phantom_hand/attack_self(mob/user)
	. = ..()
	if(implements.len)
		for(var/H in implements)
			qdel(H)
			to_chat(user, "<span class ='notice'>You clear all holographic implements.</span>")

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
	item_flags = ABSTRACT | DROPDEL

/obj/item/surgical_drapes/holographic/dropped(mob/user, silent)
	. = ..()
	if(isDrapeSpawned == TRUE)
		isDrapeSpawned = FALSE
		qdel(src)

/obj/item/cautery/augment/holographic
	name = "holographic cautery"
	desc = "A holographic cauterization targeter that designates where a wound will be cauterized by the Blueshift Gauntlets. Disappears when dropped."
	toolspeed = 0.1
	item_flags = ABSTRACT | DROPDEL

/obj/item/cautery/augment/holographic/dropped(mob/user, silent)
	. = ..()
	if(isCauterySpawned == TRUE)
		isCauterySpawned = FALSE
		qdel(src)
