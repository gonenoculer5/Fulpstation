//implant
/obj/item/organ/cyberimp/brain/berz_chip
	name = "Berzerker Chipset"
	desc = "A specialized blackmarket Berzerker Chipset, designed to give the user improved fighting capabilities."
	implant_color = "#FFFF00"
	slot = ORGAN_SLOT_BRAIN_BERZ_CHIP
	actions_types = list(/datum/action/item_action/organ_action/toggle)

	//below is modified code for adding stun-protection, this is a slightly worse version of a CNS rebooter, but can stack.
	var/static/list/signalCache = list(
		COMSIG_LIVING_STATUS_STUN,
		COMSIG_LIVING_STATUS_KNOCKDOWN,
		COMSIG_LIVING_STATUS_IMMOBILIZE,
		COMSIG_LIVING_STATUS_PARALYZE,
	)

	var/stun_cap_amount = 30
	var/active = FALSE
	var/cooldown = FALSE
	var/stunned = FALSE

//Stun resist code from CNS rebooter (modified for my purposes), runs regardless of if the implant is on or not.
/obj/item/organ/cyberimp/brain/berz_chip/Remove(mob/living/carbon/M, special = FALSE)
	. = ..()
	UnregisterSignal(M, signalCache)

/obj/item/organ/cyberimp/brain/berz_chip/Insert()
	. = ..()
	RegisterSignal(owner, signalCache, .proc/on_signal)

/obj/item/organ/cyberimp/brain/berz_chip/proc/on_signal(datum/source, amount)
	if(!(organ_flags & ORGAN_FAILING) && amount > 0)
		addtimer(CALLBACK(src, .proc/clear_stuns), stun_cap_amount, TIMER_UNIQUE|TIMER_OVERRIDE)

/obj/item/organ/cyberimp/brain/berz_chip/proc/clear_stuns()
	if(owner || !(organ_flags & ORGAN_FAILING))
		owner.SetStun(0)
		owner.SetKnockdown(0)
		owner.SetImmobilized(0)
		owner.SetParalyzed(0)

/obj/item/organ/cyberimp/brain/berz_chip/emp_act(severity)
	. = ..()
	if((organ_flags & ORGAN_FAILING) || . & EMP_PROTECT_SELF)
		return
	organ_flags |= ORGAN_FAILING
	addtimer(CALLBACK(src, .proc/reboot), 90 / severity)

/obj/item/organ/cyberimp/brain/berz_chip/proc/reboot()
	organ_flags &= ~ORGAN_FAILING

//item command
/obj/item/organ/cyberimp/brain/berz_chip/ui_action_click()
	active = !active
	if(cooldown == FALSE) //Are we on cooldown? If so, skip, if not, continue
		active = TRUE //Turn the implant status to on
		to_chat(owner, "<span class='warning'> You activate your Berzerker Chipset! </span>")
		to_chat(owner, "<span class='notice'>You feel invulnerable!</span>")
		owner.set_resting(FALSE) //Stand up
		owner.reagents.add_reagent(/datum/reagent/medicine/stimulants, 5) //Ready to fight
		cooldown = TRUE
		addtimer(CALLBACK(src, .proc/do_stamina),500)
	else //Device is on cooldown
		to_chat(owner, "<span class = 'warning'> The Berzerker Chipset is on cooldown still! </span>")

/obj/item/organ/cyberimp/brain/berz_chip/proc/do_stamina()
	to_chat(owner, "<span class ='userdanger'> Your muscles burn angrily, causing you to drop!")
	//stunned = TRUE
	//while(stunned == TRUE)
	owner.adjustStaminaLoss(370)
		//sleep(100)
	addtimer(CALLBACK(src, .proc/do_cooldown), 120)
/obj/item/organ/cyberimp/brain/berz_chip/proc/do_cooldown()
	stunned = FALSE
	active = FALSE

//autosurgeon
obj/item/autosurgeon/berz_chip
	starting_organ = /obj/item/organ/cyberimp/brain/berz_chip

