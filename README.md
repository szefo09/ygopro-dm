# YGOPro-DM

<p align="center">
	<img src="https://user-images.githubusercontent.com/18324297/34651382-49c5daba-f3d8-11e7-9222-1488ac1761d8.png">
</p>

### How to Install
1. Exit [YGOPro](https://github.com/Fluorohydride/ygopro).
2. Put the following folders in YGOPro's main folder. **Make a backup of the original files, if you do not want to overwrite them**:<br>
-deck<br>
-expansions<br>
-textures
3. Optional: Click [here](https://mega.nz/#F!5RAFSIYb!nF8pJNkmZk4TzwMGtiX8Xw) to download card pics. Put all card pics in expansions\pics.

### How to Play
In [Yugioh](http://yugioh.wikia.com/wiki/Yu-Gi-Oh!_Trading_Card_Game) terms:
1. Start YGOPro.
2. Click on `Deck Management` to build your deck. Remember to add 1 *Duel Masters Rules* to your main deck!<br>
If you do not build your deck according to the following rules, you will lose the duel and have to rebuild your deck:<br>
	-Your main deck must be exactly 40 cards.<br>
	-All 40 cards must be Duel Masters cards. You cannot have any non-Duel Masters cards in your deck.<br>
3. Enable `Auto shield placement` or `Auto Spell/Trap Card placement` in the Settings menu so YGOPro will not tell you the names of the cards to set as shields.
4. Begin the duel with 1 life point, place the top 5 cards of your deck in your spell & trap zone face-down as [shields](http://duelmasters.wikia.com/wiki/Shield), then draw 5 cards. (You can only control a maximum of 5 shields in YGOPro.)
5. Start your turn by changing any defense position monsters you control to attack position and sending all your face-down banished cards to the graveyard.
6. During your draw phase, if it is not the first turn of the duel, draw 1 card. (There is no limit to the number of cards in your hand.)
7. Optional: During your standby phase, send 1 card from your hand to the graveyard.
8. Optional: During your main phase 1, by banishing cards from your graveyard face-down, equal to the level of a card in your hand, including at least 1 card with the same attribute as it, you can:<br>
	-Special summon it in attack position, if it is a [creature](http://duelmasters.wikia.com/wiki/Creature). (You can only control a maximum of 6 creatures in YGOPro.)<br>
	-Activate its effect in your hand, if it is a [spell](http://duelmasters.wikia.com/wiki/Spell), then banish it when its effect resolves.
9. Optional: During your battle phase, if you control an attack position monster that was not special summoned this turn, attack with it by changing it to defense position. (There is no limit to the number of times a monster can attack each turn as long as it is in attack position and can be changed to defense position.)<br>
Your attack position monsters can only attack an opponent's monster in defense position or attack your opponent directly by destroying their shields. If a monster is destroyed, banish it instead of sending it to the graveyard. (Neither player takes any battle damage.)
10. Skip your main phase 2.
11. During your end phase, "the end of your turn" effects activate and resolve. Then your turn ends.

### How to Win
1. If your opponent controls no shields, your attack position monsters can attack them directly to reduce their life points to 0.
2. If your opponent has no cards left in their deck.
3. [Some cards](http://duelmasters.wikia.com/wiki/Template:Alternate_Win_Condition) will enable you to win the duel via their [effects](http://duelmasters.wikia.com/wiki/Effect).

### Extra Information
<details>
<summary>Card Type</summary>

- Creature = `Monster + Effect (Attribute = Civilization, Level = Mana Cost, ATK = DEF = Power)`
	- Creature that has no abilities = `Monster + Effect + Tuner`
	- Evolution Creature = `Monster + Effect + Special Summon`
- Spell = `Monster + Spell (Attribute = Civilization, Level = Mana Cost)`
</details>
<details>
<summary>Attribute</summary>

- Light Civilization = `LIGHT Attribute`
- Water Civilization = `WATER Attribute`
- Darkness Civilization = `DARK Attribute`
- Fire Civilization = `FIRE Attribute`
- Nature Civilization = `EARTH Attribute`
</details>
<details>
<summary>Location</summary>

- Battle Zone = `Monster Zone`
- Shield Zone = `Spell & Trap Zone`
- Mana Zone (untapped cards) = `Graveyard`
- Mana Zone (tapped cards) = `Face-down banished cards` (text color = black)
- Graveyard = `Face-up banished cards` (text color = blue)
- Hyperspatial Zone = `Extra Deck`
</details>
<details>
<summary>Phase</summary>

1. Start of Turn Step (Untap Step) = `EVENT_PREDRAW` = Untap all your tapped cards.<br>
2. Draw Step = `PHASE_DRAW` = Draw a card from your deck.<br>
3. Charge Step = `PHASE_STANDBY` = You may put a card from your hand into your mana zone.<br>
4. Main Step = `PHASE_MAIN1` = You may use cards, such as summoning creatures, casting spells, generating and crossing cross gear or fortifying castles by paying the appropriate costs.<br>
5. Attack Step = `PHASE_BATTLE` = You may attack with creatures or use Tap Abilities.<br>
6. End Step = `PHASE_END` = Any abilities that trigger "the end of your turn" resolve now.
</details>
<details>
<summary>Card Search</summary>

You can search for the following specific card information in YGOPro:

- Card Ability: Use the `No Ability` tab for creatures that have [no abilities](http://duelmasters.wikia.com/wiki/Vanilla)
- Card Type: Use the `Card Type` tab or type `Type:` in the search bar
- Civilization: Use the `Civilization` (`Civ`) tab
- Evolution Creature: Use the `Evolution` tab or type `Type: Evolution Creature` in the search bar
- Mana Cost: Use the `Mana` tab
- Multicolored: Type `put into your mana zone tapped.)` in the search bar
- Power: Use the `Power` tab
- Race: Type `Race:` in the search bar
- Region-exclusive cards: Use the `Limitation` tab
- You can also search for cards whose abilities have been modified for YGOPro by typing `YGOPro`.
</details>
<details>
<summary>Glossary</summary>

- Ability = `Effect`
- Active Player = `Turn Player`
- Attack Step = `Battle Phase`
- Attack Trigger = `An effect that activates when a monster attacks`
- Break = `Destroy a card in the Spell & Trap Zone`
- Cast = `Activate this Spell's effect in your hand, by banishing cards from your Graveyard face-down equal to its Level, including at least 1 card with the same Attribute as it`
- Category Name ("Archetype") = [`Category`](https://www.db.yugioh-card.com/yugiohdb/deck_search.action?request_locale=en)
- Charge Mana = `Once per turn, during your Standby Phase, send 1 card from your hand to the Graveyard`
- Charge Step = `Standby Phase`
- Choose = `Target` (Japanese text contains 選 or 選ぶ)
- Civilization = `Attribute`
- Come Into Play = `If this card is Special Summoned:`
- Creature = `Monster`
- Defending Player = `Non-Turn Player`
- Discard = `Banish a card from a player's hand. (This is treated as discarding a card.)`
- Draw Step = `Draw Phase`
- End Step = `End Phase`
- Leave = `When a monster leaves the field`
- Look = `Look at a face-down card or a card that is not public knowledge`
- Main Step = `Main Phase 1`
- Mana = `Card in the Graveyard or a face-down banished card`
- Monocolored = `Card with a single Attribute`
- Multicolored = `Card with, or is treated as having, 2 or more Attributes`
- Power = `ATK` = `DEF`
- Put Into Graveyard = `If this card is banished:`
- Race (Category) = `Category` (similar to [Types](http://yugioh.wikia.com/wiki/Type) in Yugioh)
- Reveal = `Show a card`
- Search = `Look at a player's Deck`
- Shield = `Card in the Spell & Trap Zone`
- Static Ability = [`Continuous Effect`](http://yugioh.wikia.com/wiki/Continuous_Effect)
- Step = `Phase`
- Summon = `Special Summon this card (from your hand) in Attack Position, by banishing cards from your Graveyard face-down equal to its Level, including at least 1 card with the same Attribute as it`
- Summoning Sickness = `This card cannot attack the turn it is Special Summoned`
- Switch = `Switch the location of a card in the X Zone with a card in the Y Zone`
- Tap = `Change a monster to Defense Position/Banish a card from the Graveyard face-down`
- Tapped = `Defense Position/Face-down banished card`
- Trigger Ability = [`Trigger Effect`](http://yugioh.wikia.com/wiki/Trigger_Effect)
- Untap = `Change a monster to Attack Position/Send a face-down banished card to the Graveyard`
- Untap Step = `Before the turn player's normal draw`
- Untapped = `Attack Position/Card in the Graveyard`
- Up to = `0 to N` (For example, if a card tells you to "draw up to 3 cards", you can draw 0,1,2, or 3 cards.)
</details>
<details>
<summary>OT</summary>

- `0x5` = OCG only card (`0x1` OCG + `0x4` Anime/DIY)
- `0x6` = TCG only card (`0x2` TCG + `0x4` Anime/DIY)
- `0x7` = OCG + TCG card (`0x1` OCG + `0x2` TCG + `0x4` Anime/DIY)
- `0x21` = OCG only + game original card (`0x1` OCG + `0x4` Anime/DIY + `0x16` Video Game)
- `0x22` = TCG only + game original card (`0x2` TCG + `0x4` Anime/DIY + `0x16` Video Game)
- `0x23` = OCG + TCG + game original card (`0x1` OCG + `0x2` TCG + `0x4` Anime/DIY + `0x16` Video Game)
</details>
<details>
<summary>Category</summary>

- `0x1	Destroy Spell/Trap` = Decrease the number of cards in a player's shield zone
- `0x2	Destroy Monster` = Destroy a creature
- `0x4	Banish Card` = Put a card into the graveyard
- `0x8	Send to Graveyard` = Put a card into the mana zone
- `0x10	Return to Hand` = Return a card from the battle zone, shield zone, mana zone or graveyard to a player's hand
- `0x20	Return to Deck` = Put a card into a player's deck
- `0x40	Destroy Hand` = Decrease the opponent's hand size
- `0x80	Destroy Deck` = Decrease the opponent's deck size
- `0x100	Increase Draw` = Put a card from the top of a player's deck into a player's hand
- `0x200	Search Deck` = Look at a player's deck
- `0x400	GY to Hand/Field` = Put a card from the graveyard into a player's hand or in play
- `0x800	Change Battle Position` = Untap or tap a card
- `0x1000	Get Control` = ～Reserved～
- `0x2000	Increase/Decrease ATK/DEF` = Increase or decrease a creature's power
- `0x4000	Piercing` = No summoning sickness; ignore any effects that prevent creatures from attacking
- `0x8000	Attack Multiple Times` = Lists "can attack untapped creatures" in the card's text
- `0x10000	Limit Attack` = Prevent an attack from taking place; can't attack or can't attack players
- `0x20000	Direct Attack` = Lists "attacks each turn if able" or "blocks if able"
- `0x40000	Special Summon` = Evolution creature; shield trigger creature; put a card into the battle zone
- `0x80000	Token` = ～Reserved～
- `0x100000	Type-related` = Lists "race" or a particular race in the card's text
- `0x200000	Attribute-related` = Lists "civilization" or a particular civilization in the card's text
- `0x400000	Reduce LP` = Decrease the number of cards in a player's mana zone
- `0x800000	Increase LP` = Increase the number of cards in a player's shield zone
- `0x1000000	Cannot Be Destroyed` = Prevent a card from being destroyed
- `0x2000000	Cannot Be Targeted` = Prevent a creature from being blocked or chosen with an ability
- `0x4000000	Counter` = Prevent a player from casting spells
- `0x8000000	Gamble` = ～Reserved～
- `0x10000000	Fusion` = ～Reserved～
- `0x20000000	Synchro` = ～Reserved～
- `0x40000000	Xyz` = Evolution creature; lists "evolution" in the card's text
- `0x80000000	Negate Effect` = ～Reserved～
- Uncategorized: `Play for Free`, `Increase/Decrease Mana Cost`
</details>

#
Duel Masters Official Card Game
©2002 Shogakukan, Mitsui & Co., Ltd

Duel Masters Trading Card Game
©2004 Wizards of the Coast
