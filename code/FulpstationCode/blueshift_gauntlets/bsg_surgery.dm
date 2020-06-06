//--[BSG SURGERY TOOLS]--
/obj/item/clothing/gloves/color/latex/phantom_hand
	name = "phased manipulators"
	desc = "Your fingers, immaterial!"
	icon_state = "latex"
	item_state = "latex"
	w_class = WEIGHT_CLASS_TINY
	attack_verb = list("groped","phased","warped")
	toolspeed = 0.5

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

/obj/item/cautery/augment/holographic
	name = "holographic cautery"
	desc = "A holographic cauterization targeter that designates where a wound will be cauterized by the Blueshift Gauntlets. Disappears when dropped."
	toolspeed = 0.1
