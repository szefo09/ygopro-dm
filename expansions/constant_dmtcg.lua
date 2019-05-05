--[[
	constant_dmtcg.lua

	Usage: Put this file in the expansions folder

	Include the following code in your script: local DMTCG=require "expansions.constant_dmtcg"
]]

local DMTCG={}

--Card ID
--↑Support
CARD_OBSIDIAN_SCARAB				=24005005	--"Obsidian Scarab" (DM-05 5/55)
CARD_AMBUSH_SCORPION				=24005046	--"Ambush Scorpion" (DM-05 46/55)
CARD_SOLAR_GRASS					=24008014	--"Solar Grass" (DM-08 14/55)
CARD_KALUTE_VIZIER_OF_ETERNITY		=24009010	--"Kalute, Vizier of Eternity" (DM-09 10/55)
CARD_WHISPERING_TOTEM				=24009055	--"Whispering Totem" (DM-09 55/55)
CARD_CLONED_DEFLECTOR				=24012022	--"Cloned Deflector" (DM-12 22/55)
CARD_CLONED_SPIRAL					=24012023	--"Cloned Spiral" (DM-12 23/55)
CARD_CLONED_NIGHTMARE				=24012026	--"Cloned Nightmare" (DM-12 26/55)
CARD_CLONED_BLADE					=24012028	--"Cloned Blade" (DM-12 28/55)
CARD_CLONED_SPIKEHORN				=24012030	--"Cloned Spike-Horn" (DM-12 30/55)
--↑EVENT_CUSTOM
CARD_HOLY_AWE						=24001006	--EVENT_CUSTOM+DM_EVENT_TRIGGER_SHIELD_TRIGGER
CARD_BLOODY_SQUITO					=24001046	--EVENT_CUSTOM+DM_EVENT_WIN_BATTLE
CARD_CREEPING_PLAGUE				=24001049	--EVENT_CUSTOM+DM_EVENT_BECOME_BLOCKED
CARD_MARROW_OOZE_THE_TWISTER		=24002032	--EVENT_CUSTOM+DM_EVENT_ATTACK_PLAYER
CARD_BRUTAL_CHARGE					=24005049	--EVENT_CUSTOM+DM_EVENT_BREAK_SHIELD
CARD_STORM_WRANGLER_THE_FURIOUS		=24009051	--EVENT_CUSTOM+DM_EVENT_TRIGGER_BLOCKER
CARD_BLUUM_ERKIS_FLARE_GUARDIAN		=24010119	--EVENT_CUSTOM+DM_EVENT_CAST_FREE
CARD_SOUL_PHOENIX					=24012005	--RESERVED --EVENT_CUSTOM+DM_EVENT_TO_SZONE
CARD_GASHI_GASHI					=24013034	--EVENT_CUSTOM+DM_EVENT_LOSE_BATTLE
CARD_WOLFIS_BLUE_DIVINE_DRAGON		=24027		--EVENT_CUSTOM+DM_EVENT_BECOME_SHIELD_TRIGGER
--↑RegisterFlagEffect
CARD_DIA_NORK_MOONLIGHT_GUARDIAN	=24001002	--DM_EFFECT_BLOCKED
CARD_MIRACLE_QUEST					=24005019	--DM_EFFECT_BREAK_SHIELD
--Win Reason
DM_WIN_REASON_INVALID				=0x4d		--"Invalid deck."
DM_WIN_REASON_DECKOUT				=0x4e		--"Ran out of cards in deck."
DM_WIN_REASON_BOMBAZAR				=0x4f		--"Won due to the ability of [Bombazar, Dragon of Destiny]."
--Setname
--↑Race (Card.DMIsRace)
DM_RACE_LIGHT_BRINGER				=0x1		--"Chilias, the Oracle" (DM-01 1/110)
DM_RACE_GUARDIAN					=0x2		--"Dia Nork, Moonlight Guardian" (DM-01 2/110)
DM_RACE_STARLIGHT_TREE				=0x3		--"Emerald Grass" (DM-01 3/110)
DM_RACE_INITIATE					=0x4		--"Frei, Vizier of Air" (DM-01 4/110)
DM_RACE_BERSERKER					=0x5		--"Lah, Purification Enforcer" (DM-01 10/110)
DM_RACE_LIQUID_PEOPLE				=0x6		--"Aqua Hulcus" (DM-01 23/110)
DM_RACE_LIQUID_PEOPLE_SEN				=0x1006	--"Bat Mask, Aqua Warrior" (DMR-12 39/55)
DM_RACE_CYBER						=0x7		--"Virus", "Lord", "Cluster" and "Moon"
DM_RACE_CYBER_VIRUS						=0x1007	--"Candy Drop" (DM-01 28/110)
DM_RACE_CYBER_LORD						=0x2007	--"Tropico" (DM-01 42/110)
DM_RACE_CYBER_CLUSTER					=0x4007	--"Angler Cluster" (DM-03 12/55)
DM_RACE_CYBER_MOON						=0x8007	--"Ardent Lunatron" (DM-10 29/110)
DM_RACE_FISH						=0x8		--"Hunter Fish" (DM-01 31/110)
DM_RACE_GEL_FISH						=0x1008	--"Illusionary Merfolk" (DM-01 32/110)
DM_RACE_LEVIATHAN					=0x9		--"King Coral" (DM-01 33/110)
DM_RACE_GHOST						=0xa		--"Black Feather, Shadow of Rage" (DM-01 45/110)
DM_RACE_BRAIN_JACKER				=0xb		--"Bloody Squito" (DM-01 46/110)
DM_RACE_LIVING_DEAD					=0xc		--"Bone Assassin, the Ripper" (DM-01 47/110)
DM_RACE_CHIMERA						=0xd		--"Gigaberos" (DM-01 55/110)
DM_RACE_PARASITE_WORM				=0xe		--"Stinger Worm" (DM-01 61/110)
DM_RACE_DARK_LORD					=0xf		--"Vampire Silphy" (DM-01 64/110)
DM_RACE_ARMORLOID					=0x10		--"Armored Walker Urherion" (DM-01 67/110)
DM_RACE_MACHINE_EATER				=0x11		--"Artisan Picora" (DM-01 68/110)
DM_RACE_DRAGON						=0x12		--"Bolshack Dragon" (DM-01 69/110)
DM_RACE_ARMORED_DRAGON					=0x1012	--"Bolshack Dragon" (DM-01 69/110)
DM_RACE_VOLCANO_DRAGON					=0x2012	--"Magmadragon Jagalzor" (DM-08 4/55)
DM_RACE_ZOMBIE_DRAGON					=0x4012	--"Necrodragon Galbazeek" (DM-08 32/55)
DM_RACE_EARTH_DRAGON					=0x8012	--"Terradragon Gamiratar" (DM-08 54/55)
DM_RACE_APOLLONIA_DRAGON				=0xa012	--"Spell Del Fin, Light Divine Dragon" (DM-22 1/55)
DM_RACE_POSEIDIA_DRAGON					=0xe012	--"Spell Great Blue, Blue Divine Dragon" (DM-22 2/55)
DM_RACE_HUMAN						=0x13		--"Brawler Zyler" (DM-01 70/110)
DM_RACE_HUMAN_BAKU						=0x1013	--"Glenmalt, Explosive Swordsman" (DMR-12 14/55)
DM_RACE_HUMAN_JYA						=0x2013	--"Seriously Invincible Grandpa" (P56/Y14)
DM_RACE_DRAGO_NOID					=0x14		--"Deadly Fighter Braid Claw" (DM-01 74/110)
DM_RACE_ARMORED_WYVERN				=0x15		--"Draglide" (DM-01 75/110)
DM_RACE_ROCK_BEAST					=0x16		--"Meteosaur" (DM-01 82/110)
DM_RACE_BEAST_FOLK					=0x17		--"Bronze-Arm Tribe" (DM-01 90/110)
DM_RACE_BEAST_FOLK_GO					=0x1017	--"Sasoris, Dragon Edge" (DMR-13 36/110)
DM_RACE_TREE_FOLK					=0x18		--"Coiling Vines" (DM-01 92/110)
DM_RACE_COLONY_BEETLE				=0x19		--"Dome Shell" (DM-01 94/110)
DM_RACE_GIANT						=0x1a		--"Forest Hornet" (DM-01 96/110), "Dawn Giant" (DM-03 46/55)
DM_RACE_GIANT_INSECT					=0x101a	--"Forest Hornet" (DM-01 96/110)
DM_RACE_BALLOON_MUSHROOM			=0x1b		--"Poisonous Mushroom" (DM-01 102/110)
DM_RACE_HORNED_BEAST				=0x1c		--"Stampeding Longhorn" (DM-01 104/110)
DM_RACE_COMMAND						=0x1d		--"Angel", "Demon", "Gaia", "Flame", "World" and "Soul"
DM_RACE_ANGEL_COMMAND					=0x101d	--"Hanusa, Radiance Elemental" (DM-01 S1/S10)
DM_RACE_DEMON_COMMAND					=0x201d	--"Deathliger, Lion of Chaos" (DM-01 S5/S10)
DM_RACE_GAIA_COMMAND					=0x401d	--"Auravine, Earth's Grasp" (DM-32 S10/S10)
DM_RACE_FLAME_COMMAND					=0x801d	--"Tornado Shiva Double Cross, Blastdragon" (DM-36 8/110)
DM_RACE_SOUL_COMMAND					=0xa01d	--"Final Doppel" (DM-39 5/55)
DM_RACE_WORLD_COMMAND					=0xe01d	--"Diabolos Zeta, Temporal Ruler" (DM-39 S5a/S5)
DM_RACE_MECHA_THUNDER				=0x1e		--"Ra Vu, Seeker of Lightning" (DM-03 6/55)
DM_RACE_HEDRIAN						=0x1f		--"Mudman" (DM-03 30/55)
DM_RACE_FIRE_BIRD					=0x20		--"Baby Zoppe" (DM-03 35/55)
DM_RACE_FIRE_BIRD_EN					=0x1020	--"Jet Polka" (DMR-16極 29/54)
DM_RACE_SURVIVOR					=0x21		--"Bladerush Skyterror Q" (DM-05 4/55)
DM_RACE_SEA_HACKER					=0x22		--"Aeropica" (DM-06 3/110)
DM_RACE_RAINBOW_PHANTOM				=0x23		--"Cosmogold, Spectral Knight" (DM-06 17/110)
DM_RACE_GLADIATOR					=0x24		--"Telitol, the Explorer" (DM-06 28/110)
DM_RACE_EARTH_EATER					=0x25		--"Hazard Crawler" (DM-06 34/110)
DM_RACE_DEVIL_MASK					=0x26		--"Grinning Axe, the Monstrosity" (DM-06 60/110)
DM_RACE_DEATH_PUPPET				=0x27		--"Junkatz, Rabid Doll" (DM-06 62/110)
DM_RACE_DUNE_GECKO					=0x28		--"Badlands Lizard" (DM-06 74/110)
DM_RACE_XENOPARTS					=0x29		--"Picora's Wrench" (DM-06 84/110)
DM_RACE_MYSTERY_TOTEM				=0x2a		--"Bliss Totem, Avatar of Luck" (DM-06 91/110)
DM_RACE_SNOW_FAERIE					=0x2b		--"Charmilia, the Enticer" (DM-06 94/110)
DM_RACE_SNOW_FAERIE_KAZE				=0x102b	--"Bell the Elemental" (DMR-16極 16/54)
DM_RACE_MECHA_DEL_SOL				=0x2c		--"Misha, Channeler of Suns" (DM-08 10/55)
DM_RACE_SOLTROOPER					=0x2d		--"Bulgluf, the Spydroid" (DM-10 12/110)
DM_RACE_MERFOLK						=0x2e		--"Mystic Magician" (DM-10 36/110)
DM_RACE_PANDORAS_BOX				=0x2f		--"Benzo, the Hidden Fury" (DM-10 45/110)
DM_RACE_MELT_WARRIOR				=0x30		--"Burnwisp Lizard" (DM-10 64/110)
DM_RACE_WILD_VEGGIES				=0x31		--"Hustle Berry" (DM-10 84/110)
DM_RACE_SPIRIT_QUARTZ				=0x32		--"Deklowaz, the Terminator" (DM-10 S10/S10)
DM_RACE_PHOENIX						=0x33		--"Soul Phoenix, Avatar of Unity" (DM-12 5/55)
DM_RACE_STARNOID					=0x34		--"Wise Starnoid, Avatar of Hope" (DM-12 S2/S5)
DM_RACE_NAGA						=0x35		--"Cruel Naga, Avatar of Fate" (DM-12 S3/S5)
DM_RACE_PEGASUS						=0x36		--"Aura Pegasus, Avatar of Life" (DM-12 S5/S5)
--Min/Max Value
MAX_NUMBER							=999999999	--Max number allowed in YGOPro
DM_MAX_MANA_COST					=4294967295	--"Dormageddon X, Forbidden Armageddon" (DMR-23 FFL1,FFL2,FFL3,FFL4,FFL5/FFL5)
--Location
DM_LOCATION_BATTLE					=LOCATION_MZONE						--Battle Zone
DM_LOCATION_SHIELD					=LOCATION_SZONE						--Shield Zone
DM_LOCATION_MANA					=LOCATION_GRAVE+LOCATION_REMOVED	--Mana Zone
DM_LOCATION_GRAVE					=LOCATION_REMOVED					--Graveyard
--↑Location combinations
LOCATION_ALL						=0xff		--All locations
--Position
POS_FACEUP_UNTAPPED					=POS_FACEUP_ATTACK		--Face-up untapped
POS_FACEDOWN_UNTAPPED				=POS_FACEDOWN_ATTACK	--N/A
POS_FACEUP_TAPPED					=POS_FACEUP_DEFENSE		--Face-up tapped 
POS_FACEDOWN_TAPPED					=POS_FACEDOWN_DEFENSE	--N/A
POS_UNTAPPED						=POS_ATTACK				--RESERVED --Face-up or face-down untapped
POS_TAPPED							=POS_DEFENSE			--RESERVED --Face-up or face-down untapped
--Type (Card.IsType)
DM_TYPE_CREATURE					=TYPE_EFFECT			--Creature
DM_TYPE_MULTICOLORED				=TYPE_DUAL				--Card that has 2 or more civilizations
DM_TYPE_NO_ABILITY					=TYPE_TUNER				--Creature that has no abilities
DM_TYPE_EVOLUTION					=TYPE_SPSUMMON			--Evolution creature
--Civilization
DM_CIVILIZATION_NONE				=0x0				--No civilization (including Zero and Jokers)
DM_CIVILIZATION_ALL					=ATTRIBUTE_LIGHT+ATTRIBUTE_WATER+ATTRIBUTE_DARK+ATTRIBUTE_FIRE+ATTRIBUTE_EARTH	--Include all 5 civilizations
DM_CIVILIZATION_LIGHT				=ATTRIBUTE_LIGHT	--Light
DM_CIVILIZATION_WATER				=ATTRIBUTE_WATER	--Water
DM_CIVILIZATION_DARKNESS			=ATTRIBUTE_DARK		--Darkness
DM_CIVILIZATION_FIRE				=ATTRIBUTE_FIRE		--Fire
DM_CIVILIZATION_NATURE				=ATTRIBUTE_EARTH	--Nature
DM_CIVILIZATION_COUNT				=5					--Number of different civilizations that exists
--↑2 color civilization combinations (Multicolored)
DM_CIVILIZATIONS_LW					=DM_CIVILIZATION_LIGHT+DM_CIVILIZATION_WATER		--Light and water
DM_CIVILIZATIONS_LD					=DM_CIVILIZATION_LIGHT+DM_CIVILIZATION_DARKNESS		--Light and darkness
DM_CIVILIZATIONS_WD					=DM_CIVILIZATION_WATER+DM_CIVILIZATION_DARKNESS		--Water and darkness
DM_CIVILIZATIONS_LF					=DM_CIVILIZATION_LIGHT+DM_CIVILIZATION_FIRE			--Light and fire
DM_CIVILIZATIONS_WF					=DM_CIVILIZATION_WATER+DM_CIVILIZATION_FIRE			--Water and fire
DM_CIVILIZATIONS_DF					=DM_CIVILIZATION_DARKNESS+DM_CIVILIZATION_FIRE		--Darkness and fire
DM_CIVILIZATIONS_LN					=DM_CIVILIZATION_LIGHT+DM_CIVILIZATION_NATURE		--Light and nature
DM_CIVILIZATIONS_WN					=DM_CIVILIZATION_WATER+DM_CIVILIZATION_NATURE		--Water and nature
DM_CIVILIZATIONS_DN					=DM_CIVILIZATION_DARKNESS+DM_CIVILIZATION_NATURE	--Darkness and nature
DM_CIVILIZATIONS_FN					=DM_CIVILIZATION_FIRE+DM_CIVILIZATION_NATURE		--Fire and nature
--↑3 color civilization combinations (Multicolored)
DM_CIVILIZATIONS_DFN				=DM_CIVILIZATIONS_DF+DM_CIVILIZATION_NATURE			--Darkness, fire and nature
DM_CIVILIZATIONS_LFN				=DM_CIVILIZATIONS_LF+DM_CIVILIZATION_NATURE			--Light, fire and nature
DM_CIVILIZATIONS_LWD				=DM_CIVILIZATIONS_LW+DM_CIVILIZATION_DARKNESS		--Light, water and darkness
DM_CIVILIZATIONS_LWN				=DM_CIVILIZATIONS_LW+DM_CIVILIZATION_NATURE			--Light, water and nature
DM_CIVILIZATIONS_WDF				=DM_CIVILIZATIONS_WD+DM_CIVILIZATION_FIRE			--Water, darkness and fire
DM_CIVILIZATIONS_LDF				=DM_CIVILIZATIONS_LD+DM_CIVILIZATION_FIRE			--Light, darkness and fire
DM_CIVILIZATIONS_LDN				=DM_CIVILIZATIONS_LD+DM_CIVILIZATION_NATURE			--Light, darkness and nature
DM_CIVILIZATIONS_LWF				=DM_CIVILIZATIONS_LW+DM_CIVILIZATION_FIRE			--Light, water and fire
DM_CIVILIZATIONS_WDN				=DM_CIVILIZATIONS_WD+DM_CIVILIZATION_NATURE			--Water, darkness and nature
DM_CIVILIZATIONS_WFN				=DM_CIVILIZATIONS_WF+DM_CIVILIZATION_NATURE			--Water, fire and nature
--↑4 color civilization combinations (Multicolored)
DM_CIVILIZATIONS_LWDF				=DM_CIVILIZATIONS_LW+DM_CIVILIZATIONS_DF			--Light, water, darkness and fire
--↑5 color civilization combinations (Multicolored)
DM_CIVILIZATIONS_LWDFN				=DM_CIVILIZATIONS_LW+DM_CIVILIZATIONS_DF+DM_CIVILIZATION_NATURE	--Light, water, darkness, fire and nature
--Reason
DM_REASON_BREAK						=0x20000000		--Reason for breaking a player's shield
--Summon Type
DM_SUMMON_TYPE_NORMAL				=0x49000000		--Summon a creature by paying its mana cost(SUMMON_TYPE_XYZ)
DM_SUMMON_TYPE_EVOLUTION			=0x49000100		--Summon a creature by evolving a creature in the battle zone(SUMMON_TYPE_XYZ+0x100)
--Player (parameter)
PLAYER_OWNER						=nil	--player=PLAYER_OWNER in Duel.Sendto..(targets, player, reason)
PLAYER_SELF							=0		--player=PLAYER_SELF in Effect.SetCondition(Auxiliary.Function(player)), etc.
PLAYER_OPPO							=1		--player=PLAYER_OPPO in Effect.SetCondition(Auxiliary.Function(player)), etc.
--Reset
--↑Reset combinations
RESETS_STANDARD						=0x1fe0000	--RESET_TURN_SET+RESET_TOGRAVE+RESET_REMOVE+RESET_TEMP_REMOVE+RESET_TOHAND+RESET_TODECK+RESET_LEAVE+RESET_TOFIELD
RESETS_REDIRECT						=0x47e0000	--RESETS_STANDARD+RESET_OVERLAY-RESET_TOFIELD-RESET_LEAVE (EFFECT_LEAVE_FIELD_REDIRECT)
--Type (for SetType)
DM_EFFECT_TYPE_CAST_SPELL			=EFFECT_TYPE_IGNITION			--Cast a spell
--Flag
DM_EFFECT_FLAG_SUMMON_PARAM			=EFFECT_FLAG_SPSUM_PARAM		--Included in a creature's summon procedure
DM_EFFECT_FLAG_CHAIN_LIMIT			=0x8000000						--Included in an effect that cannot be chained to
DM_EFFECT_FLAG_CHARGE				=0x20000000						--Included in an effect where a player puts the cast spell into the mana zone
--Code
DM_EFFECT_SUMMON_PROC				=EFFECT_SPSUMMON_PROC			--Summon creature procedure
DM_EFFECT_TO_GRAVE_REDIRECT			=EFFECT_REMOVE_REDIRECT			--Put a card into another zone instead of the graveyard
DM_EFFECT_CANNOT_ATTACK_PLAYER		=EFFECT_CANNOT_DIRECT_ATTACK	--Cannot attack player
DM_EFFECT_ATTACK_PLAYER				=EFFECT_DIRECT_ATTACK			--Attack player
DM_EFFECT_CANNOT_CHANGE_POS_ABILITY	=EFFECT_CANNOT_CHANGE_POS_E		--Cannot untap or tap a card by an ability 
DM_EFFECT_UPDATE_POWER				=EFFECT_UPDATE_ATTACK			--Increase or decrease a creature's power
DM_EFFECT_SET_POWER					=EFFECT_SET_ATTACK				--Creature's power becomes a particular value
DM_EFFECT_UPDATE_MANA_COST			=EFFECT_UPDATE_LEVEL			--Increase or decrease a card's mana cost
DM_EFFECT_CHANGE_MANA_COST			=EFFECT_CHANGE_LEVEL			--Mana cost becomes a particular value
DM_EFFECT_ADD_CIVILIZATION			=EFFECT_ADD_ATTRIBUTE			--Card is considered to be a card of another civilization
DM_EFFECT_CHANGE_CIVILIZATION		=EFFECT_CHANGE_ATTRIBUTE		--Civilization becomes another civilization
DM_EFFECT_ADD_RACE 					=EFFECT_ADD_SETCODE				--Creature is a particular race in addition to its other races
DM_EFFECT_MUST_ATTACK_CREATURE		=EFFECT_MUST_ATTACK_MONSTER		--Creature attacks a creature if able
DM_EFFECT_BROKEN_SHIELD				=24000000						--Register a broken shield
DM_EFFECT_IGNORE_TAP				=24000001						--Workaround to not tap a creature at the end of the damage step
DM_EFFECT_BLOCKED					=CARD_DIA_NORK_MOONLIGHT_GUARDIAN	--Register a creature that has become blocked
DM_EFFECT_BREAK_SHIELD				=CARD_MIRACLE_QUEST				--Register number of broken shields
DM_EFFECT_BLOCKER					=701	--Blocker ("Dia Nork, Moonlight Guardian" DM-01 2/110)
DM_EFFECT_SHIELD_TRIGGER			=702	--Shield Trigger ("Holy Awe" DM-01 6/110)
DM_EFFECT_UNBLOCKABLE				=703	--RESERVED --Cannot be blocked ("Laser Wing" DM-01 11/110)
DM_EFFECT_SLAYER					=704	--Slayer ("Bone Assassin, the Ripper" DM-01 47/110)
DM_EFFECT_BREAKER					=705	--Breaker ("Gigaberos" DM-01 55/110)
DM_EFFECT_DOUBLE_BREAKER			=706	--Double Breaker ("Gigaberos" DM-01 55/110)
DM_EFFECT_POWER_ATTACKER			=707	--Power Attacker ("Brawler Zyler" DM-01 70/110)
DM_EFFECT_UNTAPPED_BE_ATTACKED		=708	--Can be attacked as though it were tapped ("Chaos Strike" DM-01 72/110)
DM_EFFECT_ATTACK_UNTAPPED			=709	--Can attack untapped creatures ("Gatling Skyterror" DM-01 79/110)
DM_EFFECT_CANNOT_ATTACK_CREATURE	=710	--Cannot attack creatures ("Diamond Cutter" DM-02 1/55)
DM_EFFECT_IGNORE_SUMMONING_SICKNESS	=711	--Ignore summoning sickness ("Diamond Cutter" DM-02 1/55)
DM_EFFECT_IGNORE_CANNOT_ATTACK		=712	--Ignore "This creature can't attack" ("Diamond Cutter" DM-02 1/55)
DM_EFFECT_IGNORE_CANNOT_ATTACK_PLAYER	=713--Ignore "This creature can't attack players" ("Diamond Cutter" DM-02 1/55)
DM_EFFECT_TRIPLE_BREAKER			=714	--Triple Breaker ("Bolgash Dragon" DM-05 37/55)
DM_EFFECT_SPEED_ATTACKER			=715	--Speed Attacker ("Bombat, General of Speed" DM-05 38/55)
DM_EFFECT_ENTER_BZONE_TAPPED		=716	--Creature is put into the battle zone tapped ("Lu Gila, Silver Rift Guardian" DM-06 2/110)
DM_EFFECT_NO_BLOCK_BATTLE			=717	--No battle happens when a creature blocks ("Chekicul, Vizier of Endurance" DM-06 15/110)
DM_EFFECT_CANNOT_SUMMON				=718	--Cannot summon a creature ("Gariel, Elemental of Sunbeams" DM-06 20/110)
DM_EFFECT_CHANGE_SHIELD_BREAK_PLAYER=719	--You choose the shield to break when an opponent's creature would break a shield ("Kyuroro" DM-06 36/110)
DM_EFFECT_NO_BE_BLOCKED_BATTLE		=720	--No battle happens when a creature becomes blocked ("Badlands Lizard" DM-06 74/110)
DM_EFFECT_CREW_BREAKER				=721	--Crew Breaker ("Q-tronic Gargantua" DM-06 86/110)
DM_EFFECT_EVOLUTION_ANY_RACE		=722	--Can put an evolution creature of any race on a creature with this ability ("Innocent Hunter, Blade of All" DM-06 103/110)
DM_EFFECT_BREAK_SHIELD_REPLACE		=723	--When a creature would break a shield, do something else to that shield instead ("Bolmeteus Steel Dragon" DM-06 S7/S10)
DM_EFFECT_STEALTH					=724	--Stealth ("Kizar Basiku, the Outrageous" DM-07 9/55)
DM_EFFECT_CHARGER					=725	--Charger ("Lightning Charger" DM-07 15/55)
DM_EFFECT_DONOT_DISCARD_SHIELD_TRIGGER	=726--Do not discard a spell after using its "Shield Trigger" ability ("Super Terradragon Bailas Gale" DM-08 S5/S5)
DM_EFFECT_MUST_BLOCK				=727	--Creature must block another creature if able ("Storm Wrangler, the Furious" DM-09 51/55)
DM_EFFECT_SILENT_SKILL				=728	--Keep creature tapped during untap step to use its "Silent Skill" ability ("Kejila, the Hidden Horror" DM-10 5/110)
DM_EFFECT_WAVE_STRIKER				=729	--Wave Striker ("Asra, Vizier of Safety" DM-11 6/55)
DM_EFFECT_CANNOT_USE_TAP_ABILITY	=730	--Player cannot use the Tap ability of their creatures ("Lockdown Lizard" DM-11 39/55)
DM_EFFECT_VORTEX_EVOLUTION			=731	--Vortex Evolution ("Soul Phoenix, Avatar of Unity" DM-12 5/55)
DM_EFFECT_EVOLUTION_SOURCE_REMAIN	=732	--When an evolution creature would leave the battle zone, only the top card leaves instead ("Soul Phoenix, Avatar of Unity" DM-12 5/55)
DM_EFFECT_SYMPATHY					=733	--Sympathy ("Akashic First, Electro-Dragon" DM-13 3/55)
DM_EFFECT_CONFIRM_BROKEN_SHIELD		=734	--Player reveals their shields broken by their opponent's creatures ("Rubels, the Explorer" DM-13 36/55)
DM_EFFECT_CHARGE_TAPPED				=735	--Put a cast spell with this ability into the mana zone tapped instead of the graveyard ("Pixie Cocoon" DM-13 50/55)
DM_EFFECT_WINS_ALL_BATTLES			=799	--Wins All Battles ("Marshias, Spirit of the Sun" DM-14 S1/S10)		
--Abilities that trigger or actions that occur at the appropriate event
DM_EVENT_UNTAP_STEP					=EVENT_PREDRAW					--Start of Turn Step (Untap Step)
DM_EVENT_ATTACK_SHIELD				=EVENT_PRE_DAMAGE_CALCULATE		--Before an attacking creature breaks the opponent's shield
DM_EVENT_TO_GRAVE					=EVENT_REMOVE					--When a card is put into the graveyard
--DM_EVENT_TO_MZONE					=EVENT_TO_GRAVE					--RESERVED --When a card is put into the mana zone
DM_EVENT_LEAVE_BZONE				=EVENT_LEAVE_FIELD				--When a card leaves the battle zone - DM_EVENT_TO_SZONE
DM_EVENT_COME_INTO_PLAY				=EVENT_SPSUMMON_SUCCESS			--When a creature is put into the battle zone
DM_EVENT_SUMMON						=EVENT_SPSUMMON_SUCCESS			--When a player summons a creature
DM_EVENT_ATTACK_END					=EVENT_DAMAGE_STEP_END			--When a creature finishes its attack
DM_EVENT_BATTLE_END					=EVENT_DAMAGE_STEP_END			--After a battle happens
DM_EVENT_TRIGGER_SHIELD_TRIGGER		=CARD_HOLY_AWE					--Trigger a card's "Shield Trigger" ability
DM_EVENT_WIN_BATTLE					=CARD_BLOODY_SQUITO				--When a creature wins a battle + EVENT_BATTLE_DESTROYING
DM_EVENT_LOSE_BATTLE				=CARD_GASHI_GASHI				--When a creature loses a battle + EVENT_BATTLE_DESTROYED
DM_EVENT_BECOME_BLOCKED				=CARD_CREEPING_PLAGUE			--When a creature becomes blocked
DM_EVENT_ATTACK_PLAYER				=CARD_MARROW_OOZE_THE_TWISTER	--When a creature attacks a player
DM_EVENT_BREAK_SHIELD				=CARD_BRUTAL_CHARGE				--When a creature finishes attacking the opponent and broke a shield
DM_EVENT_TRIGGER_BLOCKER			=CARD_STORM_WRANGLER_THE_FURIOUS--Trigger a creature's "Blocker" ability
DM_EVENT_CAST_FREE					=CARD_BLUUM_ERKIS_FLARE_GUARDIAN--Cast a spell immediately for no cost
DM_EVENT_TO_SZONE					=CARD_SOUL_PHOENIX				--RESERVED --When a card is added to a player's shields
DM_EVENT_BECOME_SHIELD_TRIGGER		=CARD_WOLFIS_BLUE_DIVINE_DRAGON	--Card gets "Shield Trigger" (Can be summoned or cast for no cost)
--Category (for SetCategory)
DM_CATEGORY_BLOCKER					=0x10000000		--"Blocker", needed for unblockable abilities ("Laser Wing" DM-01 11/110)
DM_CATEGORY_SHIELD_TRIGGER			=0x800			--"Shield Trigger" ("Emperor Quazla" DM-08 S2/S5)
--Description (for SetDescription, Duel.Hint)
DM_DESC_SUMMON						=2		--"Summon"
DM_DESC_EVOLUTION					=1199	--"Evolve a creature(s) in the battle zone."
DM_DESC_BROKEN						=300	--"Broken shield"
DM_DESC_SUMMONSICKNESS				=301	--"Summoning Sickness"
DM_DESC_NOTARGETS					=1650	--"There is no applicable card."
DM_DESC_NOSTRIGGER					=1651	--"No "Shield Trigger" ability can be activated."
DM_DESC_NOBZONES					=1652	--"You cannot put any more cards in the battle zone because all zones are occupied!"
DM_DESC_NOSZONES					=1653	--"You cannot put any more cards in the shield zone because all zones are occupied!"
DM_DESC_BLOCKED						=1659	--"Your creature has been blocked!"
DM_DESC_BLOCKER						=1660	--"Blocker (Whenever an opponent's creature attacks, you may tap this creature to stop the attack. Then the 2 creatures battle.)"
--DM_DESC_SHIELD_TRIGGER_SPELL		=1661	--RESERVED --"Shield Trigger (When this spell is put into your hand from your shield zone, you may cast it immediately for no cost.)"
DM_DESC_SLAYER						=1662	--"Slayer (Whenever this creature battles, destroy the other creature after the battle.)"
DM_DESC_SHIELD_TRIGGER_CREATURE		=1663	--"Shield Trigger (When this creature is put into your hand from your shield zone, you may summon it immediately for no cost.)"
DM_DESC_FIRE_NATURE_BLOCKER			=1664	--"Fire and nature blocker (Whenever an opponent's fire or nature creature attacks, you may tap this creature to stop the attack. Then the 2 creatures battle.)"
DM_DESC_NATURE_LIGHT_SLAYER			=1665	--"Nature and light slayer (Whenever this creature battles a nature or light creature, destroy the other creature after the battle.)"
DM_DESC_TURBO_RUSH					=1666	--"Turbo rush (If any of your other creatures broke any shields this turn, this creature gets its Turborush ability until the end of the turn.)"
DM_DESC_DRAGON_BLOCKER				=1667	--"Dragon blocker (Whenever an opponent's creature that has Dragon in its race attacks, you may tap this creature to stop the attack. Then the 2 creatures battle.)"
--DM_DESC_NON_BREAKER					=1800	--RESERVED --"This creature breaks 1 shield."
DM_DESC_DOUBLE_BREAKER				=1801	--"Double Breaker (This creature breaks 2 shields.)"
DM_DESC_TRIPLE_BREAKER				=1802	--"Triple Breaker (This creature breaks 3 shields.)"
DM_DESC_CREW_BREAKER				=1803	--"Crew Breaker—"RACE" (This creature breaks one more shield for each of your other "RACE" in the battle zone.)"
DM_DECKERROR_DECKCOUNT				=1450	--"Your deck must be exactly 40 cards!"
DM_DECKERROR_NONDM					=1451	--"You can't have any non-Duel Masters cards in your deck!"
--Select Message (for Duel.SelectOption)
DM_SELECT_RACE_ANGEL_COMMAND		=aux.Stringid(24000003,4)	--"Angel Command"
DM_SELECT_RACE_ARMORED_DRAGON		=aux.Stringid(24000002,5)	--"Armored Dragon"
DM_SELECT_RACE_ARMORED_WYVERN		=aux.Stringid(24000002,11)	--"Armored Wyvern"
DM_SELECT_RACE_ARMORLOID			=aux.Stringid(24000002,3)	--"Armorloid"
DM_SELECT_RACE_BALLOON_MUSHROOM		=aux.Stringid(24000003,2)	--"Balloon Mushroom"
DM_SELECT_RACE_BEAST_FOLK			=aux.Stringid(24000002,13)	--"Beast Folk"
DM_SELECT_RACE_BERSERKER			=aux.Stringid(24000001,4)	--"Berserker"
DM_SELECT_RACE_BRAIN_JACKER			=aux.Stringid(24000001,14)	--"Brain Jacker"
DM_SELECT_RACE_CHIMERA				=aux.Stringid(24000002,0)	--"Chimera"
DM_SELECT_RACE_COLONY_BEETLE		=aux.Stringid(24000002,15)	--"Colony Beetle"
DM_SELECT_RACE_CYBER_CLUSTER		=aux.Stringid(24000001,8)	--"Cyber Cluster"
DM_SELECT_RACE_CYBER_LORD			=aux.Stringid(24000001,7)	--"Cyber Lord"
DM_SELECT_RACE_CYBER_MOON			=aux.Stringid(24000001,9)	--"Cyber Moon"
DM_SELECT_RACE_CYBER_VIRUS			=aux.Stringid(24000001,6)	--"Cyber Virus"
DM_SELECT_RACE_DARK_LORD			=aux.Stringid(24000002,2)	--"Dark Lord"
DM_SELECT_RACE_DEATH_PUPPET			=aux.Stringid(24000003,15)	--"Death Puppet"
DM_SELECT_RACE_DEMON_COMMAND		=aux.Stringid(24000003,5)	--"Demon Command"
DM_SELECT_RACE_DEVIL_MASK			=aux.Stringid(24000003,14)	--"Devil Mask"
DM_SELECT_RACE_DRAGO_NOID			=aux.Stringid(24000002,10)	--"Dragonoid"
DM_SELECT_RACE_DUNE_GECKO			=aux.Stringid(24000004,0)	--"Dune Gecko"
DM_SELECT_RACE_EARTH_DRAGON			=aux.Stringid(24000002,8)	--"Earth Dragon"
DM_SELECT_RACE_EARTH_EATER			=aux.Stringid(24000003,13)	--"Earth Eater"
DM_SELECT_RACE_FIRE_BIRD			=aux.Stringid(24000003,8)	--"Fire Bird"
DM_SELECT_RACE_FISH					=aux.Stringid(24000001,10)	--"Fish"
DM_SELECT_RACE_GEL_FISH				=aux.Stringid(24000001,11)	--"Gel Fish"
DM_SELECT_RACE_GHOST				=aux.Stringid(24000001,13)	--"Ghost"
DM_SELECT_RACE_GIANT				=aux.Stringid(24000003,0)	--"Giant"
DM_SELECT_RACE_GIANT_INSECT			=aux.Stringid(24000003,1)	--"Giant Insect"
DM_SELECT_RACE_GLADIATOR			=aux.Stringid(24000003,12)	--"Gladiator"
DM_SELECT_RACE_GUARDIAN				=aux.Stringid(24000001,1)	--"Guardian"
DM_SELECT_RACE_HEDRIAN				=aux.Stringid(24000003,7)	--"Hedrian"
DM_SELECT_RACE_HORNED_BEAST			=aux.Stringid(24000003,3)	--"Horned Beast"
DM_SELECT_RACE_HUMAN				=aux.Stringid(24000002,9)	--"Human"
DM_SELECT_RACE_INITIATE				=aux.Stringid(24000001,3)	--"Initiate"
DM_SELECT_RACE_LEVIATHAN			=aux.Stringid(24000001,12)	--"Leviathan"
DM_SELECT_RACE_LIGHT_BRINGER		=aux.Stringid(24000001,0)	--"Light Bringer"
DM_SELECT_RACE_LIQUID_PEOPLE		=aux.Stringid(24000001,5)	--"Liquid People"
DM_SELECT_RACE_LIVING_DEAD			=aux.Stringid(24000001,15)	--"Living Dead"
DM_SELECT_RACE_MACHINE_EATER		=aux.Stringid(24000002,4)	--"Machine Eater"
DM_SELECT_RACE_MECHA_DEL_SOL		=aux.Stringid(24000004,4)	--"Mecha Del Sol"
DM_SELECT_RACE_MECHA_THUNDER		=aux.Stringid(24000003,6)	--"Mecha Thunder"
DM_SELECT_RACE_MELT_WARRIOR			=aux.Stringid(24000004,8)	--"Melt Warrior"
DM_SELECT_RACE_MERFOLK				=aux.Stringid(24000004,6)	--"Merfolk"
DM_SELECT_RACE_MYSTERY_TOTEM		=aux.Stringid(24000004,2)	--"Mystery Totem"
DM_SELECT_RACE_NAGA					=aux.Stringid(24000004,13)	--"Naga"
DM_SELECT_RACE_PANDORAS_BOX			=aux.Stringid(24000004,7)	--"Pandora's Box"
DM_SELECT_RACE_PARASITE_WORM		=aux.Stringid(24000002,1)	--"Parasite Worm"
DM_SELECT_RACE_PEGASUS				=aux.Stringid(24000004,14)	--"Pegasus"
DM_SELECT_RACE_PHOENIX				=aux.Stringid(24000004,11)	--"Phoenix"
DM_SELECT_RACE_RAINBOW_PHANTOM		=aux.Stringid(24000003,11)	--"Rainbow Phantom"
DM_SELECT_RACE_ROCK_BEAST			=aux.Stringid(24000002,12)	--"Rock Beast"
DM_SELECT_RACE_SEA_HACKER			=aux.Stringid(24000003,10)	--"Sea Hacker"
DM_SELECT_RACE_SNOW_FAERIE			=aux.Stringid(24000004,3)	--"Snow Faerie"
DM_SELECT_RACE_SOLTROOPER			=aux.Stringid(24000004,5)	--"Soltrooper"
DM_SELECT_RACE_SPIRIT_QUARTZ		=aux.Stringid(24000004,10)	--"Spirit Quartz"
DM_SELECT_RACE_STARLIGHT_TREE		=aux.Stringid(24000001,2)	--"Starlight Tree"
DM_SELECT_RACE_STARNOID				=aux.Stringid(24000004,12)	--"Starnoid"
DM_SELECT_RACE_SURVIVOR				=aux.Stringid(24000003,9)	--"Survivor"
DM_SELECT_RACE_TREE_FOLK			=aux.Stringid(24000002,14)	--"Tree Folk"
DM_SELECT_RACE_VOLCANO_DRAGON		=aux.Stringid(24000002,6)	--"Volcano Dragon"
DM_SELECT_RACE_WILD_VEGGIES			=aux.Stringid(24000004,9)	--"Wild Veggies"
DM_SELECT_RACE_XENOPARTS			=aux.Stringid(24000004,1)	--"Xenoparts"
DM_SELECT_RACE_ZOMBIE_DRAGON		=aux.Stringid(24000002,7)	--"Zombie Dragon"
--Hint Message
DM_HINTMSG_DISCARD					=501	--"Choose a card to discard."
DM_HINTMSG_DESTROY					=502	--"Choose a card to destroy."
DM_HINTMSG_TOGRAVE					=503	--"Choose a card to put into the graveyard."
DM_HINTMSG_TOMANA					=504	--"Choose a card to put into the mana zone."
DM_HINTMSG_RTOHAND					=505	--"Choose a card to return to its owner's hand."
DM_HINTMSG_ATOHAND					=506	--"Choose a card to put into your hand."
DM_HINTMSG_TODECK					=507	--"Choose a card to return to its owner's deck."
DM_HINTMSG_TOBATTLE					=509	--"Choose a creature to put into the battle zone."
DM_HINTMSG_CONFIRM					=526	--"Choose a card to look at it."
DM_HINTMSG_TOSHIELD					=527	--"Choose a card to add to its owner's shields."
DM_HINTMSG_ATTACKTARGET				=549	--"Choose a creature to attack."
DM_HINTMSG_TARGET					=551	--"Choose a target for the ability."
DM_HINTMSG_APPLYABILITY				=556	--"Choose an ability to apply."
DM_HINTMSG_CIVILIZATION				=562	--"Choose a civilization(s)."
DM_HINTMSG_RACE						=563	--"Choose a race."
DM_HINTMSG_NAME						=564	--"Name a card."
DM_HINTMSG_NUMBER					=565	--"Choose a number."
DM_HINTMSG_TAP						=601	--"Choose a card to tap."
DM_HINTMSG_UNTAP					=602	--"Choose a card to untap."
DM_HINTMSG_BREAK					=603	--"Choose a shield to break."
DM_HINTMSG_CREATURE					=604	--"Choose a creature."
DM_HINTMSG_EVOLVE					=605	--"Choose a creature to evolve."
--Question Hint Message (for Duel.SelectYesNo)
DM_QHINTMSG_DRAW					=700	--"Draw a card?"
DM_QHINTMSG_CARD					=701	--"How many cards?"
DM_QHINTMSG_CHOOSE					=702	--"Choose a card?"
DM_QHINTMSG_TOMANA					=703	--"Put a card into your mana zone?"
DM_QHINTMSG_TOSHIELD				=704	--"Add a card to your shields?"
DM_QHINTMSG_TOHAND					=705	--"Put a card into its owner's hand?"
--DM_QHINTMSG_TAP						=706	--RESERVED --"Tap a card?"
DM_QHINTMSG_UNTAP					=707	--"Untap a card?"
--Timing
DM_TIMING_BATTLE					=TIMING_BATTLE_START+TIMING_BATTLE_END+TIMING_BATTLE_PHASE+TIMING_BATTLE_STEP_END	--Timing for abilities that can trigger during the Attack Step
--Deck Sequence
DECK_SEQUENCE_TOP					=0		--seq=DECK_SEQUENCE_TOP in Duel.SendtoDeck(targets, player, seq, reason)
DECK_SEQUENCE_BOTTOM				=1		--seq=DECK_SEQUENCE_BOTTOM in Duel.SendtoDeck(targets, player, seq, reason)
DECK_SEQUENCE_SHUFFLE				=2		--seq=DECK_SEQUENCE_SHUFFLE in Duel.SendtoDeck(targets, player, seq, reason)
DECK_SEQUENCE_UNEXIST				=-2		--seq=DECK_SEQUENCE_UNEXIST in Duel.SendtoDeck(targets, player, seq, reason)
--Zone (Location + Sequence)
ZONE_ANY							=0xff	--zone=ZONE_ANY in Duel.SendtoBattle(targets, sumtype, sumplayer, target_player, nocheck, nolimit, pos, zone)
return DMTCG
