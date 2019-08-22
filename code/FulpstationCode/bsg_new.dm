
////I will not be a cunt and say that I wrote a majority of this, a good amount of this code is from defib.dm, modified to suit my needs for the item as its based on the
////compact defibrilator, so, thank you whoever wrote the CDFIB code. -Xeon


/obj/item/bsg
	name = "BSG Unit"
	desc = "A compact belt unit designed to carry the Blue Shift Gauntlets."
	icon = 'icons/obj/defib.dmi'
	icon_state = "defibcompact"
	item_state = "defibcompact"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	slot_flags = ITEM_SLOT_BELT
	force = 5
	throwforce = 6
	w_class = WEIGHT_CLASS_NORMAL
	actions_types = list(/datum/action/item_action/toggle_gauntlets)
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 50)

	var/on = FALSE //If the unit is equiped (1) or on the belt unit (0)
	var/phase = FALSE //If the unit is solid (0), partial phase (1) or full phase (2)
	var/phase_safe = FALSE //If the unit is emagged, phase_safe = TRUE, phase = 2
	var/powered = FALSE //If there's a cell in the belt unit with enough power to preform an operation, prevents usage if false.
	var/obj/item/twohanded/bsg
	var/obj/item/stock_parts/cell/high/cell

/obj/item/bsg/item_action_slot_check(slot, mob/user)
	if(slot == user.getBeltSlot())
		return TRUE

/datum/action/item_action/toggle_gauntlets
	name = "Toggle Gauntlets"

/obj/item/bsg/get_cell()
	return cell

/obj/item/bsg/Initialize() //starts without a cell for rnd
	. = ..()
	gauntlets = make_gauntlets()
	update_icon()
	return

/obj/item/bsg/loaded/Initialize() //starts with hicap
	. = ..()
	gauntlets = make_gauntlets()
	cell = new(src)
	update_icon()
	return

/obj/item/bsg/update_icon()
	update_power()
	//update_overlays(), going to revisit this later when i have proper textures prob
	update_charge()

/obj/item/bsg/proc/update_power()
	if(!QDELETED(cell))
		if(QDELETED(gauntlets) || cell.charge < gauntlets.operate)
			powered = FALSE
		else
			powered = TRUE
	else
		powered = FALSE

/obj/item/bsg/proc/update_charge()
	if(powered) //so it doesn't show charge if it's unpowered
		if(!QDELETED(cell))
			var/ratio = cell.charge / cell.maxcharge
			ratio = CEILING(ratio*4, 1) * 25
			add_overlay("[initial(icon_state)]-charge[ratio]")

/obj/item/twohanded/bsg
	name = "Blue-Shift Gauntlets"
	desc = "A pair of Blue-Shift Gauntlets"
	icon = 'icons/obj/defib.dmi'
	icon_state = "defibpaddles0"
	item_state = "defibpaddles0"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'

	force = 0
	throwforce = 6
	w_class = WEIGHT_CLASS_BULKY
	resistance_flags = INDESTRUCTIBLE

	