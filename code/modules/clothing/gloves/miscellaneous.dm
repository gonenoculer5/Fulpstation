
/obj/item/clothing/gloves/fingerless
	name = "fingerless gloves"
	desc = "Plain black gloves without fingertips for the hard working."
	icon_state = "fingerless"
	item_state = "fingerless"
	item_color = null	//So they don't wash.
	transfer_prints = TRUE
	strip_delay = 40
	equip_delay_other = 20
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	custom_price = 10

/obj/item/clothing/gloves/botanic_leather
	name = "botanist's leather gloves"
	desc = "These leather gloves protect against thorns, barbs, prickles, spikes and other harmful objects of floral origin.  They're also quite warm."
	icon_state = "leather"
	item_state = "ggloves"
	permeability_coefficient = 0.9
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 70, "acid" = 30)

/obj/item/clothing/gloves/combat
	name = "combat gloves"
	desc = "These tactical gloves are fireproof and shock resistant."
	icon_state = "black"
	item_state = "blackgloves"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	strip_delay = 80
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 80, "acid" = 50)

/obj/item/clothing/gloves/bracer
	name = "bone bracers"
	desc = "For when you're expecting to get slapped on the wrist. Offers modest protection to your arms."
	icon_state = "bracers"
	item_state = "bracers"
	item_color = null	//So they don't wash.
	transfer_prints = TRUE
	strip_delay = 40
	equip_delay_other = 20
	body_parts_covered = ARMS
	cold_protection = ARMS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE
	armor = list("melee" = 15, "bullet" = 25, "laser" = 15, "energy" = 15, "bomb" = 20, "bio" = 10, "rad" = 0, "fire" = 0, "acid" = 0)

/obj/item/clothing/gloves/rapid
	name = "Gloves of the North Star"
	desc = "Just looking at these fills you with an urge to beat the shit out of people."
	icon_state = "rapid"
	item_state = "rapid"
	transfer_prints = TRUE
	var/warcry = "AT"

/obj/item/clothing/gloves/rapid/Touch(mob/living/target,proximity = TRUE)
	var/mob/living/M = loc

	if(M.a_intent == INTENT_HARM)
		M.changeNext_move(CLICK_CD_RAPID)
		if(warcry)
			M.say("[warcry]", ignore_spam = TRUE, forced = "north star warcry")
	.= FALSE

/obj/item/clothing/gloves/rapid/attack_self(mob/user)
	var/input = stripped_input(user,"What do you want your battlecry to be? Max length of 6 characters.", ,"", 7)
	if(input)
		warcry = input

/obj/item/clothing/gloves/color/latex/blueshift //Blueshift gloves (item) [XEON]
	name = "Blueshift Gloves"
	desc = "A pair of unique gloves that manipulate a local blue-space fold in order to temporarily shift the wearers hands and any held objects out of the normal plane, into a localized pocket of blue-space, to allow for implantation of objects or removal of them, in order to speed along surgery."
	icon_state = "latex"
	item_state = "lgloves"
	item_color = "mime"
	transfer_prints = FALSE
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)
	resistance_flags = NONE
	siemens_coefficient = 0.05
	permeability_coefficient = 0.01
	var/phase = 0
	var/phasesafe = 0


/obj/item/clothing/gloves/color/latex/blueshift/screwdriver_act(mob/living/user, obj/item/I) //Blueshift gloves (phasing mechanic) [XEON]

	switch(phase)
		if(0)
			to_chat(user, "<span class='notice'>The gloves materialize, becomming solid.</span>")
			phase = 1
		if(1)
			to_chat(user, "<span class='notice'>The gloves become translucent, partially phasing.</span>")
			phase = 0
			
/*/obj/item/clothing/gloves/color/latex/blueshift/verb/swap(mob/living/user, obj/item/I)
	set category = "Object"
	set name = "Change mode"
	set src in usr
	if(!isliving(usr))
		return
	if(!can_use(usr))
		return*/

/obj/item/clothing/gloves/color/latex/blueshift/emag_act(mob/user as mob) //Blue-shift gloves, emag setting [XEON]
	switch(phasesafe)
		if(0)
			phasesafe = 1
			phase = 3
			to_chat(user, "<span class='warning'>You use the cryptographic sequencer on the [src]'s interface, causing it to flicker strangely.</span>")
		if(1)
			phasesafe = 0
			phase = 1
			to_chat(user, "<span class='warning'>You use the cryptographic sequencer on the [src]'s interface, reverting it to normal. They seem to solidify.</span>")

/obj/item/clothing/gloves/color/latex/blueshift/suicide_act(mob/user) //Commiting suicide with the gloves [XEON]
	user.visible_message("<span class='suicide'>[user] is phasing [user.p_their()] [pick("brain", "heart", "lungs")] out of their body with [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return (BRUTELOSS)
