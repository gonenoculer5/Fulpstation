var/isPhased = FALSE
var/isImplementSpawned = FALSE
var/isDrapeSpawned = FALSE
var/isCauterySpawned = FALSE
var/bsgtrait = TRAIT_BLUESPACE_SHIFTING

//Action Buttons
var/datum/action/set_phase/setphase = new/datum/action/set_phase()
var/datum/action/summon_implements/summon_implements = new/datum/action/summon_implements()

/datum/action/set_phase //Create the button for toggling the gloves phase.
	name = "Change Phase - Enable or disable the gloves phasing device"
	icon_icon = 'icons/mob/actions/actions_items.dmi' //placeholder
	button_icon_state = "neckchop" //placeholder

/datum/action/set_phase/Trigger() //Toggle the gloves phase between on or off.
	if(owner.incapacitated())
		to_chat(owner, "<span class='warning'>You can't use [name] while you're incapacitated!</span>")
		return
	if(isPhased == FALSE)
		to_chat(owner, "<span class ='notice'>You activate the gauntlets, preparing them to phase!</span>")
		isPhased = TRUE
		owner.visible_message("[owner.name] activates their Blueshift Gauntlets with a low hum.")
	else
		to_chat(owner, "<span class ='notice'>You deactivate the gauntlets, removing them from the bluespace fold!</span>")
		isPhased = FALSE
		owner.visible_message("[owner.name] deactivates their Blueshift Gauntlets with a soft beep.")
		playsound(owner,'sound/machines/beep.ogg',1,TRUE)

/datum/action/summon_implements //Create the button for summoning the holographic implements.
	name = "Summon Implements - Summon a holographic cautery or set of drapes for starting operations"
	icon_icon = 'icons/mob/actions/actions_items.dmi' //placeholder
	button_icon_state = "neckchop" //placeholder

/datum/action/summon_implements/Trigger(mob/living/user) //Summon the implements and create the radial menu for doing so.
	if(owner.incapacitated())
		to_chat(owner, "<span class='warning'>You can't use [name] while you're incapacitated!</span>")
		return
	if(isPhased == FALSE)
		owner.visible_message("[owner.name] tries to summon a tool while the gauntlets are off with a dull beep.","<span class ='warning'>You can't use [name] while the gauntlets arent phased!</span>","You hear a beep nearby.")
		playsound(owner,'sound/machines/buzz-two.ogg',1,TRUE)
		return
	if(isImplementSpawned)
		return
	var/choice = input(user,"Implements:", "Choose Implement",null) as null|anything in list("Holographic Drapes", "Holographic Cautery")
	if(!choice)
		return
	switch(choice)
		if("Holographic Drapes")
			var/obj/item/surgical_drapes/holographic/HD = new /obj/item/surgical_drapes/holographic(get_turf(src))
			user.put_in_active_hand(HD)
			isImplementSpawned = TRUE
			isDrapeSpawned = TRUE
		if("Holographic Cautery")
			var/obj/item/cautery/augment/holographic/HC = new /obj/item/cautery/augment/holographic(get_turf(src))
			user.put_in_active_hand(HC)

//BSG Item [XEON/FULP]
/obj/item/clothing/gloves/color/latex/nitrile/blueshift/equipped(mob/user, slot)
	. = ..()
	if(!ishuman(user))
		return
	if(slot == ITEM_SLOT_GLOVES)
		ADD_TRAIT(user, bsgtrait, CLOTHING_TRAIT)
		setphase.Grant(user)
		summon_implements.Grant(user)

/obj/item/clothing/gloves/color/latex/nitrile/blueshift/dropped(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	if(isPhased == TRUE)
		if(user.get_item_by_slot(ITEM_SLOT_GLOVES) == src)
			isPhased = FALSE
			to_chat(user, "<span class = 'notice'> You deactivate the gauntlets before removing them with a soft beep.")
			user.visible_message("[user.name] deactivates their Blueshift Gauntlets with a beep.")
			playsound(user,'sound/machines/beep.ogg',1,TRUE)
			REMOVE_TRAIT(user, bsgtrait, CLOTHING_TRAIT)
			setphase.Remove(user)
			summon_implements.Remove(user)

/obj/item/clothing/gloves/color/latex/nitrile/blueshift
	name = "Blueshift Gauntlets"
	desc = "A technological and medical marvel capable of phasing the users hands and held objects out of and back into this plane of reality using bluespace folds. Teaches the user intermediate paramedic knowledge using integrated nanochip tech."
	icon_state = "latex"
	item_state = "latex"
	siemens_coefficient = 0.3 //How insulated is this item? (insulation)
	permeability_coefficient = 0.01 //How permeable is this item? (sterility)
	transfer_prints = TRUE //Does this transfer finger prints?
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE

//TECHWEB HANDLING
/datum/design/bs_gauntlet
	name = "Blueshift Gauntlets"
	desc = "A "
	id = "bs_gauntlet"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 500, /datum/material/glass = 250, /datum/material/gold = 250, /datum/material/diamond = 500, /datum/material/bluespace = 1000, /datum/material/plastic = 500)
	build_path = /obj/item/clothing/gloves/color/latex/nitrile/blueshift
	category = list("Medical Designs")
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/techweb_node/bluespace_folding
	id = "bs_folding"
	starting_node = FALSE
	display_name = "Bluespace Folding"
	description = "At what point must we ask, are we concerned with what we can do, or what we should do?"
	design_ids = list("bs_gauntlet")
	prereq_ids = list("bluespace_storage","exp_surgery","adv_biotech","exp_tools")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 10000)
	export_price = 5000
