/obj/item/storage/fancy/cigarettes/cigars/syndicate
	name = "\improper suspicious cigar case"
	desc = "A case of cigars imported from Space Cuba. Extraordinarily expensive. Something feels off about the weight.."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cohibacase"
	w_class = WEIGHT_CLASS_NORMAL
	icon_type = "premium cigar"
	spawn_type = /obj/item/clothing/mask/cigarette/cigar/syndicate

/obj/item/clothing/mask/cigarette/cigar/syndicate
	name = "\improper suspicious black cigar"
	desc = "A cigar for the established gentlemen, luxiriously expensive and proper, imported from Space Cuba, stuffed to the brim with high potency nicotine and omnizine. Lasts 20 minutes!"
	icon_state = "cigar2off"
	icon_on = "cigar2on"
	icon_off = "cigar2off"
	smoketime = 600 // 20 minutes
	chem_volume = 100
	list_reagents =list(/datum/reagent/drug/nicotine = 40, /datum/reagent/medicine/omnizine = 25)

/obj/item/storage/fancy/cigarettes/cigars/syndicate/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 6
	STR.set_holdable(list(/obj/item/clothing/mask/cigarette/cigar/syndicate,/obj/item/gun/ballistic/automatic/pistol))
