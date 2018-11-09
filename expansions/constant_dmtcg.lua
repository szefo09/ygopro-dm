--[[
	Duel Masters Trading Card Game Constants
	
	Usage: Put this file in the expansions folder
	
	Include the following code in your script
	
	local DMTCG=require "expansions.constant_dmtcg"
]]

local DMTCG={}

--Card ID
--↑Rule
CARD_DUEL_MASTERS_RULES				=24000000	--Duel Masters Rules (Unofficial card)
--↑Support
CARD_OBSIDIAN_SCARAB				=24005005	--"Obsidian Scarab" (DM-05 5/55)
CARD_AMBUSH_SCORPION				=24005046	--"Ambush Scorpion" (DM-05 46/55)
--↑EVENT_CUSTOM
CARD_CREEPING_PLAGUE				=24001049	--Duel.Raise[Single]Event(c|g,EVENT_CUSTOM+DM_EVENT_BECOMES_BLOCKED,e,0,0,0,0)
CARD_SPIRAL_GRASS					=24002010	--Duel.Raise[Single]Event(c|g,EVENT_CUSTOM+DM_EVENT_BLOCK,e,0,0,0,0)
CARD_MARROW_OOZE_THE_TWISTER		=24002032	--Duel.Raise[Single]Event(c|g,EVENT_CUSTOM+DM_EVENT_ATTACK_PLAYER,e,0,0,0,0)
CARD_BRUTAL_CHARGE					=24005049	--Duel.Raise[Single]Event(c|g,EVENT_CUSTOM+DM_EVENT_BREAK_SHIELD,e,0,0,0,0)
CARD_WOLFIS_BLUE_DIVINE_DRAGON		=24027		--Duel.Raise[Single]Event(c|g,EVENT_CUSTOM+DM_EVENT_BECOME_SHIELD_TRIGGER,e,0,0,0,0)
--↑RegisterFlagEffect
CARD_DIA_NORK_MOONLIGHT_GUARDIAN	=24001002	--c:RegisterFlagEffect(DM_EFFECT_BLOCKED,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
CARD_MIRACLE_QUEST					=24005019	--c:RegisterFlagEffect(DM_EFFECT_BREAK_SHIELD,RESET_PHASE+PHASE_END,0,1)
--Win Reason
DM_WIN_REASON_INVALID				=0x4d		--"[Player]'s deck was invalid."
DM_WIN_REASON_DECKOUT				=0x4e		--"[Player] ran out of cards in their deck."
--Setname
--↑Race
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
DM_RACE_GIANT						=0x1a		--"Forest Hornet" (DM-01 96/110)
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
DM_MAX_MANA_COST					=999		--"Dormageddon X, Forbidden Armageddon" (DMR-23 FFL1,FFL2,FFL3,FFL4,FFL5/FFL5)
--Location (Effect.SetRange)
DM_LOCATION_RULES					=LOCATION_FZONE						--Location of the rule card
--Location
DM_LOCATION_BATTLE					=LOCATION_MZONE						--Location of cards in the battle zone
DM_LOCATION_SHIELD					=LOCATION_SZONE						--Location of cards in the shield zone
DM_LOCATION_MANA					=LOCATION_GRAVE+LOCATION_REMOVED	--Location of cards in the mana zone
DM_LOCATION_GRAVE					=LOCATION_REMOVED					--Location of cards in the graveyard
--↑Location combinations
LOCATIONS_ALL						=0xff		--All locations
--Position
POS_FACEUP_UNTAPPED					=POS_FACEUP_ATTACK		--The position of an untapped card in the battle zone
POS_FACEDOWN_UNTAPPED				=POS_FACEDOWN_ATTACK	--N/A
POS_FACEUP_TAPPED					=POS_FACEUP_DEFENSE		--The position of a tapped card in the battle zone
POS_FACEDOWN_TAPPED					=POS_FACEDOWN_DEFENSE	--N/A
POS_MANA_UNTAPPED					=POS_FACEUP				--The position of an untapped card in the mana zone
POS_MANA_TAPPED						=POS_FACEDOWN			--The position of a tapped card in the mana zone
POS_UNTAPPED						=POS_ATTACK				--The position of an untapped card in the battle zone
POS_TAPPED							=POS_DEFENSE			--The position of a tapped card in the battle zone
--Type
DM_TYPE_RULE						=TYPE_SPELL+TYPE_FIELD	--The type of the rule card
DM_TYPE_CREATURE					=TYPE_EFFECT			--The type of a creature
DM_TYPE_NO_ABILITY					=TYPE_TUNER				--The type of a creature that has no abilities
DM_TYPE_EVOLUTION					=TYPE_SPSUMMON			--The type of an evolution creature
--Civilization
DM_CIVILIZATION_NONE				=0x00				--A card that has no civilization
DM_CIVILIZATION_ANY					=0xff				--A card that has any civilization
DM_CIVILIZATION_LIGHT				=ATTRIBUTE_LIGHT	--A card that has light civilization
DM_CIVILIZATION_WATER				=ATTRIBUTE_WATER	--A card that has water civilization
DM_CIVILIZATION_DARKNESS			=ATTRIBUTE_DARK		--A card that has darkness civilization
DM_CIVILIZATION_FIRE				=ATTRIBUTE_FIRE		--A card that has fire civilization
DM_CIVILIZATION_NATURE				=ATTRIBUTE_EARTH	--A card that has nature civilization
--↑Civilization combinations (Multicivilization)
DM_CIVILIZATIONS_LIGHT_WATER		=ATTRIBUTE_LIGHT+ATTRIBUTE_WATER	--A card that has light and water civilizations
DM_CIVILIZATIONS_LIGHT_DARKNESS		=ATTRIBUTE_LIGHT+ATTRIBUTE_DARK		--A card that has light and darkness civilizations
DM_CIVILIZATIONS_WATER_DARKNESS		=ATTRIBUTE_WATER+ATTRIBUTE_DARK		--A card that has water and darkness civilizations
DM_CIVILIZATIONS_LIGHT_FIRE			=ATTRIBUTE_LIGHT+ATTRIBUTE_FIRE		--A card that has light and fire civilizations
DM_CIVILIZATIONS_WATER_FIRE			=ATTRIBUTE_WATER+ATTRIBUTE_FIRE		--A card that has water and fire civilizations
DM_CIVILIZATIONS_DARKNESS_FIRE		=ATTRIBUTE_DARK+ATTRIBUTE_FIRE		--A card that has darkness and fire civilizations
DM_CIVILIZATIONS_LIGHT_NATURE		=ATTRIBUTE_LIGHT+ATTRIBUTE_EARTH	--A card that has light and nature civilizations
DM_CIVILIZATIONS_WATER_NATURE		=ATTRIBUTE_WATER+ATTRIBUTE_EARTH	--A card that has water and nature civilizations
DM_CIVILIZATIONS_DARKNESS_NATURE	=ATTRIBUTE_DARK+ATTRIBUTE_EARTH		--A card that has darkness and nature civilizations
DM_CIVILIZATIONS_FIRE_NATURE		=ATTRIBUTE_FIRE+ATTRIBUTE_EARTH		--A card that has fire and nature civilizations
--Reason
DM_REASON_BREAK						=0x20000000		--The reason for breaking a player's shield
--Summon Type
DM_SUMMON_TYPE_EVOLUTION			=SUMMON_TYPE_XYZ	--Summon a creature by evolving a creature in the battle zone
--Player
PLAYER_OWNER						=nil	--player=PLAYER_OWNER in Duel.Sendto..(targets, player, reason)
PLAYER_PLAYER						=0		--player=PLAYER_PLAYER in Effect.SetCondition(Auxiliary.TurnPlayerCondition(player)), etc.
PLAYER_OPPONENT						=1		--player=PLAYER_OPPONENT in Effect.SetCondition(Auxiliary.TurnPlayerCondition(player)), etc.
--Reset
DM_RESET_TOMANA						=RESET_TOGRAVE	--Reset a card's gained ability when it is put into the mana zone
DM_RESET_TOGRAVE					=RESET_REMOVE	--Reset a card's gained ability when it is put into the graveyard
--↑Reset combinations
RESETS_STANDARD						=0x1fe0000	--RESET_TURN_SET+RESET_TOGRAVE+RESET_REMOVE+RESET_TEMP_REMOVE+RESET_TOHAND+RESET_TODECK+RESET_LEAVE+RESET_TOFIELD
RESETS_REDIRECT						=0x47e0000	--RESETS_STANDARD+RESET_OVERLAY-RESET_TOFIELD-RESET_LEAVE (EFFECT_LEAVE_FIELD_REDIRECT)
--Type (for Effect.SetType)
DM_EFFECT_TYPE_CAST_SPELL			=EFFECT_TYPE_IGNITION			--Cast a spell
--Flag
DM_EFFECT_FLAG_SUMMON_PARAM			=EFFECT_FLAG_SPSUM_PARAM		--Included in a creature's summon procedure
DM_EFFECT_FLAG_ATTACK_TRIGGER		=0x10000000						--Included in all "Whenever this creature attacks" abilities
DM_EFFECT_FLAG_CHARGE				=0x20000000						--Included in all non-"Charger" spell abilities that put the spell in the mana zone after it's cast
--Code
DM_EFFECT_SUMMON_PROC				=EFFECT_SPSUMMON_PROC			--Summon creature procedure
DM_EFFECT_CANNOT_ATTACK_PLAYER		=EFFECT_CANNOT_DIRECT_ATTACK	--Cannot attack player
DM_EFFECT_ATTACK_PLAYER				=EFFECT_DIRECT_ATTACK			--Attack player
DM_EFFECT_CANNOT_CHANGE_POS_ABILITY	=EFFECT_CANNOT_CHANGE_POS_E		--Cannot untap or tap a card by an ability 
DM_EFFECT_UPDATE_POWER				=EFFECT_UPDATE_ATTACK			--Increase or decrease a creature's power
DM_EFFECT_UPDATE_MANA_COST			=EFFECT_UPDATE_LEVEL			--Increase or decrease a card's mana cost
DM_EFFECT_BROKEN_SHIELD				=CARD_DUEL_MASTERS_RULES		--Register a broken shield
DM_EFFECT_BLOCKED					=CARD_DIA_NORK_MOONLIGHT_GUARDIAN	--Register a creature that has become blocked
DM_EFFECT_BREAK_SHIELD				=CARD_MIRACLE_QUEST				--Register number of broken shields ("Miracle Quest" DM-05 19/55)
DM_EFFECT_BLOCKER					=701	--Blocker ("Dia Nork, Moonlight Guardian" DM-01 2/110)
DM_EFFECT_SHIELD_TRIGGER			=702	--Shield Trigger ("Holy Awe" DM-01 6/110)
DM_EFFECT_UNBLOCKABLE				=703	--Cannot be blocked ("Laser Wing" DM-01 11/110)
DM_EFFECT_SLAYER					=704	--Slayer ("Bone Assassin, the Ripper" DM-01 47/110)
DM_EFFECT_BREAKER					=705	--Breaker ("Gigaberos" DM-01 55/110)
DM_EFFECT_DOUBLE_BREAKER			=706	--Double Breaker ("Gigaberos" DM-01 55/110)
DM_EFFECT_POWER_ATTACKER			=707	--Power Attacker ("Brawler Zyler" DM-01 70/110)
DM_EFFECT_UNTAPPED_BE_ATTACKED		=708	--Can be attacked as though it were tapped ("Chaos Strike" DM-01 72/110)
DM_EFFECT_ATTACK_UNTAPPED			=709	--Can attack untapped creatures ("Gatling Skyterror" DM-01 79/110)
DM_EFFECT_CANNOT_ATTACK_CREATURE	=710	--Cannot attack creatures ("Diamond Cutter" DM-02 1/55)
DM_EFFECT_IGNORE_SUMMONING_SICKNESS	=711	--Ignore summoning sickness ("Diamond Cutter" DM-02 1/55)
DM_EFFECT_IGNORE_CANNOT_ATTACK		=712	--Ignore "This creature can't attack" ("Diamond Cutter" DM-02 1/55)
DM_EFFECT_IGNORE_CANNOT_ATTACK_PLAYER=713	--Ignore "This creature can't attack players" ("Diamond Cutter" DM-02 1/55)
DM_EFFECT_ATTACK_UNTAPPED_DARKNESS	=714	--Can attack untapped darkness creatures ("Aeris, Flight Elemental" DM-04 6/55)
DM_EFFECT_ATTACK_UNTAPPED_LIGHT		=715	--Can attack untapped light creatures ("Photocide, Lord of the Wastes" DM-04 34/55)
DM_EFFECT_TRIPLE_BREAKER			=716	--Triple Breaker ("Bolgash Dragon" DM-05 37/55)
DM_EFFECT_SPEED_ATTACKER			=717	--Speed Attacker ("Bombat, General of Speed" DM-05 38/55)
DM_EFFECT_ATTACK_UNTAPPED_WATER		=718	--Can attack untapped water creatures ("Ruthless Skyterror" DM-05 44/55)
DM_EFFECT_WINS_ALL_BATTLES			=799	--Wins All Battles ("Marshias, Spirit of the Sun" DM-14 S1/S10)
--DM_EFFECT_CHARGER					=000	--RESERVED --Charger ("Lightning Charger" DM-07 15/55")
--Abilities that trigger or actions that occur at the appropriate event
DM_EVENT_ATTACK_SHIELD				=EVENT_PRE_DAMAGE_CALCULATE		--Before an attacking creature breaks the opponent's shield
DM_EVENT_TO_GRAVE					=EVENT_REMOVE					--When a card is put into the graveyard
DM_EVENT_TO_MANA					=EVENT_TO_GRAVE					--When a card is put into the mana zone
DM_EVENT_COME_INTO_PLAY_SUCCESS		=EVENT_SPSUMMON_SUCCESS			--When a creature is put into the battle zone
DM_EVENT_ATTACK_END					=EVENT_DAMAGE_STEP_END			--When a creature finishes its attack
DM_EVENT_BECOMES_BLOCKED			=CARD_CREEPING_PLAGUE			--When a creature becomes blocked
DM_EVENT_BLOCK						=CARD_SPIRAL_GRASS				--When a creature blocks
DM_EVENT_ATTACK_PLAYER				=CARD_MARROW_OOZE_THE_TWISTER	--When a creature attacks a player
DM_EVENT_BREAK_SHIELD				=CARD_BRUTAL_CHARGE				--When a creature finishes attacking the opponent and broke a shield
DM_EVENT_BECOME_SHIELD_TRIGGER		=CARD_WOLFIS_BLUE_DIVINE_DRAGON	--When a shield becomes broken, it may get "Shield Trigger"
--Category (ability classification)
DM_CATEGORY_BLOCKER					=CATEGORY_NEGATE	--Blocker ability ("Dia Nork, Moonlight Guardian" DM-01 2/110)
--Description
--↑Play Description (for Effect.Description)
DM_DESC_SUMMON						=2		--"Play this card by summoning it."
DM_DESC_EVOLUTION					=1199	--"Play this card by putting it on a creature in the battle zone."
--↑Deck Error Hint Message (for Duel.Hint)
DM_DECKERROR_DECKCOUNT				=1450	--"Your deck must be exactly 40 cards!"
DM_DECKERROR_NONDM					=1451	--"You can't have any non-Duel Masters cards in your deck!"
--↑Gameplay Hint Message (for Duel.Hint)
DM_HINTMSG_NOTARGETS				=1650	--"There is no applicable card."
DM_HINTMSG_NOSTRIGGER				=1651	--"No "Shield Trigger" ability can be activated."
DM_HINTMSG_NOBZONES					=1652	--"You cannot put any more cards in the battle zone because all zones are occupied!"
DM_HINTMSG_NOSZONES					=1653	--"You cannot put any more cards in the shield zone because all zones are occupied!"
--↑Evergreen Keyword (for Effect.Description)
DM_DESC_EVOLUTION_RULE				=1499	--"If an evolution creature is moved from the battle zone to anywhere else, then the whole pile moves, not just the evolution creature on top."
DM_DESC_BLOCKED						=1659	--"Your creature has been blocked!"
DM_DESC_BLOCKER						=1660	--"Blocker (Whenever an opponent's creature attacks, you may tap this creature to stop the attack. Then the 2 creatures battle.)"
DM_DESC_SHIELD_TRIGGER_SPELL		=1661	--RESERVED	--"Shield Trigger (When this spell is put into your hand from your shield zone, you may cast it immediately for no cost.)"
DM_DESC_SLAYER						=1662	--"Slayer (Whenever this creature battles, destroy the other creature after the battle.)"
DM_DESC_SHIELD_TRIGGER_CREATURE		=1663	--"Shield Trigger (When this creature is put into your hand from your shield zone, you may summon it immediately for no cost.)"
DM_DESC_FIRE_NATURE_BLOCKER			=1664	--"Fire and nature blocker (Whenever an opponent's fire or nature creature attacks, you may tap this creature to stop the attack. Then the 2 creatures battle.)"
DM_DESC_NATURE_LIGHT_SLAYER			=1665	--"Nature and light slayer (Whenever this creature battles a nature or light creature, destroy the other creature after the battle.)"
--↑"Breaker" Keyword (for Effect.Description)
DM_DESC_NON_BREAKER					=1800	--"This creature breaks 1 shield."
DM_DESC_DOUBLE_BREAKER				=1801	--"Double Breaker (This creature breaks 2 shields.)"
DM_DESC_TRIPLE_BREAKER				=1802	--"Triple Breaker (This creature breaks 3 shields.)"
--↑Ability (for card hint)
DM_DESC_BROKEN						=300	--"Broken shield"
DM_DESC_SUMMONSICKNESS				=301	--"Summoning Sickness"
--Hint Message
DM_HINTMSG_APPLYABILITY				=556	--"Choose an ability to apply."
DM_HINTMSG_TOMANA					=600	--"Choose a card to put into the mana zone."
DM_HINTMSG_TAP						=601	--"Choose a card to tap."
DM_HINTMSG_LTAP						=602	--"Choose a light card to tap."
DM_HINTMSG_WTAP						=603	--"Choose a water card to tap."
DM_HINTMSG_DTAP						=604	--"Choose a darkness card to tap."
DM_HINTMSG_FTAP						=605	--"Choose a fire card to tap."
DM_HINTMSG_NTAP						=606	--"Choose a nature card to tap."
DM_HINTMSG_UNTAP					=607	--"Choose a card to untap."
DM_HINTMSG_BREAK					=608	--"Choose a shield to break."
DM_HINTMSG_TARGET					=609	--"Choose a target for the ability."
DM_HINTMSG_ATOHAND					=610	--"Choose a card to put into your hand."
DM_HINTMSG_RTOHAND					=611	--"Choose a card to return to its owner's hand."
DM_HINTMSG_DESTROY					=612	--"Choose a card to destroy."
DM_HINTMSG_DISCARD					=613	--"Choose a card to discard."
DM_HINTMSG_TOGRAVE					=614	--"Choose a card to put into the graveyard."
DM_HINTMSG_CREATURE					=615	--"Choose a creature."
DM_HINTMSG_EVOLVE					=616	--"Choose a creature to evolve."
DM_HINTMSG_CONFIRM					=617	--"Choose a card to look at it."
DM_HINTMSG_TODECK					=618	--"Choose a card to return to its owner's deck."
DM_HINTMSG_TOSHIELD					=619	--"Choose a card to add to your shields face-down."
DM_HINTMSG_TOBATTLE					=620	--"Choose a creature to put into the battle zone."
--Question Hint Message
DM_QHINTMSG_DRAW					=700	--"Draw a card(s)?"
DM_QHINTMSG_NUMBERDRAW				=701	--"Draw how many cards?"
DM_QHINTMSG_CHOOSE					=702	--"Choose a card(s)?"
DM_QHINTMSG_NUMBERCHOOSE			=703	--"Choose how many cards?"
DM_QHINTMSG_TOMANA					=704	--"Put a card(s) into your mana zone?"
--Timing
DM_TIMING_TAP_ABILITY				=TIMING_BATTLE_START+TIMING_BATTLE_END+TIMING_BATTLE_PHASE+TIMING_BATTLE_STEP_END	--Timing for a Tap Ability
--Deck Sequence
DECK_SEQUENCE_TOP					=0	--seq=DECK_SEQUENCE_TOP in Duel.SendtoDeck(targets, player, seq, reason)
DECK_SEQUENCE_BOTTOM				=1	--seq=DECK_SEQUENCE_BOTTOM in Duel.SendtoDeck(targets, player, seq, reason)
DECK_SEQUENCE_SHUFFLE				=2	--seq=DECK_SEQUENCE_SHUFFLE in Duel.SendtoDeck(targets, player, seq, reason)
DECK_SEQUENCE_UNEXIST				=-2	--seq=DECK_SEQUENCE_UNEXIST in Duel.SendtoDeck(targets, player, seq, reason)
--Zone (Location + Sequence)
ZONE_ANY							=0xff	--zone=ZONE_ANY in Duel.SendtoBattle(targets, sumtype, sumplayer, target_player, nocheck, nolimit, pos, zone)
return DMTCG
