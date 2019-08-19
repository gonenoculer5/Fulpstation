	//EMT "hard"suit helm [FULP] [XEON]
/obj/item/clothing/head/helmet/space/hardsuit/medical/emt
	name = "emergency medical hardsuit helmet"
	desc = "A special suit designed for work in a hazardous, low pressure enviroment. It appears to offer some protection from bio-hazards and good protection against heat, but is very weak to any kind of attack."
	icon_state = "hardsuit0-medical"
	item_state = "medical_helm"
	item_color = "medical"
	flash_protect = 0
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 80, "rad" = 0, "fire" = 95, "acid" = 0)
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL | SCAN_REAGENTS

	//EMT "hard"suit [FULP] [XEON]
/obj/item/clothing/suit/space/hardsuit/medical/emt
	name = "emergency medical hardsuit helmet"
	desc = "A special suit designed for work in a hazardous, low pressure enviroment. It appears to offer some protection from bio-hazards and good protection against heat, but is very weak to any kind of attack."
	icon_state = "hardsuit-medical"
	item_state = "medical_hardsuit"
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/storage/firstaid, /obj/item/healthanalyzer, /obj/item/stack/medical)
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 80, "rad" = 0, "fire" = 95, "acid" = 0)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/medical/emt
	slowdown = 0.2

/obj/item/clothing/under/rank/medical/emt //EMT suit and skirt
	name = "emergency medical technician's jumpsuit"
	desc = "It's made of a special fiber that provides minor protection against biohazards. It has a stripe denoting that the wearer is an emergency medical technician."
	icon_state = "medical"
	item_state = "w_suit"
	item_color = "medical"
	permeability_coefficient = 0.5
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 30, "rad" = 0, "fire" = 25, "acid" = 0)
	body_parts_covered = CHEST|GROIN|ARMS
	can_adjust = FALSE

/obj/item/clothing/under/rank/medical/emt/skirt
	name = "emergency medical technician's jumpskirt"
	desc = "It's made of a special fiber that provides minor protection against biohazards. It has a stripe denoting that the wearer is an emergency medical technician."
	icon_state = "medical_skirt"
	item_state = "w_suit"
	item_color = "medical_skirt"
	fitted = FEMALE_UNIFORM_TOP

/obj/item/storage/belt/medical_emt //[FULP] [XEON] EMT belt
	name = "emt belt"
	desc = "Can hold various emergency medical equipment"
	icon_state = "medicalbelt"
	item_state = "medical"

/obj/item/storage/belt/medical_emt/ComponentInitialize() //[FULP] [XEON] EMT belt storage
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.set_holdable(list(
		/obj/item/healthanalyzer,
		/obj/item/dnainjector,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/glass/beaker,
		/obj/item/reagent_containers/glass/bottle,
		/obj/item/reagent_containers/pill,
		/obj/item/reagent_containers/syringe,
		/obj/item/reagent_containers/medigel,
		/obj/item/lighter,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/storage/pill_bottle,
		/obj/item/stack/medical,
		/obj/item/flashlight/pen,
		/obj/item/extinguisher/mini,
		/obj/item/reagent_containers/hypospray,
		/obj/item/sensor_device,
		/obj/item/radio,
		/obj/item/clothing/gloves/,
		/obj/item/lazarus_injector,
		/obj/item/bikehorn/rubberducky,
		/obj/item/clothing/mask/surgical,
		/obj/item/clothing/mask/breath,
		/obj/item/clothing/mask/breath/medical,
		/obj/item/surgical_drapes,
		/obj/item/scalpel,
		/obj/item/circular_saw,
		/obj/item/surgicaldrill,
		/obj/item/retractor,
		/obj/item/cautery,
		/obj/item/hemostat,
		/obj/item/geiger_counter,
		/obj/item/clothing/neck/stethoscope,
		/obj/item/stamp,
		/obj/item/clothing/glasses,
		/obj/item/wrench/medical,
		/obj/item/clothing/mask/muzzle,
		/obj/item/storage/bag/chemistry,
		/obj/item/storage/bag/bio,
		/obj/item/reagent_containers/blood,
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/gun/syringe/syndicate,
		/obj/item/implantcase,
		/obj/item/implant,
		/obj/item/implanter,
		/obj/item/pinpointer/crew,
		/obj/item/holosign_creator/medical
	))
