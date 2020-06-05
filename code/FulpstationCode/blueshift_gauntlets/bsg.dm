#define MARTIALART_BLUESPACE_SHIFTING "bluespace shifting"

var/isPhased = FALSE
var/currentSurgery = 1

/datum/martial_art/bluespace_shifting
	name = "Bluespace Shifting"
	id = MARTIALART_BLUESPACE_SHIFTING
	var/datum/action/set_phase/setphase = new/datum/action/set_phase()

/datum/action/set_phase //Toggle the gloves phase between on or off.
	name = "Change Phase - Ready or disable the gloves phase changer."
	icon_icon = 'icons/mob/actions/actions_items.dmi' //placeholder
	button_icon_state = "neckchop" //placeholder

/datum/action/set_phase/Trigger()
	if(owner.incapacitated())
		to_chat(owner, "<span class='warning'>You can't use [name] while you're incapacitated.</span>")
		return
	if(isPhased == FALSE)
		to_chat(owner, "<span class ='notice'>You activate the gauntlets, preparing them to phase!</span>")
		isPhased = TRUE
		owner.visible_message("[owner.name] activates their Blueshift Gauntlets with a low hum.")
	else
		to_chat(owner, "<span class ='notice'>You deactivate the gauntlets, removing them from the bluespace fold!</span>")
		isPhased = FALSE
		owner.visible_message("[owner.name] deactivates their Blueshift Gauntlets with a beep.")

/datum/martial_art/bluespace_shifting/teach(mob/living/carbon/human/H,make_temporary=0)
	if(..())
		to_chat(H, "<span class='userdanger'>You know the art of [name]!</span>")
		to_chat(H, "<span class='danger'>Place your cursor over an action at the top of the screen to see what it does.</span>")
		setphase.Grant(H)

/datum/martial_art/bluespace_shifting/on_remove(mob/living/carbon/human/H)
	to_chat(H, "<span class='userdanger'>You suddenly forget the art of [name]...</span>")
	//setphase.Remove(H)


//BSG Item [XEON/FULP]

/obj/item/clothing/gloves/color/latex/blueshift
	var/datum/martial_art/bluespace_shifting/style = new

/obj/item/clothing/gloves/color/latex/blueshift/equipped(mob/user, slot)
	. = ..()
	if(!ishuman(user))
		return
	if(slot == ITEM_SLOT_GLOVES)
		var/mob/living/carbon/human/H = user
		style.teach(H,1)

/obj/item/clothing/gloves/color/latex/blueshift/dropped(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.get_item_by_slot(ITEM_SLOT_GLOVES) == src)
		style.remove(H)

/obj/item/clothing/gloves/color/latex/blueshift/medical
	name = "Blueshift Gauntlets"
	desc = "A technological and medical marvel capable of phasing the users hands and held objects out of and back into this plane of reality using bluespace folds. Teaches the user basic paramedic knowledge using integrated nanochip tech."
	icon_state = "latex"
	item_state = "latex"
	siemens_coefficient = 0.3 //How insulated is this item? (insulation)
	permeability_coefficient = 0.01 //How permeable is this item? (sterility)
	transfer_prints = TRUE //Does this transfer finger prints?
 //resistances
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE
