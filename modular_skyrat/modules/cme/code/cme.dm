////////////////////////////////////
//CME EVENT SYSTEM
//SEE _CME_DEFINES.DM FOR SETTINGS.
////////////////////////////////////

/* Welcome to the CME control system.

This controls the CME event, or coronal mass ejection event, which causes multiple EMP bubbles to form around the station
depending on conditons and time. There are currently 4 settings of CME, all of which have settings defined in the
cme defines DM file. See that for more info

Armageddon is truly going to fuck the station, use it sparingly.
*/

/datum/round_event_control/cme
	name = "Coronal Mass Ejection: Minimal"
	typepath = /datum/round_event/cme
	weight = 0 //7
	min_players = 15
	max_occurrences = 0 //3
	earliest_start = 20 MINUTES

/datum/round_event/cme
	startWhen		= 6
	endWhen			= 66
	announceWhen	= 1
	var/cme_intensity = CME_MINIMAL
	var/cme_frequency_lower
	var/cme_frequency_upper
	var/list/cme_start_locs = list()
	var/sound/cme_sound = sound('modular_skyrat/modules/cme/sound/cme.ogg')

/datum/round_event_control/cme/random
	name = "Coronal Mass Ejection: Random"
	typepath = /datum/round_event/cme/random
	weight = 0 //7
	min_players = 15
	max_occurrences = 0 //3
	earliest_start = 20 MINUTES

/datum/round_event/cme/random
	cme_intensity = CME_RANDOM

/datum/round_event_control/cme/moderate
	name = "Coronal Mass Ejection: Moderate"
	typepath = /datum/round_event/cme/moderate
	weight = 0 //4
	min_players = 20
	max_occurrences = 0 //1
	earliest_start = 35 MINUTES

/datum/round_event/cme/moderate
	cme_intensity = CME_MODERATE

/datum/round_event_control/cme/extreme
	name = "Coronal Mass Ejection: Extreme"
	typepath = /datum/round_event/cme/extreme
	weight = 0 //1
	min_players = 25
	max_occurrences = 0 //1
	earliest_start = 45 MINUTES

/datum/round_event/cme/extreme
	cme_intensity = CME_EXTREME

/datum/round_event_control/cme/armageddon
	name = "Coronal Mass Ejection: Armageddon"
	typepath = /datum/round_event/cme/armageddon
	weight = 0
	max_occurrences = 0

/datum/round_event/cme/armageddon
	cme_intensity = CME_ARMAGEDDON

/datum/round_event/cme/setup()
	if(!cme_intensity)
		cme_intensity = pick(CME_MINIMAL, CME_MODERATE, CME_EXTREME)
	switch(cme_intensity)
		if(CME_RANDOM)
			cme_frequency_lower = CME_MODERATE_FREQUENCY_LOWER
			cme_frequency_upper = CME_MODERATE_FREQUENCY_UPPER
			startWhen = rand(CME_MODERATE_START_LOWER, CME_MODERATE_START_UPPER)
			endWhen = startWhen + CME_MODERATE_END
		if(CME_MINIMAL)
			cme_frequency_lower = CME_MINIMAL_FREQUENCY_LOWER
			cme_frequency_upper = CME_MINIMAL_FREQUENCY_UPPER
			startWhen = rand(CME_MINIMAL_START_LOWER, CME_MINIMAL_START_UPPER)
			endWhen = startWhen + CME_MINIMAL_END
		if(CME_MODERATE)
			cme_frequency_lower = CME_MODERATE_FREQUENCY_LOWER
			cme_frequency_upper = CME_MODERATE_FREQUENCY_UPPER
			startWhen = rand(CME_MODERATE_START_LOWER, CME_MODERATE_START_UPPER)
			endWhen = startWhen + CME_MODERATE_END
		if(CME_EXTREME)
			cme_frequency_lower = CME_EXTREME_FREQUENCY_LOWER
			cme_frequency_upper = CME_EXTREME_FREQUENCY_UPPER
			startWhen = rand(CME_EXTREME_START_LOWER, CME_EXTREME_START_UPPER)
			endWhen = startWhen + CME_EXTREME_END
		if(CME_ARMAGEDDON)
			cme_frequency_lower = CME_ARMAGEDDON_FREQUENCY_LOWER
			cme_frequency_upper = CME_ARMAGEDDON_FREQUENCY_UPPER
			startWhen = rand(CME_ARMAGEDDON_START_LOWER, CME_ARMAGEDDON_START_UPPER)
			endWhen = startWhen + CME_ARMAGEDDON_END
		else
			message_admins("CME setup failure, aborting.")
			kill()

	for(var/turf/open/floor/T in world)
		if(is_station_level(T.z))
			cme_start_locs += T

/datum/round_event/cme/announce(fake)
	if(fake)
		priority_announce("Critical Coronal mass ejection detected! Expected intensity: [uppertext(cme_intensity)]. Impact in: [rand(200, 300)] seconds. \
		All synthetic and non-organic lifeforms should seek shelter immediately! \
		Ensure all sensitive equipment is shielded.", "Solar Event", sound('modular_skyrat/modules/cme/sound/cme_warning.ogg'))
	else
		switch(cme_intensity)
			if(CME_RANDOM)
				priority_announce("Coronal mass ejection detected! Expected intensity: UNKNOWN. Impact in: [round((startWhen * SSevents.wait) / 10, 0.1)] seconds. \
				All synthetic and non-organic lifeforms should seek shelter immediately! \
				Ensure all sensitive equipment is shielded.", "Solar Event", sound('modular_skyrat/modules/cme/sound/cme_warning.ogg'))
			if(CME_MINIMAL)
				priority_announce("Coronal mass ejection detected! Expected intensity: [uppertext(cme_intensity)]. Impact in: [round((startWhen * SSevents.wait) / 10, 0.1)] seconds. \
				All synthetic and non-organic lifeforms should seek shelter immediately! \
				Ensure all sensitive equipment is shielded.", "Solar Event", sound('modular_skyrat/modules/cme/sound/cme_warning.ogg'))
			if(CME_MODERATE)
				priority_announce("Coronal mass ejection detected! Expected intensity: [uppertext(cme_intensity)]. Impact in: [round((startWhen * SSevents.wait) / 10, 0.1)] seconds. \
				All synthetic and non-organic lifeforms should seek shelter immediately! \
				Ensure all sensitive equipment is shielded.", "Solar Event", sound('modular_skyrat/modules/cme/sound/cme_warning.ogg'))
			if(CME_EXTREME)
				set_security_level(SEC_LEVEL_RED)
				priority_announce("Critical Coronal mass ejection detected! Expected intensity: [uppertext(cme_intensity)]. Impact in: [round((startWhen * SSevents.wait) / 10, 0.1)] seconds. \
				All synthetic and non-organic lifeforms should seek shelter immediately! \
				Ensure all sensitive equipment is shielded.", "Solar Event", sound('modular_skyrat/modules/cme/sound/cme_warning.ogg'))
			if(CME_EXTREME)
				set_security_level(SEC_LEVEL_GAMMA)
				priority_announce("Neutron Mass Ejection Detected! Expected intensity: [uppertext(cme_intensity)]. Impact in: [round((startWhen * SSevents.wait) / 10, 0.1)] seconds. \
				All personnel should proceed to their nearest warpgate for evacuation, the Solar Federation has issued this mandatory alert.", "Solar Event", sound('modular_skyrat/modules/cme/sound/cme_warning.ogg'))

/datum/round_event/cme/tick()
	if(ISMULTIPLE(activeFor, rand(cme_frequency_lower, cme_frequency_upper)))
		var/turf/spawnpoint = pick(cme_start_locs)
		spawn_cme(spawnpoint, cme_intensity)

/datum/round_event/cme/proc/spawn_cme(spawnpoint, intensity)
	if(intensity == CME_RANDOM)
		intensity = pick(CME_MINIMAL, CME_MODERATE, CME_EXTREME)
	var/area/loc_area_name = get_area(spawnpoint)
	minor_announce("WARNING! [uppertext(intensity)] PULSE EXPECTED IN: [loc_area_name.name]", "Solar Flare Log:")
	for(var/i in GLOB.mob_list)
		var/mob/M = i
		if(M.client)
			SEND_SOUND(M, sound('modular_skyrat/modules/cme/sound/cme_warning.ogg'))
			SEND_SOUND(M, cme_sound)
			shake_camera(M, 15, 1)
	switch(intensity)
		if(CME_MINIMAL)
			var/obj/effect/cme/spawnedcme = new(spawnpoint)
			announce_to_ghosts(spawnedcme)
		if(CME_MODERATE)
			var/obj/effect/cme/moderate/spawnedcme = new(spawnpoint)
			announce_to_ghosts(spawnedcme)
		if(CME_EXTREME)
			var/obj/effect/cme/extreme/spawnedcme = new(spawnpoint)
			announce_to_ghosts(spawnedcme)
		if(CME_ARMAGEDDON)
			var/obj/effect/cme/armageddon/spawnedcme = new(spawnpoint)
			announce_to_ghosts(spawnedcme)


