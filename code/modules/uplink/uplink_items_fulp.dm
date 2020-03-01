/datum/uplink_item/role_restricted/bag_of_encounters
	name = "Bag of Encounters"
	desc = "An inconspicious bag of dice, recovered from a Space Wizard's dungeon. Each dice within will summon a challenge for the crew: 1d4 Bears, 1d6 Space Carp or 1d20 angry Bees!\
			Be sure to give the bag a shake before use, so that the creatures will recognise you as their true dungeon master, no matter who rolls the dice."
	item = /obj/item/storage/pill_bottle/encounter_dice
	cost = 8
	restricted_roles = list("Curator")
	limited_stock = 1 //for testing at least


/datum/uplink_item/badass/balloongold
	name = "Golden Syndicate Balloons"
	desc = "For showing that you and two other Syndies are true genuine 100% BAD ASS SYNDIES."
	item = /obj/item/storage/box/syndieballoons
	cost = 60
	cant_discount = TRUE
	illegal_tech = FALSE

/datum/uplink_item/role_restricted/susp_bowler
	name = "Suspicious Bowler"
	desc = "A strange, deep black bowler with an extremely sharp, weighted brim. The material used to make the brim of the bowler allows for it to pierce armor, often embeding within the designated target."
	item = /obj/item/clothing/head/susp_bowler
	cost = 5
	cant_discount = FALSE
	illegal_tech = TRUE
	restricted_roles = list("Bartender")

/datum/uplink_item/role_restricted/syndicate_cigars
	name = "Suspicious Cigar Case"
	desc = "A dark black cigar case with a familiar crimson S embroidered inside the lid. Filled with five specialty cuban cigars infused with Omnizine. Enough space under the tray to hold a Sketchkin."
	item = /obj/item/storage/fancy/cigarettes/cigars/syndicate
	cost = 5
	cant_discount = FALSE
	illegal_tech = FALSE
	restricted_roles = list("Bartender")

/datum/uplink_item/role_restricted/mech_firing_pin
	name = "Concealed Weapon Bay (Mech Firing Pin Included)"
	desc = "A handy firing pin that can only be installed into mech weapons. \
			It also hides the equipped weapon from plain sight. \
			Only one can fit on a mecha. \
			This one comes complete with a handy firing pin that can only be installed into mech weapons"
	item = /obj/item/storage/box/syndicate/bundle_mech
	cost = 7 //So you cannot use it to get 3 unlocked mech weapons.
	restricted_roles = list("Roboticist", "Research Director")
