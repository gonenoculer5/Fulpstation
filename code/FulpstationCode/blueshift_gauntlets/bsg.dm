var/isPhased = FALSE
var/isDrapeSpawned = FALSE
var/isCauterySpawned = FALSE
var/isManipulatorSpawned = FALSE
var/bsgtrait = TRAIT_BLUESPACE_SHIFTING
//var/isEmagged = FALSE

//Action Buttons
var/datum/action/set_phase/setphase = new /datum/action/set_phase()
var/datum/action/summon_implements_drapes/summon_implements_drapes = new /datum/action/summon_implements_drapes()
var/datum/action/summon_implements_cautery/summon_implements_cautery = new /datum/action/summon_implements_cautery()
//var/datum/action/emag_effect_1 = new /datum/action/emag_effect_1()

/datum/action/set_phase //Create the button for toggling the gloves phase.
	name = "Create Bluespace Fold"
	desc = "Prepare the gauntlets and enter or leave a created bluespace fold."
	icon_icon = 'icons/mob/actions/actions_items.dmi' //placeholder
	button_icon_state = "neckchop" //placeholder

/datum/action/set_phase/Trigger(mob/user) //Toggle the gloves phase between on or off.
	user = owner
	var/sound_freq = rand(5120, 8800)
	if(owner.incapacitated())
		to_chat(owner, "<span class='warning'>You can't use [name] while you're incapacitated!</span>")
		return
	if(isPhased == FALSE)
		to_chat(owner, "<span class ='notice'>You activate the gauntlets, placing them out of phase!</span>")
		isPhased = TRUE
		owner.visible_message("[owner.name] activates their Blueshift Gauntlets with a low hum, placing their hands within the bluespace fold.")
		var/obj/item/clothing/gloves/color/latex/phantom_hand/A = new /obj/item/clothing/gloves/color/latex/phantom_hand(get_turf(src))
		user.put_in_hands(A)
		isManipulatorSpawned = TRUE
		playsound(owner,'sound/machines/synth_yes.ogg',50,TRUE, frequency = sound_freq)
	if(isManipulatorSpawned == TRUE)
		to_chat(owner, "<span class = 'warning'> You cant deactivate the gauntlets with your hands within the fold!")
	else
		to_chat(owner, "<span class ='notice'>You deactivate the gauntlets, removing them from the bluespace fold!</span>")
		isPhased = FALSE
		owner.visible_message("[owner.name] deactivates their Blueshift Gauntlets with a soft beep.")
		playsound(owner, 'sound/machines/synth_no.ogg',50,TRUE, frequency = sound_freq)
		playsound(owner,'sound/machines/beep.ogg',10,TRUE)


/datum/action/summon_implements_drapes //Create the button for summoning the holo-drapes.
	name = "Summon Implements"
	desc = "Summon a set of holographic drapes for starting operations. Limit one per user."
	icon_icon = 'icons/obj/surgery.dmi' //placeholder
	button_icon_state = "surgical_drapes" //placeholder

/datum/action/summon_implements_drapes/Trigger(mob/user) //Summon the implements and create the radial menu for doing so.
	user = owner
	if(owner.incapacitated())
		to_chat(owner, "<span class='warning'>You can't use [name] while you're incapacitated!</span>")
		return
	if(isPhased == FALSE)
		owner.visible_message("[owner.name] tries to summon a tool while the gauntlets are off with a dull beep.","<span class ='warning'>You can't use [name] while the gauntlets arent phased!</span>","You hear a beep nearby.")
		playsound(owner,'sound/machines/buzz-two.ogg',1,TRUE)
		return
	if(isDrapeSpawned == FALSE)
		var/obj/item/surgical_drapes/holographic/HD = new /obj/item/surgical_drapes/holographic(get_turf(user))
		user.put_in_active_hand(HD)
		isDrapeSpawned = TRUE
	else
		to_chat(owner, "<span class ='warning'>You cant spawn more drapes! Drop the current one to recall the hologram.")
		playsound(owner,'sound/machines/buzz-two.ogg',1,TRUE)
/datum/action/summon_implements_cautery //Create the button for summoning the holo-cautery.
	name = "Summon Implements"
	desc = "Summon a holographic cautery for stopping operations. Limit 1 per user."
	icon_icon = 'icons/obj/surgery.dmi' //placeholder
	button_icon_state = "cautery" //placeholder
/datum/action/summon_implements_cautery/Trigger(mob/user)
	user = owner
	if(owner.incapacitated())
		to_chat(owner, "<span class='warning'>You can't use [name] while you're incapacitated!</span>")
		return
	if(isPhased == FALSE)
		owner.visible_message("[owner.name] tries to summon a tool while the gauntlets are off with a dull beep.","<span class ='warning'>You can't use [name] while the gauntlets arent phased!</span>","You hear a beep nearby.")
		playsound(owner,'sound/machines/buzz-two.ogg',1,TRUE)
		return
	if(isCauterySpawned == FALSE)
		var/obj/item/cautery/augment/holographic/HC = new /obj/item/cautery/augment/holographic(get_turf(src))
		user.put_in_active_hand(HC)
		isCauterySpawned = TRUE
	else
		to_chat(owner, "<span class ='warning'>You cant spawn more cauteries! Drop the current one to recall the hologram.")
		playsound(owner,'sound/machines/buzz-two.ogg',1,TRUE)
/*/datum/action/emag_effect_1
	name = "Summon Implements - Summon a holographic cautery starting operations"
	icon_icon = 'icons/mob/actions/actions_items.dmi' //placeholder
	button_icon_state = "neckchop" //placeholder
/datum/action/emag_effect_1/Trigger(mob/user)
	user = owner
*/
//BSG Item [XEON/FULP]
/obj/item/clothing/gloves/color/latex/nitrile/blueshift/equipped(mob/user, slot)
	. = ..()
	if(!ishuman(user))
		return
	if(slot == ITEM_SLOT_GLOVES)
		ADD_TRAIT(user, bsgtrait, CLOTHING_TRAIT)
		setphase.Grant(user)
		summon_implements_drapes.Grant(user)
		summon_implements_cautery.Grant(user)

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
			summon_implements_drapes.Remove(user)
			summon_implements_cautery.Remove(user)

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
/obj/item/clothing/gloves/color/latex/nitrile/blueshift/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] grabs themselves and begins to vibrate violently out of phase with reality!</span>")
	var/mob/living/carbon/human/H = user
	addtimer(CALLBACK(user, /mob/living/carbon.proc/gib, null, null, TRUE, TRUE), 25)
	H.gib()
	return(MANUAL_SUICIDE)
/*/obj/item/clothing/gloves/color/latex/nitrile/blueshift/emag_act(mob/user)
	. = ..()
	isEmagged = TRUE
	to_chat(user, "<span class ='warning'>You emag the interface of the [src]!")
	emag_effect_1.Grant(user) //Cat got your tongue effect.
*/
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