/datum/round_event/cme/end()
	minor_announce("The station has cleared the solar flare, please proceed to repair electronic failures.", "CME cleared:")


////////////////////////
//CME bubbles
///////////////////////

/obj/effect/cme
	desc = "A solar ejection projection."
	name = "MINIMAL SOLAR EJECTION"
	icon = 'modular_skyrat/modules/cme/icons/cme_effect.dmi'
	icon_state = "cme_effect"
	color = COLOR_BLUE_LIGHT
	light_range = 5
	light_power = 2
	light_color = COLOR_BLUE_LIGHT
	pixel_x = -32
	pixel_y = -32
	anchored = TRUE
	opacity = FALSE
	density = FALSE
	CanAtmosPass = ATMOS_PASS_DENSITY
	var/timeleft = CME_MINIMAL_BUBBLE_BURST_TIME
	var/cme_light_range_lower = CME_MINIMAL_LIGHT_RANGE_LOWER
	var/cme_light_range_upper = CME_MINIMAL_LIGHT_RANGE_UPPER
	var/cme_heavy_range_lower = CME_MINIMAL_HEAVY_RANGE_LOWER
	var/cme_heavy_range_upper = CME_MINIMAL_HEAVY_RANGE_UPPER

/obj/effect/cme/moderate
	name = "MODERATE SOLAR EJECTION"
	color = COLOR_VIVID_YELLOW
	light_color = COLOR_VIVID_YELLOW
	timeleft = CME_MODERATE_BUBBLE_BURST_TIME
	cme_light_range_lower = CME_MODERATE_LIGHT_RANGE_LOWER
	cme_light_range_upper = CME_MODERATE_LIGHT_RANGE_UPPER
	cme_heavy_range_lower = CME_MODERATE_HEAVY_RANGE_LOWER
	cme_heavy_range_upper = CME_MODERATE_HEAVY_RANGE_UPPER

/obj/effect/cme/extreme
	name = "EXTREME SOLAR EJECTION"
	color = COLOR_RED
	light_color = COLOR_RED
	timeleft = CME_EXTREME_BUBBLE_BURST_TIME
	cme_light_range_lower = CME_EXTREME_LIGHT_RANGE_LOWER
	cme_light_range_upper = CME_EXTREME_LIGHT_RANGE_UPPER
	cme_heavy_range_lower = CME_EXTREME_HEAVY_RANGE_LOWER
	cme_heavy_range_upper = CME_EXTREME_HEAVY_RANGE_UPPER

/obj/effect/cme/armageddon
	name = "ARMAGEDDON SOLAR EJECTION"
	color = COLOR_VIOLET
	light_color = COLOR_VIOLET
	timeleft = CME_ARMAGEDDON_BUBBLE_BURST_TIME
	cme_light_range_lower = CME_ARMAGEDDON_LIGHT_RANGE_LOWER
	cme_light_range_upper = CME_ARMAGEDDON_LIGHT_RANGE_UPPER
	cme_heavy_range_lower = CME_ARMAGEDDON_HEAVY_RANGE_LOWER
	cme_heavy_range_upper = CME_ARMAGEDDON_HEAVY_RANGE_UPPER

/obj/effect/cme/Initialize()
	. = ..()
	addtimer(CALLBACK(src, .proc/burst), timeleft)

/obj/effect/cme/proc/burst()
	var/pulse_range_light = rand(cme_light_range_lower, cme_light_range_upper)
	var/pulse_range_heavy = rand(cme_heavy_range_lower, cme_heavy_range_upper)
	empulse(src, pulse_range_heavy, pulse_range_light)
	playsound(src,'sound/weapons/resonator_blast.ogg',100,TRUE)
	explosion(src, 0, 0, 2, flame_range = 5)
	qdel(src)

/obj/effect/cme/armageddon/burst()
	var/pulse_range_light = rand(cme_light_range_lower, cme_light_range_upper)
	var/pulse_range_heavy = rand(cme_heavy_range_lower, cme_heavy_range_upper)
	empulse(src, pulse_range_heavy, pulse_range_light)
	explosion(src, 0, 0, 10, flame_range = 10)
	playsound(src,'sound/weapons/resonator_blast.ogg',100,TRUE)
	qdel(src)

/obj/effect/cme/singularity_pull()
	return
