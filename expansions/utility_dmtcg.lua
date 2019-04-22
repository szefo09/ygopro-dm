--[[
	utility_dmtcg.lua

	Usage: Put this file in the expansions folder

	Include the following code in your script: local dm=require "expansions.utility_dmtcg"
]]

local Auxiliary={}
local DMTCG=require "expansions.constant_dmtcg"
DM_DESC_FN_BLOCKER=DM_DESC_FIRE_NATURE_BLOCKER
DM_DESC_NL_SLAYER=DM_DESC_NATURE_LIGHT_SLAYER
EFFECT_INDESTRUCTIBLE=EFFECT_INDESTRUCTABLE
EFFECT_INDESTRUCTIBLE_EFFECT=EFFECT_INDESTRUCTABLE_EFFECT
EFFECT_INDESTRUCTIBLE_BATTLE=EFFECT_INDESTRUCTABLE_BATTLE
HINTMSG_NUMBER=HINGMSG_NUMBER

--return a card script's name and id
--include in each script: local scard,sid=dm.GetID()
function Auxiliary.GetID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local scard=_G[str]
	local sid=tonumber(string.sub(str,2))
	return scard,sid
end
--========== Lua ==========
--Overwritten Lua functions
--return the value type of a variable
local lua_type=type
function type(o)
	local m=getmetatable(o)
	local t=m and m.__type or nil
	if t then return t
	elseif lua_type(o)~="userdata" then return lua_type(o)
	elseif m==Group then return "Group"
	elseif m==Effect then return "Effect"
	else return "Card" end
end
--New Lua functions
--select a random item from a table
function math.randomchoice(t)
	local keys={}
	for key,value in pairs(t) do
		keys[#keys+1]=key --store keys in another table
	end
	index=keys[math.random(1,#keys)]
	return t[index]
end
--========== Card ==========
--Overwritten Card functions
--check if a card can be put into the battle zone
local card_is_can_be_special_summoned=Card.IsCanBeSpecialSummoned
function Card.IsCanBeSpecialSummoned(c,...)
	if c:IsLocation(LOCATION_REMOVED) and c:IsFacedown() then
		return true --workaround to allow face-down banished monsters to special summon
	else return card_is_can_be_special_summoned(c,...) end
end
Card.IsCanSendtoBattle=Card.IsCanBeSpecialSummoned
--check if a card can be discarded from a player's hand
--reserved
--[[
local card_is_discardable=Card.IsDiscardable
function Card.IsDiscardable(c,...)
	if c:IsHasEffect(EFFECT_CANNOT_BE_DISCARD) then return false end
	return card_is_discardable(c,...)
end
]]
--check if a creature can attack
local card_is_attackable=Card.IsAttackable
function Card.IsAttackable(c)
	if c:IsHasEffect(DM_EFFECT_IGNORE_CANNOT_ATTACK) then return true end
	return card_is_attackable(c)
end
Card.IsCanAttack=Card.IsAttackable
--New Card functions
--check if a card is a creature
function Card.IsCreature(c)
	return c:IsType(DM_TYPE_CREATURE)
end
--check if a card is an evolution creature
function Card.IsEvolution(c)
	return c:IsType(DM_TYPE_EVOLUTION)
end
--check if a card is a spell
function Card.IsSpell(c)
	return c:IsType(TYPE_SPELL)
end
--check if a card is a multicolored card
function Card.IsMulticolored(c)
	return c:IsType(DM_TYPE_MULTICOLORED)
end
--check if a card is a shield
function Card.IsShield(c)
	return c:IsLocation(DM_LOCATION_SHIELD) and c:GetSequence()<5
end
--check if a card is untapped
function Card.IsUntapped(c)
	if c:IsLocation(LOCATION_GRAVE) then
		return c:IsFaceup()
	elseif c:IsLocation(LOCATION_MZONE) then
		return c:IsAttackPos()
	else return false end
end
--check if a card is tapped
function Card.IsTapped(c)
	if c:IsLocation(LOCATION_REMOVED) then
		return c:IsFacedown()
	elseif c:IsLocation(LOCATION_MZONE) then
		return c:IsDefensePos()
	else return false end
end
--check if a card can be untapped
function Card.IsAbleToUntap(c)
	if c:IsHasEffect(DM_EFFECT_CANNOT_CHANGE_POS_ABILITY) then return false end
	if c:IsLocation(LOCATION_REMOVED) then
		return c:IsAbleToGrave()
	elseif c:IsLocation(LOCATION_MZONE) then
		return c:IsDefensePos()
	else return false end
end
--check if a card can be tapped
--Note: Remove DM_EFFECT_IGNORE_TAP check if YGOPro allows a creature to tap itself for EFFECT_ATTACK_COST
function Card.IsAbleToTap(c)
	if c:IsHasEffect(DM_EFFECT_CANNOT_CHANGE_POS_ABILITY) or c:GetFlagEffect(DM_EFFECT_IGNORE_TAP)>0 then return false end
	if c:IsLocation(LOCATION_GRAVE) then
		return c:IsAbleToRemove()
	elseif c:IsLocation(LOCATION_MZONE) then
		return c:IsAttackPos()
	else return false end
end
--check if a card can be added to a player's shields face down
function Card.IsAbleToShield(c)
	return true--not c:IsHasEffect(DM_EFFECT_CANNOT_TO_SHIELD) --reserved
end
--check if a card is a broken shield
function Card.IsBrokenShield(c)
	return c:GetFlagEffect(DM_EFFECT_BROKEN_SHIELD)>0
end
--check if a card is in the mana zone
function Card.IsMana(c)
	return (c:IsUntapped() or c:IsTapped()) and c:IsLocation(DM_LOCATION_MANA)
end
--check if a card is in the graveyard
function Card.IsGrave(c)
	return c:IsFaceup() and c:IsLocation(DM_LOCATION_GRAVE)
end
--check if a spell can be cast for no cost
function Card.IsCanCastFree(c)
	return c:GetLevel()<=0
end
--check if a creature has become blocked
function Card.IsBlocked(c)
	return c:GetFlagEffect(DM_EFFECT_BLOCKED)>0
end
--check if a creature can attack players
function Card.IsCanAttackPlayer(c)
	if c:IsHasEffect(DM_EFFECT_IGNORE_CANNOT_ATTACK_PLAYER) then return true end
	return not c:IsHasEffect(DM_EFFECT_CANNOT_ATTACK_PLAYER)
end
--check if a creature can attack creatures
function Card.IsCanAttackCreature(c)
	return not c:IsHasEffect(DM_EFFECT_CANNOT_ATTACK_CREATURE)
end
--check if a creature can attack during the same turn it is summoned
function Card.IsCanAttackTurn(c)
	return c:IsEvolution() or c:IsHasEffect(DM_EFFECT_SPEED_ATTACKER) or c:IsHasEffect(DM_EFFECT_IGNORE_SUMMONING_SICKNESS)
end
--check if a creature can be attacked while untapped
function Card.IsCanBeUntappedAttacked(c)
	return c:IsHasEffect(DM_EFFECT_UNTAPPED_BE_ATTACKED)
end
--check if a creature can attack untapped creatures
function Card.IsCanAttackUntapped(c)
	return c:IsHasEffect(DM_EFFECT_ATTACK_UNTAPPED)
end
--check if a creature can trigger its "blocker" ability
function Card.IsCanBlock(c)
	return true--and not c:IsHasEffect(DM_EFFECT_CANNOT_BLOCK) --reserved
end
--check if a creature can break a shield
function Card.IsCanBreakShield(c)
	return true--and not c:IsHasEffect(DM_EFFECT_CANNOT_BREAK_SHIELD) --reserved
end
--return the number of shields a creature broke during the current turn
function Card.GetBrokenShieldCount(c)
	return c:GetFlagEffect(DM_EFFECT_BREAK_SHIELD)
end
--check if a creature can be summoned
function Card.DMIsSummonable(c)
	return not c:IsHasEffect(DM_EFFECT_CANNOT_SUMMON)
end
--check if a card has a particular race to put the appropriate evolution creature on it
function Card.DMIsEvolutionRace(c,race)
	return c:DMIsRace(race) or c:IsHasEffect(DM_EFFECT_EVOLUTION_ANY_RACE)
end
--reserved
--[[
--check if a card has a particular name category to put the appropriate evolution creature on it
function Card.DMIsEvolutionNameCategory(c,setname)
	return c:IsNameCategory(setname) or c:IsHasEffect(DM_EFFECT_EVOLUTION_ANY_CODE)
end
--check if a card has a particular civilization to put the appropriate evolution creature on it
function Card.DMIsEvolutionCivilization(c,civ)
	return c:IsCivilization(civ) or c:IsHasEffect(DM_EFFECT_EVOLUTION_ANY_CIVILIZATION)
end
]]
--return the amount of civilizations a card has
function Card.GetCivilizationCount(c)
	local civ=c:GetCivilization()
	if civ==DM_CIVILIZATION_LIGHT or civ==DM_CIVILIZATION_WATER or civ==DM_CIVILIZATION_DARKNESS
		or civ==DM_CIVILIZATION_FIRE or civ==DM_CIVILIZATION_NATURE then
		return 1
	elseif civ==DM_CIVILIZATIONS_LW or civ==DM_CIVILIZATIONS_LD or civ==DM_CIVILIZATIONS_WD
		or civ==DM_CIVILIZATIONS_LF or civ==DM_CIVILIZATIONS_WF or civ==DM_CIVILIZATIONS_DF
		or civ==DM_CIVILIZATIONS_LN or civ==DM_CIVILIZATIONS_WN or civ==DM_CIVILIZATIONS_DN
		or civ==DM_CIVILIZATIONS_FN then
		return 2
	elseif civ==DM_CIVILIZATIONS_DFN or civ==DM_CIVILIZATIONS_LFN or civ==DM_CIVILIZATIONS_LWD
		or civ==DM_CIVILIZATIONS_LWN or civ==DM_CIVILIZATIONS_WDF or civ==DM_CIVILIZATIONS_LDF
		or civ==DM_CIVILIZATIONS_LDN or civ==DM_CIVILIZATIONS_LWF or civ==DM_CIVILIZATIONS_WDN
		or civ==DM_CIVILIZATIONS_WFN then
		return 3
	elseif civ==DM_CIVILIZATIONS_LWDF then
		return 4
	elseif civ==DM_CIVILIZATIONS_LWDFN then
		return 5
	else return 0 end
end
--return the first or only civilization a card has
function Card.GetFirstCivilization(c)
	local civ=c:GetCivilization()
	if civ==DM_CIVILIZATION_LIGHT or civ==DM_CIVILIZATIONS_LW or civ==DM_CIVILIZATIONS_LD
		or civ==DM_CIVILIZATIONS_LF or civ==DM_CIVILIZATIONS_LN or civ==DM_CIVILIZATIONS_LFN
		or civ==DM_CIVILIZATIONS_LWD or civ==DM_CIVILIZATIONS_LWN or civ==DM_CIVILIZATIONS_LDF
		or civ==DM_CIVILIZATIONS_LDN or civ==DM_CIVILIZATIONS_LWF or civ==DM_CIVILIZATIONS_LWDF
		or civ==DM_CIVILIZATIONS_LWDFN then
		return DM_CIVILIZATION_LIGHT
	elseif civ==DM_CIVILIZATION_WATER or civ==DM_CIVILIZATIONS_WD or civ==DM_CIVILIZATIONS_WF
		or civ==DM_CIVILIZATIONS_WN or civ==DM_CIVILIZATIONS_WDF or civ==DM_CIVILIZATIONS_WDN
		or civ==DM_CIVILIZATIONS_WFN then
		return DM_CIVILIZATION_WATER
	elseif civ==DM_CIVILIZATION_DARKNESS or civ==DM_CIVILIZATIONS_DF or civ==DM_CIVILIZATIONS_DN
		or civ==DM_CIVILIZATIONS_DFN then
		return DM_CIVILIZATION_DARKNESS
	elseif civ==DM_CIVILIZATION_FIRE or civ==DM_CIVILIZATIONS_FN then
		return DM_CIVILIZATION_FIRE
	elseif civ==DM_CIVILIZATION_NATURE then
		return DM_CIVILIZATION_NATURE
	else return DM_CIVILIZATION_NONE end
end
--return the second civilization a multicolored card has
function Card.GetSecondCivilization(c)
	local civ=c:GetCivilization()
	if civ==DM_CIVILIZATIONS_LW or civ==DM_CIVILIZATIONS_LWD or civ==DM_CIVILIZATIONS_LWN
		or civ==DM_CIVILIZATIONS_LWF or civ==DM_CIVILIZATIONS_LWDF or civ==DM_CIVILIZATIONS_LWDFN then
		return DM_CIVILIZATION_WATER
	elseif civ==DM_CIVILIZATIONS_LD or civ==DM_CIVILIZATIONS_WD or civ==DM_CIVILIZATIONS_WDF
		or civ==DM_CIVILIZATIONS_LDF or civ==DM_CIVILIZATIONS_LDN or civ==DM_CIVILIZATIONS_WDN then
		return DM_CIVILIZATION_DARKNESS
	elseif civ==DM_CIVILIZATIONS_LF or civ==DM_CIVILIZATIONS_WF or civ==DM_CIVILIZATIONS_DF
		or civ==DM_CIVILIZATIONS_DFN or civ==DM_CIVILIZATIONS_LFN or civ==DM_CIVILIZATIONS_WFN then
		return DM_CIVILIZATION_FIRE
	elseif civ==DM_CIVILIZATIONS_LN or civ==DM_CIVILIZATIONS_WN or civ==DM_CIVILIZATIONS_DN
		or civ==DM_CIVILIZATIONS_FN then
		return DM_CIVILIZATION_NATURE
	else return DM_CIVILIZATION_NONE end
end
--return the third civilization a multicolored card has
function Card.GetThirdCivilization(c)
	local civ=c:GetCivilization()
	if civ==DM_CIVILIZATIONS_LWD or civ==DM_CIVILIZATIONS_LWDF or civ==DM_CIVILIZATIONS_LWDFN then
		return DM_CIVILIZATION_DARKNESS
	elseif civ==DM_CIVILIZATIONS_WDF or civ==DM_CIVILIZATIONS_LDF or civ==DM_CIVILIZATIONS_LWF then
		return DM_CIVILIZATION_FIRE
	elseif civ==DM_CIVILIZATIONS_DFN or civ==DM_CIVILIZATIONS_LFN or civ==DM_CIVILIZATIONS_LWN
		or civ==DM_CIVILIZATIONS_LDN or civ==DM_CIVILIZATIONS_WDN or civ==DM_CIVILIZATIONS_WFN then
		return DM_CIVILIZATION_NATURE
	else return DM_CIVILIZATION_NONE end
end
--return the fourth civilization a multicolored card has
function Card.GetFourthCivilization(c)
	local civ=c:GetCivilization()
	if civ==DM_CIVILIZATIONS_LWDF or civ==DM_CIVILIZATIONS_LWDFN then
		return DM_CIVILIZATION_FIRE
	else return DM_CIVILIZATION_NONE end
end
--return the fifth civilization a multicolored card has
function Card.GetFifthCivilization(c)
	local civ=c:GetCivilization()
	if civ==DM_CIVILIZATIONS_LWDFN then
		return DM_CIVILIZATION_NATURE
	else return DM_CIVILIZATION_NONE end
end
--reserved
--[[
--check if a card has a civilization
function Card.IsHasCivilization(c)
	return c:GetCivilization()~=DM_CIVILIZATION_NONE
end
]]
--check if a creature has a race
function Card.IsHasRace(c)
	local race=false
	local ct=1
	while ct<=4095 and race==false do
		if c:DMIsRace(ct) then
			race=true
		end
		ct=ct+1
	end
	return race
end
--reserved
--[[
--check if a creature has no abilities
function Card.IsHasNoAbility(c)
	return c:IsType(DM_TYPE_NO_ABILITY)
end
]]
--Renamed Card functions
--check if a card has a particular race
Card.DMIsRace=Card.IsSetCard
--reserved
--[[
--check if a card originally had a particular race
Card.DMIsOriginalRace=Card.IsOriginalSetCard
]]
--check if a card had a particular race when it was in the battle zone
Card.DMIsPreviousRace=Card.IsPreviousSetCard
--reserved
--[[
--check if a card is included in a particular name category
Card.IsNameCategory=Card.IsSetCard
--check if a card was originally included in a particular name category
Card.IsOriginalNameCategory=Card.IsOriginalSetCard
--check if a card was included in a particular name category when it was in the battle zone
Card.IsPreviousNameCategory=Card.IsPreviousSetCard
]]
--return a card's current mana cost
Card.GetManaCost=Card.GetLevel
--reserved
--[[
--return a card's original mana cost
Card.GetOriginalManaCost=Card.GetOriginalLevel
--return the mana cost a card had when it was in the battle zone
Card.GetPreviousManaCostOnField=Card.GetPreviousLevelOnField
]]
--check if a card's mana cost is equal to a given value
function Card.IsLevel(c,lv)
	return c:GetLevel()==lv
end
Card.IsManaCost=Card.IsLevel
--check if a card's mana cost is less than or equal to a given value
Card.IsManaCostBelow=Card.IsLevelBelow
--check if a card's mana cost is greater than or equal to a given value
Card.IsManaCostAbove=Card.IsLevelAbove
--return a card's current civilization
Card.GetCivilization=Card.GetAttribute
--reserved
--[[
--return a card's original civilization
Card.GetOriginalCivilization=Card.GetOriginalAttribute
--return the civilization a card had when it was in the battle zone
Card.GetPreviousCivilizationOnField=Card.GetPreviousAttributeOnField
]]
--check what a card's current civilization is
Card.IsCivilization=Card.IsAttribute
--return a creature's current power
Card.GetPower=Card.GetAttack
--reserved
--[[
--return a creature's original power
Card.GetBasePower=Card.GetBaseAttack
--return the power printed on a card
Card.GetTextPower=Card.GetTextAttack
--return the power a creature had when it was in the battle zone
Card.GetPreviousPowerOnField=Card.GetPreviousAttackOnField
]]
--check if a creature's power is equal to a given value
function Card.IsAttack(c,atk)
	return c:GetAttack()==atk
end
Card.IsPower=Card.IsAttack
--check if a creature's power is less than or equal to a given value
Card.IsPowerBelow=Card.IsAttackBelow
--check if a creature's power is greater than or equal to a given value
Card.IsPowerAbove=Card.IsAttackAbove
--check if a card can be put into the mana zone
Card.IsAbleToMana=Card.IsAbleToGrave
--check if a card can be put into the graveyard
Card.DMIsAbleToGrave=Card.IsAbleToRemove
--check if a card can be put into the graveyard as a cost
--Card.DMIsAbleToGraveAsCost=Card.IsAbleToRemoveAsCost --reserved
--return the cards stacked under a card
Card.GetStackGroup=Card.GetOverlayGroup
--return the number of cards stacked under a card
Card.GetStackCount=Card.GetOverlayCount
--========== Group ==========
--Overwritten Group functions
--select a specified card from a group
local group_filter_select=Group.FilterSelect
function Group.FilterSelect(g,player,f,min,max,ex,...)
	--Note: Remove this if YGOPro can forbid players to look at their face-down cards
	local sg1=g:Filter(Auxiliary.ShieldZoneFilter(f),ex,...)
	local sg2=Group.CreateGroup()
	for c in aux.Next(sg1) do
		if c:IsControler(player) then sg2:AddCard(c) end
	end
	if sg2:GetCount()>0 then
		return sg2:RandomSelect(player,min,max)
	else
		if not g:IsExists(f,1,ex,...) then
			Duel.Hint(HINT_MESSAGE,player,DM_HINTMSG_NOTARGETS)
		end
		return group_filter_select(g,player,f,min,max,ex,...)
	end
end
--select a card from a group
local group_select=Group.Select
function Group.Select(g,player,min,max,ex)
	--Note: Remove this if YGOPro can forbid players to look at their face-down cards
	local sg1=g:Filter(Auxiliary.ShieldZoneFilter(),ex)
	local sg2=Group.CreateGroup()
	for c in aux.Next(sg1) do
		if c:IsControler(player) then sg2:AddCard(c) end
	end
	if sg2:GetCount()>0 then
		return sg2:RandomSelect(player,min,max)
	else
		if g:GetCount()==0 then
			Duel.Hint(HINT_MESSAGE,player,DM_HINTMSG_NOTARGETS)
		end
		return group_select(g,player,min,max,ex)
	end
end
--select a number of cards from a group at random
--Note: Remove max_count if YGOPro can forbid players to look at their face-down cards
local group_random_select=Group.RandomSelect
function Group.RandomSelect(g,player,count,max_count)
	local ct=g:GetCount()
	local max_count=max_count or count
	if ct>0 then
		if max_count>count then
			if count==0 and not Duel.SelectYesNo(player,DM_QHINTMSG_CHOOSE) then
				return group_random_select(g,player,count,max_count)
			end
			if ct>max_count then ct=max_count end
			local t={}
			for i=1,ct do t[i]=i end
			Duel.Hint(HINT_SELECTMSG,player,DM_QHINTMSG_NUMBERCHOOSE)
			count=Duel.AnnounceNumber(player,table.unpack(t))
		end
	else
		Duel.Hint(HINT_MESSAGE,player,DM_HINTMSG_NOTARGETS)
	end
	return group_random_select(g,player,count,max_count)
end
--========== Duel ==========
--Fix missing Duel function errors
local duel_attack_cost_paid=Duel.AttackCostPaid
function Duel.AttackCostPaid()
	if duel_attack_cost_paid then
		return duel_attack_cost_paid()
	else return nil end
end
--Overwritten Duel functions
--put a card into a player's hand
local duel_send_to_hand=Duel.SendtoHand
function Duel.SendtoHand(targets,player,reason,use_shield_trigger)
	--use_shield_trigger: true if player can use the "shield trigger" ability of the returned shield
	if type(targets)=="Card" then targets=Group.FromCards(targets) end
	for tc1 in aux.Next(targets) do
		local g=tc1:GetStackGroup()
		targets:Merge(g)
	end
	local ct=duel_send_to_hand(targets,player,reason,use_shield_trigger)
	for tc2 in aux.Next(targets) do
		if use_shield_trigger then
			--raise event for "Shield Trigger"
			Duel.RaiseSingleEvent(tc2,EVENT_CUSTOM+DM_EVENT_TRIGGER_SHIELD_TRIGGER,Effect.GlobalEffect(),0,0,0,0)
		end
	end
	return ct
end
--put a card into a player's deck
local duel_send_to_deck=Duel.SendtoDeck
function Duel.SendtoDeck(targets,player,seq,reason)
	if type(targets)=="Card" then targets=Group.FromCards(targets) end
	for tc in aux.Next(targets) do
		local g=tc:GetStackGroup()
		targets:Merge(g)
	end
	local ct=duel_send_to_deck(targets,player,seq,reason)
	if seq==DECK_SEQUENCE_TOP or seq==DECK_SEQUENCE_BOTTOM then
		local dct1=Duel.GetOperatedGroup():FilterCount(Card.IsControler,nil,0)
		local dct2=Duel.GetOperatedGroup():FilterCount(Card.IsControler,nil,1)
		if dct1>1 then
			Duel.SortDecktop(player,0,dct1)
			if seq==DECK_SEQUENCE_BOTTOM then
				for i=1,dct1 do
					local mg=Duel.GetDecktopGroup(0,1)
					Duel.MoveSequence(mg:GetFirst(),DECK_SEQUENCE_BOTTOM)
				end
			end
		end
		if dct2>1 then
			Duel.SortDecktop(player,1,dct2)
			if seq==DECK_SEQUENCE_BOTTOM then
				for i=1,dct2 do
					local mg=Duel.GetDecktopGroup(1,1)
					Duel.MoveSequence(mg:GetFirst(),DECK_SEQUENCE_BOTTOM)
				end
			end
		end
	end
	return ct
end
--put a creature into the battle zone
local duel_special_summon=Duel.SpecialSummon
function Duel.SpecialSummon(targets,sumtype,sumplayer,target_player,nocheck,nolimit,pos,zone)
	if type(targets)=="Card" then targets=Group.FromCards(targets) end
	local zone=zone or ZONE_ANY
	local ct=0
	for tc in aux.Next(targets) do
		if Duel.GetLocationCount(target_player,DM_LOCATION_BATTLE)>0 then
			--check for "This creature is put into the battle zone tapped."
			if tc:IsHasEffect(DM_EFFECT_ENTER_BZONE_TAPPED) then pos=POS_FACEUP_TAPPED end
			if Duel.SpecialSummonStep(tc,sumtype,sumplayer,target_player,nocheck,nolimit,pos,zone) then
				ct=ct+1
			end
		else
			Duel.Hint(HINT_MESSAGE,sumplayer,DM_HINTMSG_NOBZONES)
			Duel.DMSendtoGrave(tc,REASON_RULE) --put into the graveyard if all zones are occupied
			ct=ct+1 --count the summon that would have happened because YGOPro's limitations prevented it
		end
	end
	Duel.SpecialSummonComplete()
	return ct
end
Duel.SendtoBattle=Duel.SpecialSummon
Duel.SendtoBattleStep=Duel.SpecialSummonStep
Duel.SendtoBattleComplete=Duel.SpecialSummonComplete
--change the position of a card
--Note: Added reason parameter
local duel_change_position=Duel.ChangePosition
function Duel.ChangePosition(targets,pos,reason)
	local reason=reason or 0
	return duel_change_position(targets,pos,reason)
end
--show a player a card
--Note: Added parameter turn_faceup to keep a shield face up
local duel_confirm_cards=Duel.ConfirmCards
function Duel.ConfirmCards(player,targets,turn_faceup)
	if turn_faceup then
		Duel.TurnShield(targets,POS_FACEUP)
	else
		return duel_confirm_cards(player,targets,turn_faceup)
	end
end
--draw equal to or less than a number of cards
local duel_draw=Duel.Draw
function Duel.Draw(player,count,reason)
	local ct=Duel.GetFieldGroupCount(player,LOCATION_DECK,0)
	if count>ct then count=ct end
	return duel_draw(player,count,reason)
end
--check if a player can draw equal to or less than a number of cards
local duel_is_player_can_draw=Duel.IsPlayerCanDraw
function Duel.IsPlayerCanDraw(player,count)
	local count=count or 0
	local ct=Duel.GetFieldGroupCount(player,LOCATION_DECK,0)
	if ct>0 and count>ct then count=ct end
	return duel_is_player_can_draw(player,count)
end
--discard a card
local discard_hand=Duel.DiscardHand
function Duel.DiscardHand(player,f,min,max,reason,ex,...)
	local max=max or min
	local reason=reason or REASON_EFFECT
	Duel.Hint(HINT_SELECTMSG,player,DM_HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(player,f,player,LOCATION_HAND,0,min,max,ex,...)
	if g:GetCount()==0 then
		return discard_hand(player,f,min,max,reason,ex,...)
	end
	return Duel.Remove(g,POS_FACEUP,reason+REASON_DISCARD)
end
--select a card
--Note: Shields are selected at random for abilities that select either player's shields
local duel_select_matching_card=Duel.SelectMatchingCard
function Duel.SelectMatchingCard(sel_player,f,player,s,o,min,max,ex,...)
	if sel_player==player and s==DM_LOCATION_SHIELD then
		--Note: Remove this if YGOPro can forbid players to look at their face-down cards
		local g=Duel.GetMatchingGroup(Auxiliary.ShieldZoneFilter(f),player,s,o,ex,...)
		return g:RandomSelect(sel_player,min,max)
	else
		if not Duel.IsExistingMatchingCard(f,player,s,o,1,ex,...) then
			Duel.Hint(HINT_MESSAGE,sel_player,DM_HINTMSG_NOTARGETS)
		end
		return duel_select_matching_card(sel_player,f,player,s,o,min,max,ex,...)
	end
end
--target a card
--Note: Shields are selected at random for abilities that select either player's shields
local duel_select_target=Duel.SelectTarget
function Duel.SelectTarget(sel_player,f,player,s,o,min,max,ex,...)
	if sel_player==player and s==DM_LOCATION_SHIELD then
		--Note: Remove this if YGOPro can forbid players to look at their face-down cards
		local g=Duel.GetMatchingGroup(Auxiliary.ShieldZoneFilter(f),player,s,o,ex,...)
		local sg=g:RandomSelect(sel_player,min,max)
		Duel.SetTargetCard(sg)
		return sg
	else
		if not Duel.IsExistingTarget(f,player,s,o,1,ex,...) then
			Duel.Hint(HINT_MESSAGE,sel_player,DM_HINTMSG_NOTARGETS)
		end
		return duel_select_target(sel_player,f,player,s,o,min,max,ex,...)
	end
end
--New Duel functions
--tap a creature in the battle zone or a card in the mana zone
function Duel.Tap(targets,reason)
	if type(targets)=="Card" then targets=Group.FromCards(targets) end
	local ct=0
	for tc in aux.Next(targets) do
		if tc:IsAbleToTap() then
			if tc:IsLocation(LOCATION_MZONE) then
				ct=ct+Duel.ChangePosition(tc,POS_FACEUP_TAPPED,reason)
			elseif tc:IsLocation(LOCATION_GRAVE) then
				ct=ct+Duel.Remove(tc,POS_FACEDOWN,reason)
			end
		end
	end
	return ct
end
--untap a creature in the battle zone or a card in the mana zone
function Duel.Untap(targets,reason)
	if type(targets)=="Card" then targets=Group.FromCards(targets) end
	local ct=0
	for tc in aux.Next(targets) do
		if tc:IsAbleToUntap() then
			if tc:IsLocation(LOCATION_MZONE) then
				ct=ct+Duel.ChangePosition(tc,POS_FACEUP_UNTAPPED,reason)
			elseif tc:IsLocation(LOCATION_REMOVED) then
				ct=ct+Duel.SendtoGrave(tc,reason)
			end
		end
	end
	return ct
end
--tap a card in the mana zone to summon a creature or to cast a spell
function Duel.PayManaCost(targets)
	if type(targets)=="Card" then targets=Group.FromCards(targets) end
	local ct=0
	for tc in aux.Next(targets) do
		ct=ct+Duel.Tap(targets,REASON_COST)
	end
	return ct
end
--turn a shield face up or down
function Duel.TurnShield(targets,pos)
	--pos: POS_FACEUP to turn face up or POS_FACEDOWN to turn face down
	if type(targets)=="Card" then targets=Group.FromCards(targets) end
	local ct=0
	for tc in aux.Next(targets) do
		ct=ct+Duel.ChangePosition(tc,pos)
	end
	return ct
end
--break a shield
--Note: Update this function each time new "breaker" abilities are introduced
--Not yet implemented: Quattro, world, galaxy, infinity, civilization, age, master
function Duel.BreakShield(e,sel_player,target_player,min,max,rc,reason,ignore_breaker)
	--sel_player: the player who selects a shield to break
	--target_player: the player whose shield to break
	--min,max: the minimum and maximum number of shields to break
	--rc: the creature that breaks a shield
	--reason: the reason for breaking a shield (generally REASON_EFFECT)
	--ignore_breaker: true to not break a number of shields according to the breaker abilities a creature may have
	local reason=reason or 0
	Duel.Tap(rc,REASON_RULE) --fix creature not being tapped when attacking
	local g=Duel.GetMatchingGroup(Auxiliary.ShieldZoneFilter(),target_player,DM_LOCATION_SHIELD,0,nil)
	if g:GetCount()==0 or not rc:IsCanBreakShield() then return 0 end
	if rc and not ignore_breaker then
		local m=_G["c"..rc:GetCode()]
		local db=rc:IsHasEffect(DM_EFFECT_DOUBLE_BREAKER)
		local tb=rc:IsHasEffect(DM_EFFECT_TRIPLE_BREAKER)
		local cb=rc:IsHasEffect(DM_EFFECT_CREW_BREAKER)
		if rc:GetEffectCount(DM_EFFECT_BREAKER)==1 then
			if db then min,max=2,2
			elseif tb then min,max=3,3
			elseif cb then min,max=m.crew_breaker_count(rc),m.crew_breaker_count(rc) end
		elseif rc:GetEffectCount(DM_EFFECT_BREAKER)>1 then
			local available_list={}
			if db then table.insert(available_list,1) end
			if tb then table.insert(available_list,2) end
			if cb then table.insert(available_list,3) end
			local option_list={}
			for _,te in pairs(available_list) do
				table.insert(option_list,Auxiliary.break_select_list[te])
			end
			Duel.Hint(HINT_SELECTMSG,sel_player,DM_HINTMSG_APPLYABILITY)
			local opt=Duel.SelectOption(sel_player,table.unpack(option_list))+1
			if opt==1 then min,max=2,2
			elseif opt==2 then min,max=3,3
			elseif opt==3 then min,max=m.crew_breaker_count(rc),m.crew_breaker_count(rc) end
		end
	end
	Duel.Hint(HINT_SELECTMSG,sel_player,DM_HINTMSG_BREAK)
	local sg=g:Select(sel_player,min,max,nil)
	Duel.HintSelection(sg)
	local ct=0
	--check for break replace abilities
	local to_grave=nil
	local t={rc:IsHasEffect(DM_EFFECT_BREAK_SHIELD_REPLACE)}
	if #t>0 then
		for _,te in pairs(t) do
			if te:GetValue()==DM_LOCATION_GRAVE then to_grave=true end
		end
		if to_grave then Duel.DMSendtoGrave(sg,reason) end
	else
		--register broken shields
		for sc in aux.Next(sg) do
			--add description
			sc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD-RESET_TOHAND-RESET_LEAVE,EFFECT_FLAG_CLIENT_HINT,1,0,DM_DESC_BROKEN)
			--register broken shield for Card.IsBrokenShield
			sc:RegisterFlagEffect(DM_EFFECT_BROKEN_SHIELD,RESET_EVENT+RESETS_STANDARD-RESET_TOHAND-RESET_LEAVE,0,1)
			--register broken shield for Card.GetBrokenShieldCount
			rc:RegisterFlagEffect(DM_EFFECT_BREAK_SHIELD,RESET_PHASE+PHASE_END,0,1)
			--register broken shield for Duel.GetBrokenShieldCount
			Duel.RegisterFlagEffect(rc:GetControler(),DM_EFFECT_BREAK_SHIELD,RESET_PHASE+PHASE_END,0,1)
		end
		--check for "Your opponent reveals shields broken by your creatures"
		if Duel.IsPlayerAffectedByEffect(1-rc:GetControler(),DM_EFFECT_CONFIRM_BROKEN_SHIELD) then
			Duel.ConfirmCards(rc:GetControler(),sg)
		end
		ct=ct+Duel.SendtoHand(sg,PLAYER_OWNER,reason+DM_REASON_BREAK)
		local og=Duel.GetOperatedGroup()
		for oc in aux.Next(og) do
			--add message
			if not oc:IsHasEffect(DM_EFFECT_SHIELD_TRIGGER) then Duel.Hint(HINT_MESSAGE,target_player,DM_HINTMSG_NOSTRIGGER) end
			--raise event for "Shield Trigger"
			Duel.RaiseSingleEvent(oc,EVENT_CUSTOM+DM_EVENT_TRIGGER_SHIELD_TRIGGER,Effect.GlobalEffect(),0,0,0,0)
		end
		local hg=Duel.GetFieldGroup(0,LOCATION_HAND,LOCATION_HAND)
		for hc in aux.Next(hg) do
			--reset broken shield for Card.IsBrokenShield
			if not og:IsContains(hc) then hc:ResetFlagEffect(DM_EFFECT_BROKEN_SHIELD) end
		end
		--raise event for "Whenever this creature breaks a shield" + re:GetHandler()==e:GetHandler()
		Duel.RaiseEvent(og,EVENT_CUSTOM+DM_EVENT_BREAK_SHIELD,e,0,0,0,0)
	end
	return ct
end
Auxiliary.break_select_list={
	[1]=DM_DESC_DOUBLE_BREAKER,
	[2]=DM_DESC_TRIPLE_BREAKER,
	[3]=DM_DESC_CREW_BREAKER,
}
--put a card into the mana zone
function Duel.SendtoMana(targets,pos,reason)
	--pos: POS_FACEUP_UNTAPPED to put in untapped position or POS_FACEUP_TAPPED to put in tapped position
	if type(targets)=="Card" then targets=Group.FromCards(targets) end
	--check for multicolored cards
	local g1=targets:Filter(Card.IsMulticolored,nil)
	targets:Sub(g1)
	local ct=0
	for tc in aux.Next(targets) do
		local g2=tc:GetStackGroup()
		if pos==POS_FACEUP_UNTAPPED then
			ct=ct+Duel.SendtoGrave(g2,reason)
			ct=ct+Duel.SendtoGrave(tc,reason)
		elseif pos==POS_FACEUP_TAPPED then
			ct=ct+Duel.Remove(g2,POS_FACEDOWN,reason)
			ct=ct+Duel.Remove(tc,POS_FACEDOWN,reason)
		end
	end
	--put multicolored cards into the mana zone tapped
	for tc in aux.Next(g1) do
		local g2=tc:GetStackGroup()
		ct=ct+Duel.Remove(g2,POS_FACEDOWN,REASON_RULE)
	end
	ct=ct+Duel.Remove(g1,POS_FACEDOWN,REASON_RULE)
	return ct
end
--put a card from the top of a player's deck into the mana zone
function Duel.SendDecktoptoMana(player,count,pos,reason)
	local g=Duel.GetDecktopGroup(player,count)
	Duel.DisableShuffleCheck()
	return Duel.SendtoMana(g,pos,reason)
end
--put up to a number of cards from the top of a player's deck into the mana zone
--reserved
--[[
function Duel.SendDecktoptoManaUpTo(player,count,pos,reason)
	local g=Duel.GetDecktopGroup(player,count)
	local ct=0
	repeat
		Duel.DisableShuffleCheck()
		ct=Duel.SendDecktoptoMana(player,1,pos,reason)
		count=count-ct
	until count<=0 or not Duel.IsPlayerCanSendDecktoptoMana(player,1) or not Duel.SelectYesNo(player,DM_QHINTMSG_TOMANAEXTRA)
	return ct
end
]]
--put a card into the graveyard
function Duel.DMSendtoGrave(targets,reason)
	if type(targets)=="Card" then targets=Group.FromCards(targets) end
	local ct=0
	for tc1 in aux.Next(targets) do
		local g=tc1:GetStackGroup()
		for tc2 in aux.Next(g) do
			ct=ct+Duel.Remove(tc2,POS_FACEUP,reason)
		end
		if tc1:IsLocation(LOCATION_REMOVED) and tc1:IsFacedown() then
			--workaround to banish a banished card
			if Duel.SendtoHand(tc1,PLAYER_OWNER,REASON_RULE)>0 then Duel.ConfirmCards(1-tc1:GetControler(),tc1) end
		end
		ct=ct+Duel.Remove(tc1,POS_FACEUP,reason)
	end
	return ct
end
--put a card from the top of a player's deck into the graveyard
function Duel.DMSendDecktoptoGrave(player,count,reason)
	local g=Duel.GetDecktopGroup(player,count)
	Duel.DisableShuffleCheck()
	return Duel.DMSendtoGrave(g,reason)
end
--check if a player can put a card from the top of their deck into the graveyard
--reserved
--[[
function Duel.DMIsPlayerCanSendDecktoptoGrave(player,count)
	local g=Duel.GetDecktopGroup(player,count)
	return g:FilterCount(Card.DMIsAbleToGrave,nil)>0
end
]]
--add a card to a player's shields face down
function Duel.SendtoShield(targets,player)
	--player: the player whose shields to add a card to (generally its owner)
	if type(targets)=="Card" then targets=Group.FromCards(targets) end
	local b=nil
	for tc1 in aux.Next(targets) do
		local g=tc1:GetStackGroup()
		for tc2 in aux.Next(g) do
			if tc2:IsAbleToShield() then
				if Duel.GetLocationCount(player,DM_LOCATION_SHIELD)>0 then
					b=Duel.MoveToField(tc2,player,player,DM_LOCATION_SHIELD,POS_FACEDOWN,true)
				else
					Duel.Hint(HINT_MESSAGE,player,DM_HINTMSG_NOSZONES)
					Duel.DMSendtoGrave(tc2,REASON_RULE) --put into the graveyard if all zones are occupied
					b=true --return true because YGOPro's limitations prevented there from being a new shield
				end
			end
		end
		if tc1:IsAbleToShield() then
			if Duel.GetLocationCount(player,DM_LOCATION_SHIELD)>0 then
				b=Duel.MoveToField(tc1,player,player,DM_LOCATION_SHIELD,POS_FACEDOWN,true)
			else
				Duel.Hint(HINT_MESSAGE,player,DM_HINTMSG_NOSZONES)
				Duel.DMSendtoGrave(tc1,REASON_RULE) --put into the graveyard if all zones are occupied
				b=true --return true because YGOPro's limitations prevented there from being a new shield
			end
		end
	end
	return b
end
--add a card from the top of a player's deck to their shields face down
function Duel.SendDecktoptoShield(player,count)
	local g=Duel.GetDecktopGroup(player,count)
	Duel.DisableShuffleCheck()
	return Duel.SendtoShield(g,player)
end
--add up to a number of cards from the top of a player's deck to their shields face down
function Duel.SendDecktoptoShieldUpTo(player,count)
	local ct=Duel.GetFieldGroupCount(player,LOCATION_DECK,0)
	if ct==0 or not Duel.IsPlayerCanSendDecktoptoShield(player,1)
		or not Duel.SelectYesNo(player,DM_QHINTMSG_TOSHIELD) then return end
	if ct>count then ct=count end
	local t={}
	for i=1,ct do t[i]=i end
	Duel.Hint(HINT_SELECTMSG,player,DM_QHINTMSG_NUMBERTOSHIELD)
	local an=Duel.AnnounceNumber(player,table.unpack(t))
	return Duel.SendDecktoptoShield(player,an)
end
--check if a player can add a card from the top of their deck to their shields face down
function Duel.IsPlayerCanSendDecktoptoShield(player,count)
	local g=Duel.GetDecktopGroup(player,count)
	return g:FilterCount(Card.IsAbleToShield,nil)>0
end
--draw up to a number of cards
function Duel.DrawUpTo(player,count,reason)
	local ct=Duel.GetFieldGroupCount(player,LOCATION_DECK,0)
	if ct>0 and Duel.IsPlayerCanDraw(player,1) and Duel.SelectYesNo(player,DM_QHINTMSG_DRAW) then
		if ct>count then ct=count end
		local t={}
		for i=1,ct do t[i]=i end
		Duel.Hint(HINT_SELECTMSG,player,DM_QHINTMSG_NUMBERDRAW)
		local an=Duel.AnnounceNumber(player,table.unpack(t))
		return Duel.Draw(player,an,reason)
	else return 0 end
end
--discard a card at random
function Duel.RandomDiscardHand(player,count,reason,ex)
	local reason=reason or REASON_EFFECT
	local g=Duel.GetFieldGroup(player,LOCATION_HAND,0)
	local extype=type(ex)
	if extype=="Card" then g:RemoveCard(ex)
	elseif extype=="Group" then g:Sub(ex) end
	local sg=g:RandomSelect(player,count)
	return Duel.Remove(sg,POS_FACEUP,reason+REASON_DISCARD)
end
--check if a player can use the "blocker" ability of their creatures
function Duel.IsPlayerCanBlock(player)
	return true--not Duel.IsPlayerAffectedByEffect(player,DM_EFFECT_CANNOT_BLOCK) --reserved
end
--return the creature that is blocking
function Duel.GetBlocker()
	local f=function(c)
		return c:GetFlagEffect(DM_EFFECT_BLOCKER)>0
	end
	return Duel.GetFirstMatchingCard(f,0,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,nil)
end
--return the number of shields a player has
function Duel.GetShieldCount(player)
	return Duel.GetMatchingGroupCount(Auxiliary.ShieldZoneFilter(),player,DM_LOCATION_SHIELD,0,nil)
end
--return the number of shields a player's creatures broke during the current turn
function Duel.GetBrokenShieldCount(player)
	return Duel.GetFlagEffect(player,DM_EFFECT_BREAK_SHIELD)
end
--check if a player can use the tap ability of their creatures
function Duel.IsPlayerCanUseTapAbility(player)
	return not Duel.IsPlayerAffectedByEffect(player,DM_EFFECT_CANNOT_USE_TAP_ABILITY)
end
--choose a race
function Duel.DMAnnounceRace(player)
	local opt=Duel.SelectOption(player,table.unpack(Auxiliary.race_desc_list))+1
	return Auxiliary.race_value_list[opt]
end
--Note: Update these lists each time new non-group races are introduced
Auxiliary.race_desc_list={
	DM_SELECT_RACE_ANGEL_COMMAND,
	DM_SELECT_RACE_ARMORED_DRAGON,
	DM_SELECT_RACE_ARMORED_WYVERN,
	DM_SELECT_RACE_ARMORLOID,
	DM_SELECT_RACE_BALLOON_MUSHROOM,
	DM_SELECT_RACE_BEAST_FOLK,
	DM_SELECT_RACE_BERSERKER,
	DM_SELECT_RACE_BRAIN_JACKER,
	DM_SELECT_RACE_CHIMERA,
	DM_SELECT_RACE_COLONY_BEETLE,
	DM_SELECT_RACE_CYBER_CLUSTER,
	DM_SELECT_RACE_CYBER_LORD,
	DM_SELECT_RACE_CYBER_MOON,
	DM_SELECT_RACE_CYBER_VIRUS,
	DM_SELECT_RACE_DARK_LORD,
	DM_SELECT_RACE_DEATH_PUPPET,
	DM_SELECT_RACE_DEMON_COMMAND,
	DM_SELECT_RACE_DEVIL_MASK,
	DM_SELECT_RACE_DRAGO_NOID,
	DM_SELECT_RACE_DUNE_GECKO,
	DM_SELECT_RACE_EARTH_DRAGON,
	DM_SELECT_RACE_EARTH_EATER,
	DM_SELECT_RACE_FIRE_BIRD,
	DM_SELECT_RACE_FISH,
	DM_SELECT_RACE_GEL_FISH,
	DM_SELECT_RACE_GHOST,
	DM_SELECT_RACE_GIANT,
	DM_SELECT_RACE_GIANT_INSECT,
	DM_SELECT_RACE_GLADIATOR,
	DM_SELECT_RACE_GUARDIAN,
	DM_SELECT_RACE_HEDRIAN,
	DM_SELECT_RACE_HORNED_BEAST,
	DM_SELECT_RACE_HUMAN,
	DM_SELECT_RACE_INITIATE,
	DM_SELECT_RACE_LEVIATHAN,
	DM_SELECT_RACE_LIGHT_BRINGER,
	DM_SELECT_RACE_LIQUID_PEOPLE,
	DM_SELECT_RACE_LIVING_DEAD,
	DM_SELECT_RACE_MACHINE_EATER,
	DM_SELECT_RACE_MECHA_DEL_SOL,
	DM_SELECT_RACE_MECHA_THUNDER,
	DM_SELECT_RACE_MELT_WARRIOR,
	DM_SELECT_RACE_MERFOLK,
	DM_SELECT_RACE_MYSTERY_TOTEM,
	DM_SELECT_RACE_NAGA,
	DM_SELECT_RACE_PANDORAS_BOX,
	DM_SELECT_RACE_PARASITE_WORM,
	DM_SELECT_RACE_PEGASUS,
	DM_SELECT_RACE_PHOENIX,
	DM_SELECT_RACE_RAINBOW_PHANTOM,
	DM_SELECT_RACE_ROCK_BEAST,
	DM_SELECT_RACE_SEA_HACKER,
	DM_SELECT_RACE_SNOW_FAERIE,
	DM_SELECT_RACE_SOLTROOPER,
	DM_SELECT_RACE_SPIRIT_QUARTZ,
	DM_SELECT_RACE_STARLIGHT_TREE,
	DM_SELECT_RACE_STARNOID,
	DM_SELECT_RACE_SURVIVOR,
	DM_SELECT_RACE_TREE_FOLK,
	DM_SELECT_RACE_VOLCANO_DRAGON,
	DM_SELECT_RACE_WILD_VEGGIES,
	DM_SELECT_RACE_XENOPARTS,
	DM_SELECT_RACE_ZOMBIE_DRAGON,
	--reserved
	--[[
	DM_SELECT_RACE_APOLLONIA_DRAGON,
	DM_SELECT_RACE_BEAST_FOLK_GO,
	DM_SELECT_RACE_FIRE_BIRD_EN,
	DM_SELECT_RACE_FLAME_COMMAND,
	DM_SELECT_RACE_GAIA_COMMAND,
	DM_SELECT_RACE_HUMAN_BAKU,
	DM_SELECT_RACE_HUMAN_JYA,
	DM_SELECT_RACE_LIQUID_PEOPLE_SEN,
	DM_SELECT_RACE_POSEIDIA_DRAGON,
	DM_SELECT_RACE_SNOW_FAERIE_KAZE,
	DM_SELECT_RACE_SOUL_COMMAND,
	DM_SELECT_RACE_WORLD_COMMAND,
	]]
}
Auxiliary.race_value_list={
	DM_RACE_ANGEL_COMMAND,
	DM_RACE_ARMORED_DRAGON,
	DM_RACE_ARMORED_WYVERN,
	DM_RACE_ARMORLOID,
	DM_RACE_BALLOON_MUSHROOM,
	DM_RACE_BEAST_FOLK,
	DM_RACE_BERSERKER,
	DM_RACE_BRAIN_JACKER,
	DM_RACE_CHIMERA,
	DM_RACE_COLONY_BEETLE,
	DM_RACE_CYBER_CLUSTER,
	DM_RACE_CYBER_LORD,
	DM_RACE_CYBER_MOON,
	DM_RACE_CYBER_VIRUS,
	DM_RACE_DARK_LORD,
	DM_RACE_DEATH_PUPPET,
	DM_RACE_DEMON_COMMAND,
	DM_RACE_DEVIL_MASK,
	DM_RACE_DRAGO_NOID,
	DM_RACE_DUNE_GECKO,
	DM_RACE_EARTH_DRAGON,
	DM_RACE_EARTH_EATER,
	DM_RACE_FIRE_BIRD,
	DM_RACE_FISH,
	DM_RACE_GEL_FISH,
	DM_RACE_GHOST,
	DM_RACE_GIANT,
	DM_RACE_GIANT_INSECT,
	DM_RACE_GLADIATOR,
	DM_RACE_GUARDIAN,
	DM_RACE_HEDRIAN,
	DM_RACE_HORNED_BEAST,
	DM_RACE_HUMAN,
	DM_RACE_INITIATE,
	DM_RACE_LEVIATHAN,
	DM_RACE_LIGHT_BRINGER,
	DM_RACE_LIQUID_PEOPLE,
	DM_RACE_LIVING_DEAD,
	DM_RACE_MACHINE_EATER,
	DM_RACE_MECHA_DEL_SOL,
	DM_RACE_MECHA_THUNDER,
	DM_RACE_MELT_WARRIOR,
	DM_RACE_MERFOLK,
	DM_RACE_MYSTERY_TOTEM,
	DM_RACE_NAGA,
	DM_RACE_PANDORAS_BOX,
	DM_RACE_PARASITE_WORM,
	DM_RACE_PEGASUS,
	DM_RACE_PHOENIX,
	DM_RACE_RAINBOW_PHANTOM,
	DM_RACE_ROCK_BEAST,
	DM_RACE_SEA_HACKER,
	DM_RACE_SNOW_FAERIE,
	DM_RACE_SOLTROOPER,
	DM_RACE_SPIRIT_QUARTZ,
	DM_RACE_STARLIGHT_TREE,
	DM_RACE_STARNOID,
	DM_RACE_SURVIVOR,
	DM_RACE_TREE_FOLK,
	DM_RACE_VOLCANO_DRAGON,
	DM_RACE_WILD_VEGGIES,
	DM_RACE_XENOPARTS,
	DM_RACE_ZOMBIE_DRAGON,
	--reserved
	--[[
	DM_RACE_APOLLONIA_DRAGON,
	DM_RACE_BEAST_FOLK_GO,
	DM_RACE_FIRE_BIRD_EN,
	DM_RACE_FLAME_COMMAND,
	DM_RACE_GAIA_COMMAND,
	DM_RACE_HUMAN_BAKU,
	DM_RACE_HUMAN_JYA,
	DM_RACE_LIQUID_PEOPLE_SEN,
	DM_RACE_POSEIDIA_DRAGON,
	DM_RACE_SNOW_FAERIE_KAZE,
	DM_RACE_SOUL_COMMAND,
	DM_RACE_WORLD_COMMAND,
	]]
}
--list of all existing mana costs for Duel.AnnounceNumber
Auxiliary.mana_cost_list={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,20,24,25,30,39,40,50,71,99,999,}
--cast a spell immediately for no cost
function Duel.CastFree(targets)
	if type(targets)=="Card" then targets=Group.FromCards(targets) end
	for tc in aux.Next(targets) do
		Duel.DisableShuffleCheck(true)
		Duel.SendtoHand(tc,PLAYER_OWNER,REASON_RULE)
		Duel.RaiseSingleEvent(tc,EVENT_CUSTOM+DM_EVENT_CAST_FREE,tc:GetReasonEffect(),0,0,0,0)
		Duel.DisableShuffleCheck(false)
	end
end
--Renamed Duel functions
--let 2 creatures do battle with each other
Duel.DoBattle=Duel.CalculateDamage
--put a card on top of another card
Duel.PutOnTop=Duel.Overlay
--choose a civilization
Duel.AnnounceCivilization=Duel.AnnounceAttribute
--check if a player can put a card from the top of their deck into the mana zone
Duel.IsPlayerCanSendDecktoptoMana=Duel.IsPlayerCanDiscardDeck
--check if a player can put a card from the top of their deck into the mana zone as a cost
--Duel.IsPlayerCanSendDecktoptoManaAsCost=Duel.IsPlayerCanDiscardDeckAsCost --reserved
--========== Auxiliary ==========
--add a description to a card that lists the effects it gained
--the description is removed if con_func returns false
function Auxiliary.AddEffectDescription(c,desc_id,con_func)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(DM_LOCATION_BATTLE)
	if con_func then e1:SetCondition(con_func) end
	e1:SetOperation(Auxiliary.AddEffectDescOperation(desc_id))
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	if con_func then e2:SetCondition(aux.NOT(con_func)) end
	e2:SetOperation(Auxiliary.RemoveEffectDescOperation(desc_id))
	c:RegisterEffect(e2)
end
function Auxiliary.AddEffectDescOperation(desc_id)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				local desc=aux.Stringid(c:GetOriginalCode(),desc_id)
				if c:GetFlagEffect(300+desc_id)==0 then
					c:RegisterFlagEffect(300+desc_id,RESET_EVENT+RESETS_STANDARD+RESET_DISABLE,EFFECT_FLAG_CLIENT_HINT,1,0,desc)
				end
			end
end
function Auxiliary.RemoveEffectDescOperation(desc_id)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				if c:GetFlagEffect(300+desc_id)>0 then
					c:ResetFlagEffect(300+desc_id)
				end
			end
end
--sort cards on the top or bottom of a player's deck
--sort_player: the player who sorts the cards
--target_player: the player whose deck to sort cards from
--ct: the number of cards to sort
--seq: DECK_SEQUENCE_TOP to sort the top cards or DECK_SEQUENCE_BOTTOM to sort the bottom cards
function Auxiliary.SortDeck(sort_player,target_player,ct,seq)
	local ft=Duel.GetFieldGroupCount(target_player,LOCATION_DECK,0)
	if ft<ct then ct=ft end
	if ct>1 then Duel.SortDecktop(sort_player,target_player,ct) end
	if seq~=DECK_SEQUENCE_BOTTOM or ct<=0 then return end
	local g=Duel.GetDecktopGroup(target_player,1)
	if ct>1 then
		for i=1,ct do
			Duel.MoveSequence(g:GetFirst(),seq)
		end
	else Duel.MoveSequence(g:GetFirst(),seq) end
end
--check if an evolution creature evolves from a specified race
--include this in each evolution creature's script that evolves from a specified race
--required for "Spiritual Star Dragon" (DM-13 12/55)
function Auxiliary.IsEvolutionListRace(c,...)
	if not c.evolution_race_list then return false end
	local race_list={...}
	for _,race in ipairs(race_list) do
		for _,erace in ipairs(c.evolution_race_list) do
			if erace==race then return true end
		end
	end
	return false
end

--add procedure and rules to creature
function Auxiliary.AddSummonProcedure(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(DM_DESC_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(DM_EFFECT_SUMMON_PROC)
	e1:SetProperty(DM_EFFECT_FLAG_SUMMON_PARAM+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_UNTAPPED,0)
	e1:SetCondition(Auxiliary.NonEvolutionSummonCondition)
	e1:SetOperation(Auxiliary.NonEvolutionSummonOperation)
	e1:SetValue(DM_SUMMON_TYPE_NORMAL)
	c:RegisterEffect(e1)
end
function Auxiliary.PayManaFilter(c)
	return c:IsUntapped()
end
function Auxiliary.NonEvolutionSummonCondition(e,c)
	if c==nil then return true end
	if c:IsEvolution() or not c:DMIsSummonable() then return false end
	local tp=c:GetControler()
	local cost=c:GetManaCost()
	local civ_count=c:GetCivilizationCount()
	local g=Duel.GetMatchingGroup(Auxiliary.PayManaFilter,tp,DM_LOCATION_MANA,0,nil)
	if Duel.GetLocationCount(tp,DM_LOCATION_BATTLE)<=0 or g:GetCount()<cost or civ_count>cost then return false end
	return Auxiliary.PayManaCondition(g,c,civ_count)
end
function Auxiliary.PayManaCondition(g,c,civ_count)
	local b1=g:IsExists(Card.IsCivilization,1,nil,c:GetFirstCivilization())
	local b2=g:IsExists(Card.IsCivilization,1,nil,c:GetSecondCivilization())
	local b3=g:IsExists(Card.IsCivilization,1,nil,c:GetThirdCivilization())
	local b4=g:IsExists(Card.IsCivilization,1,nil,c:GetFourthCivilization())
	local b5=g:IsExists(Card.IsCivilization,1,nil,c:GetFifthCivilization())
	if civ_count==1 then
		return b1
	elseif civ_count==2 then
		return b1 and b2
	elseif civ_count==3 then
		return b1 and b2 and b3
	elseif civ_count==4 then
		return b1 and b2 and b3 and b4
	elseif civ_count==5 then
		return b1 and b2 and b3 and b4 and b5
	end
end
function Auxiliary.PayManaSelect(g,sel_player,c,mana_cost,civ_count)
	Duel.Hint(HINT_SELECTMSG,sel_player,DM_HINTMSG_TAP)
	local sg1=g:FilterSelect(sel_player,Card.IsCivilization,1,1,nil,c:GetFirstCivilization())
	g:Sub(sg1)
	if civ_count>=2 then
		Duel.Hint(HINT_SELECTMSG,sel_player,DM_HINTMSG_TAP)
		local sg2=g:FilterSelect(sel_player,Card.IsCivilization,1,1,nil,c:GetSecondCivilization())
		g:Sub(sg2)
		sg1:Merge(sg2)
	end
	if civ_count>=3 then
		Duel.Hint(HINT_SELECTMSG,sel_player,DM_HINTMSG_TAP)
		local sg3=g:FilterSelect(sel_player,Card.IsCivilization,1,1,nil,c:GetThirdCivilization())
		g:Sub(sg3)
		sg1:Merge(sg3)
	end
	if civ_count>=4 then
		Duel.Hint(HINT_SELECTMSG,sel_player,DM_HINTMSG_TAP)
		local sg4=g:FilterSelect(sel_player,Card.IsCivilization,1,1,nil,c:GetFourthCivilization())
		g:Sub(sg4)
		sg1:Merge(sg4)
	end
	if civ_count==5 then
		Duel.Hint(HINT_SELECTMSG,sel_player,DM_HINTMSG_TAP)
		local sg5=g:FilterSelect(sel_player,Card.IsCivilization,1,1,nil,c:GetFifthCivilization())
		g:Sub(sg5)
		sg1:Merge(sg5)
	end
	Duel.Hint(HINT_SELECTMSG,sel_player,DM_HINTMSG_TAP)
	local sg6=g:Select(sel_player,mana_cost-civ_count,mana_cost-civ_count,nil)
	sg1:Merge(sg6)
	Duel.PayManaCost(sg1)
end
function Auxiliary.NonEvolutionSummonOperation(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(Auxiliary.PayManaFilter,tp,DM_LOCATION_MANA,0,nil)
	Auxiliary.PayManaSelect(g,tp,c,c:GetManaCost(),c:GetCivilizationCount())
end
--function to prevent multiple "shield trigger" abilities from chaining
function Auxiliary.AddShieldTriggerChainLimit(c,effect,con_func,prop)
	local con_func=con_func or aux.TRUE
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		e:GetLabelObject():SetLabel(0)
	end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		if rp==1-tp or not re:IsHasCategory(DM_CATEGORY_SHIELD_TRIGGER) then return end
		e:GetLabelObject():SetLabel(1)
	end)
	c:RegisterEffect(e2)
	local e3=effect:Clone()
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAIN_END)
	if prop then
		e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY+prop)
	else
		e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	end
	e3:SetCondition(aux.AND(Auxiliary.ShieldTriggerCondition2,con_func))
	c:RegisterEffect(e3)
	e1:SetLabelObject(e3)
	e2:SetLabelObject(e3)
end
function Auxiliary.EnableCreatureAttribute(c)
	--summon procedure
	Auxiliary.AddSummonProcedure(c)
	--summon for no cost using "shield trigger"
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(DM_DESC_SHIELD_TRIGGER_CREATURE)
	e1:SetCategory(DM_CATEGORY_SHIELD_TRIGGER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CUSTOM+DM_EVENT_TRIGGER_SHIELD_TRIGGER)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(Auxiliary.ShieldTriggerCondition1)
	e1:SetTarget(Auxiliary.ShieldTriggerSummonTarget)
	e1:SetOperation(Auxiliary.ShieldTriggerSummonOperation)
	c:RegisterEffect(e1)
	--prevent multiple "shield trigger" abilities from chaining
	Auxiliary.AddShieldTriggerChainLimit(c,e1)
	--cannot be battle target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(DM_LOCATION_BATTLE)
	e2:SetCondition(Auxiliary.CannotBeBattleTargetCondition)
	e2:SetValue(Auxiliary.CannotBeBattleTargetValue)
	c:RegisterEffect(e2)
	--attack shield
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(DM_EVENT_ATTACK_SHIELD)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCondition(Auxiliary.AttackShieldCondition)
	e3:SetTarget(Auxiliary.AttackShieldTarget)
	e3:SetOperation(Auxiliary.AttackShieldOperation)
	c:RegisterEffect(e3)
end
--cannot be battle target
function Auxiliary.CannotBeBattleTargetCondition(e)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsUntapped() and not c:IsCanBeUntappedAttacked()
end
function Auxiliary.CannotBeBattleTargetValue(e,c)
	--check for "This creature can attack untapped CIVILIZATION creatures."
	local t={c:IsHasEffect(DM_EFFECT_ATTACK_UNTAPPED)}
	local civ=0
	for _,te in pairs(t) do
		civ=civ+te:GetValue()
	end
	if civ>0 then
		return not e:GetHandler():IsCivilization(civ)
	else
		return not c:IsCanAttackUntapped()
	end
end
--attack shield
function Auxiliary.AttackShieldCondition(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(Auxiliary.ShieldZoneFilter(),tp,0,DM_LOCATION_SHIELD,1,nil)
		and Duel.GetTurnPlayer()==tp and Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()==nil
end
function Auxiliary.AttackShieldTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) end
end
function Auxiliary.AttackShieldOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--raise event for "Whenever this creature attacks a player"
	Duel.RaiseSingleEvent(c,EVENT_CUSTOM+DM_EVENT_ATTACK_PLAYER,e,0,0,0,0)
	--raise event for "Whenever any of your creatures attacks a player"
	--Duel.RaiseEvent(c,EVENT_CUSTOM+DM_EVENT_ATTACK_PLAYER,e,0,0,0,0) --reserved
	local sel_player=tp
	--check for "Whenever an opponent's creature would break a shield, you choose the shield instead of your opponent."
	if Duel.IsPlayerAffectedByEffect(1-tp,DM_EFFECT_CHANGE_SHIELD_BREAK_PLAYER) then sel_player=1-tp end
	Duel.BreakShield(e,sel_player,1-tp,1,1,c)
	--ignore yugioh rules
	--no battle damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.ChangeBattleDamage(1-tp,0)
	end)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)	
end

--add procedure to evolution creature
function Auxiliary.AddEvolutionProcedure(c,f1,f2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(DM_DESC_EVOLUTION)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(DM_EFFECT_SUMMON_PROC)
	e1:SetProperty(DM_EFFECT_FLAG_SUMMON_PARAM+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_UNTAPPED,0)
	e1:SetCondition(Auxiliary.EvolutionCondition(f1,f2))
	e1:SetTarget(Auxiliary.EvolutionTarget(f1,f2))
	e1:SetOperation(Auxiliary.EvolutionOperation)
	e1:SetValue(DM_SUMMON_TYPE_EVOLUTION)
	c:RegisterEffect(e1)
end
function Auxiliary.EvolutionFilter1(c,g,f1,f2)
	return c:IsFaceup() and (not f1 or f1(c)) and (not f2 or g:IsExists(Auxiliary.EvolutionFilter2,1,c,f2))
end
function Auxiliary.EvolutionFilter2(c,f)
	return c:IsFaceup() and (not f or f(c))
end
function Auxiliary.EvolutionCondition(f1,f2)
	return	function(e,c)
				if c==nil then return true end
				if not c:DMIsSummonable() then return false end
				local tp=c:GetControler()
				local g1=Duel.GetMatchingGroup(Auxiliary.PayManaFilter,tp,DM_LOCATION_MANA,0,nil)
				local g2=Duel.GetFieldGroup(tp,DM_LOCATION_BATTLE,0)
				local cost=c:GetManaCost()
				local civ_count=c:GetCivilizationCount()
				local field_count=-1
				if f2 then field_count=-2 end
				if Duel.GetLocationCount(tp,DM_LOCATION_BATTLE)<field_count or g1:GetCount()<cost or civ_count>cost
					or not g2:IsExists(Auxiliary.EvolutionFilter1,1,nil,g2,f1,f2) then return false end
				return Auxiliary.PayManaCondition(g1,c,civ_count)
			end
end
function Auxiliary.EvolutionTarget(f1,f2)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c)
				local g=Duel.GetFieldGroup(tp,DM_LOCATION_BATTLE,0)
				Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_EVOLVE)
				local sg1=g:FilterSelect(tp,Auxiliary.EvolutionFilter1,1,1,nil,g,f1,f2)
				Duel.HintSelection(sg1)
				local tc=sg1:GetFirst()
				local pos=tc:GetPosition()
				if f2 then
					Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_EVOLVE)
					local sg2=g:FilterSelect(tp,Auxiliary.EvolutionFilter2,1,1,tc,f2)
					Duel.HintSelection(sg2)
					sg1:Merge(sg2)
				end
				if sg1 then
					sg1:KeepAlive()
					e:SetLabelObject(sg1)
					if not f2 then e:SetTargetRange(pos,0) end
					return true
				else return false end
			end
end
function Auxiliary.EvolutionOperation(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.GetMatchingGroup(Auxiliary.PayManaFilter,tp,DM_LOCATION_MANA,0,nil)
	Auxiliary.PayManaSelect(g1,tp,c,c:GetManaCost(),c:GetCivilizationCount())
	local g2=e:GetLabelObject()
	for tc in aux.Next(g2) do
		local sg=tc:GetStackGroup()
		if sg:GetCount()>0 then
			Duel.PutOnTop(c,sg)
		end
	end
	c:SetMaterial(g2)
	Duel.PutOnTop(c,g2)
	g2:DeleteGroup()
end

--add rules to spell
--reserved
function Auxiliary.EnableSpellAttribute(c)
end
--function for spell casting
--desc_id: the id of the effect's text (0~15)
--prop: include EFFECT_FLAG_CARD_TARGET for a targeting ability
function Auxiliary.AddSpellCastEffect(c,desc_id,targ_func,op_func,prop,cost_func,con_func,cate)
	--cost_func: include dm.CastSpellCost for a spell without "shield trigger"
	local con_func=con_func or aux.TRUE
	--cast for cost
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	if cate then e1:SetCategory(cate) end
	e1:SetType(DM_EFFECT_TYPE_CAST_SPELL)
	if prop then e1:SetProperty(prop) end
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(con_func)
	if cost_func then
		e1:SetCost(cost_func)
	else
		e1:SetCost(Auxiliary.CastSpellCost)
	end
	if targ_func then e1:SetTarget(targ_func) end
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
	--cast for no cost using "shield trigger"
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	if cate then
		e2:SetCategory(DM_CATEGORY_SHIELD_TRIGGER+cate)
	else
		e2:SetCategory(DM_CATEGORY_SHIELD_TRIGGER)
	end
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+DM_EVENT_TRIGGER_SHIELD_TRIGGER)
	if prop then
		e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY+prop)
	else
		e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	end
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(aux.AND(Auxiliary.ShieldTriggerCondition1,con_func))
	if cost_func then e2:SetCost(cost_func) end
	if targ_func then e2:SetTarget(targ_func) end
	e2:SetOperation(op_func)
	c:RegisterEffect(e2)
	--prevent multiple "shield trigger" abilities from chaining
	Auxiliary.AddShieldTriggerChainLimit(c,e2,con_func,prop)
	--cast for no cost without using "shield trigger"
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	if cate then e3:SetCategory(cate) end
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_CUSTOM+DM_EVENT_CAST_FREE)
	if prop then e3:SetProperty(prop) end
	e3:SetCondition(con_func)
	if cost_func then e3:SetCost(cost_func) end
	if targ_func then e3:SetTarget(targ_func) end
	e3:SetOperation(op_func)
	c:RegisterEffect(e3)
	--cast when getting "shield trigger"
	local e4=e3:Clone()
	e4:SetCode(EVENT_CUSTOM+DM_EVENT_BECOME_SHIELD_TRIGGER)
	c:RegisterEffect(e4)
end
--cost function for casting spells
function Auxiliary.CastSpellCost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if c:IsCanCastFree() then return true end
	local cost=c:GetManaCost()
	local civ_count=c:GetCivilizationCount()
	local g=Duel.GetMatchingGroup(Auxiliary.PayManaFilter,tp,DM_LOCATION_MANA,0,nil)
	if g:GetCount()<cost or civ_count>cost then return false end
	local b1=g:IsExists(Card.IsCivilization,1,nil,c:GetFirstCivilization())
	local b2=g:IsExists(Card.IsCivilization,1,nil,c:GetSecondCivilization())
	local b3=g:IsExists(Card.IsCivilization,1,nil,c:GetThirdCivilization())
	local b4=g:IsExists(Card.IsCivilization,1,nil,c:GetFourthCivilization())
	local b5=g:IsExists(Card.IsCivilization,1,nil,c:GetFifthCivilization())
	if chk==0 then
		if civ_count==1 then
			return b1
		elseif civ_count==2 then
			return b1 and b2
		elseif civ_count==3 then
			return b1 and b2 and b3
		elseif civ_count==4 then
			return b1 and b2 and b3 and b4
		elseif civ_count==5 then
			return b1 and b2 and b3 and b4 and b5
		end
	end
	Auxiliary.PayManaSelect(g,tp,c,cost,civ_count)
end

--c: the card that grants the ability
--tc: the card that gets the ability
--desc_id: the id of the effect's text (0~15)
--prop: include EFFECT_FLAG_CARD_TARGET for a targeting ability

--function for a static ability that grants a card an ability
--e.g. "Dia Nork, Moonlight Guardian" (DM-01 2/110), "Brawler Zyler" (DM-01 70/110), "Deadly Fighter Braid Claw" (DM-01 74/110)
function Auxiliary.EnableEffectCustom(c,code,con_func,s_range,o_range,targ_func)
	--code: DM_EFFECT_BLOCKER, DM_EFFECT_POWER_ATTACKER, EFFECT_MUST_ATTACK, etc.
	local e1=Effect.CreateEffect(c)
	if s_range or o_range then
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(DM_LOCATION_BATTLE)
		e1:SetTargetRange(s_range,o_range)
		if targ_func then e1:SetTarget(targ_func) end
	else
		e1:SetType(EFFECT_TYPE_SINGLE)
	end
	e1:SetCode(code)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	if con_func then e1:SetCondition(con_func) end
	c:RegisterEffect(e1)
end
--function for a static ability that grants a player an ability
--e.g. "Alcadeias, Lord of Spirits" (DM-04 1/55), "Kyuroro" (DM-06 36/110)
function Auxiliary.EnablePlayerEffectCustom(c,code,s_range,o_range,val,con_func)
	--code: EFFECT_CANNOT_ACTIVATE, DM_EFFECT_CHANGE_SHIELD_BREAK_PLAYER, etc.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(code)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetTargetRange(s_range,o_range)
	if con_func then e1:SetCondition(con_func) end
	if val then e1:SetValue(val) end
	c:RegisterEffect(e1)
end
--function for a granted ability
--e.g. "Chaos Strike" (DM-01 72/110), "Diamond Cutter" (DM-02 1/55), "Rumble Gate" (DM-02 44/55)
function Auxiliary.RegisterEffectCustom(c,tc,desc_id,code,reset_flag,reset_count)
	--code: DM_EFFECT_UNTAPPED_BE_ATTACKED, DM_EFFECT_IGNORE_SUMMONING_SICKNESS, DM_EFFECT_ATTACK_UNTAPPED, etc.
	local reset_flag=reset_flag or RESET_PHASE+PHASE_END
	local reset_count=reset_count or 1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(code)
	if code==DM_EFFECT_CANNOT_CHANGE_POS_ABILITY then
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT)
	else
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	end
	if tc==c then
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+reset_flag,reset_count)
	else
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+reset_flag,reset_count)
	end
	tc:RegisterEffect(e1)
end
--"Blocker (Whenever an opponent's creature attacks, you may tap this creature to stop the attack. Then the 2 creatures battle.)"
--"Whenever an opponent's CIVILIZATION1 or CIVILIZATION2 creature attacks, you may tap this creature to stop the attack. Then the 2 creatures battle."
--e.g. "Dia Nork, Moonlight Guardian" (DM-01 2/110), "Lurking Eel" (DM-05 18/55), "Sasha, Channeler of Suns" (DM-08 12/55)
function Auxiliary.EnableBlocker(c,con_func,desc,f)
	--desc: DM_DESC_FN_BLOCKER for "Fire and nature blocker", DM_DESC_DRAGON_BLOCKER for "Dragon blocker", etc.
	--f: include function for "CIVILIZATION blocker" or "RACE blocker"
	local con_func=con_func or aux.TRUE
	local e1=Effect.CreateEffect(c)
	if desc then
		e1:SetDescription(desc)
	else
		e1:SetDescription(DM_DESC_BLOCKER)
	end
	e1:SetCategory(DM_CATEGORY_BLOCKER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetCondition(aux.AND(Auxiliary.BlockerCondition1(f),aux.NOT(Auxiliary.BlockerCondition2),con_func))
	e1:SetCost(Auxiliary.BlockerCost)
	e1:SetTarget(Auxiliary.BlockerTarget)
	e1:SetOperation(Auxiliary.BlockerOperation)
	c:RegisterEffect(e1)
	--block if able
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e2:SetProperty(0)
	e2:SetCondition(aux.AND(Auxiliary.BlockerCondition1(f),Auxiliary.BlockerCondition2,con_func))
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_CUSTOM+DM_EVENT_TRIGGER_BLOCKER)
	c:RegisterEffect(e3)
	Auxiliary.EnableEffectCustom(c,DM_EFFECT_BLOCKER,con_func)
end
function Auxiliary.BlockerCondition1(f)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local d=Duel.GetAttackTarget()
				if d and d==e:GetHandler() then return false end
				local a=Duel.GetAttacker()
				return a:GetControler()~=tp and (not f or f(a))
			end
end
function Auxiliary.BlockerCondition2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsHasEffect(DM_EFFECT_MUST_BLOCK)
end
function Auxiliary.BlockerCost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsFaceup() and c:IsUntapped() and Duel.GetFlagEffect(tp,DM_EFFECT_BLOCKER)==0 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RegisterFlagEffect(tp,DM_EFFECT_BLOCKER,RESET_CHAIN,0,1)
end
function Auxiliary.BlockerTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBlock() and Duel.IsPlayerCanBlock(tp) end
end
function Auxiliary.BlockerOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Tap(c,REASON_EFFECT)
	local a=Duel.GetAttacker()
	if not a or a:IsImmuneToEffect(e) or c:IsImmuneToEffect(e) or a:IsStatus(STATUS_ATTACK_CANCELED) then return end
	Duel.Tap(a,REASON_RULE) --fix creature not being tapped when attacking
	Duel.NegateAttack()
	--register flag effect for Card.IsBlocked
	a:RegisterFlagEffect(DM_EFFECT_BLOCKED,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE,0,1)
	--add blocked prompt
	Duel.Hint(HINT_OPSELECTED,1-tp,DM_DESC_BLOCKED)
	--register flag effect for Duel.GetBlocker
	c:RegisterFlagEffect(DM_EFFECT_BLOCKER,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE,0,1)
	--raise event for "Whenever this creature becomes blocked"
	Duel.RaiseSingleEvent(a,EVENT_CUSTOM+DM_EVENT_BECOME_BLOCKED,e,0,0,0,0)
	--raise event for "Whenever any of your creatures becomes blocked"
	Duel.RaiseEvent(a,EVENT_CUSTOM+DM_EVENT_BECOME_BLOCKED,e,0,0,0,0)
	--check for "Whenever this creature blocks/becomes blocked, no battle happens. (Both creatures stay tapped.)"
	if not c:IsHasEffect(DM_EFFECT_NO_BLOCK_BATTLE) and not a:IsHasEffect(DM_EFFECT_NO_BE_BLOCKED_BATTLE) then
		Duel.BreakEffect()
		Duel.DoBattle(a,c)
	end
end
--"Each of your creatures has "Blocker"."
--e.g. "Sieg Balicula, the Intense" (DM-03 8/55), "Gallia Zohl, Iron Guardian Q" (DM-05 8/55)
function Auxiliary.AddStaticEffectBlocker(c,s_range,o_range,targ_func,con_func)
	local s_range=s_range or LOCATION_ALL
	local o_range=o_range or 0
	local targ_func=targ_func or aux.TRUE
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(DM_DESC_BLOCKER)
	e1:SetCategory(DM_CATEGORY_BLOCKER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetCondition(aux.AND(Auxiliary.BlockerCondition1(),aux.NOT(Auxiliary.BlockerCondition2)))
	e1:SetCost(Auxiliary.BlockerCost)
	e1:SetTarget(Auxiliary.BlockerTarget)
	e1:SetOperation(Auxiliary.BlockerOperation)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(DM_LOCATION_BATTLE)
	e2:SetTargetRange(s_range,o_range)
	if con_func then e2:SetCondition(con_func) end
	e2:SetTarget(targ_func)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--block if able
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e3:SetProperty(0)
	e3:SetCondition(aux.AND(Auxiliary.BlockerCondition1(),Auxiliary.BlockerCondition2))
	local e4=e2:Clone()
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_CUSTOM+DM_EVENT_TRIGGER_BLOCKER)
	local e6=e2:Clone()
	e6:SetLabelObject(e5)
	c:RegisterEffect(e6)
	Auxiliary.EnableEffectCustom(c,DM_EFFECT_BLOCKER,nil,s_range,o_range,targ_func)
end
--function for a granted "Blocker" ability
--e.g. "Full Defensor" (DM-04 9/55)
function Auxiliary.RegisterEffectBlocker(c,tc,desc_id,reset_flag,reset_count)
	local reset_flag=reset_flag or RESET_PHASE+PHASE_END
	local reset_count=reset_count or 1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(DM_DESC_BLOCKER)
	e1:SetCategory(DM_CATEGORY_BLOCKER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetCondition(aux.AND(Auxiliary.BlockerCondition1(),aux.NOT(Auxiliary.BlockerCondition2)))
	e1:SetTarget(Auxiliary.BlockerTarget)
	e1:SetOperation(Auxiliary.BlockerOperation)
	if tc==c then
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+reset_flag,reset_count)
	else
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+reset_flag,reset_count)
	end
	tc:RegisterEffect(e1)
	--block if able
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e2:SetProperty(0)
	e2:SetCondition(aux.AND(Auxiliary.BlockerCondition1(),Auxiliary.BlockerCondition2))
	tc:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_CUSTOM+DM_EVENT_TRIGGER_BLOCKER)
	tc:RegisterEffect(e3)
	Auxiliary.RegisterEffectCustom(c,tc,desc_id,DM_EFFECT_BLOCKER,reset_flag,reset_count)
end
--"Shield trigger (When this spell is put into your hand from your shield zone, you may cast it immediately for no cost.)"
--"Shield trigger (When this creature is put into your hand from your shield zone, you may summon it immediately for no cost.)"
--e.g. "Holy Awe" (DM-01 6/110), "Amber Grass" (DM-04 7/55)
function Auxiliary.EnableShieldTrigger(c)
	Auxiliary.EnableEffectCustom(c,DM_EFFECT_SHIELD_TRIGGER)
end
function Auxiliary.ShieldTriggerCondition1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsHasEffect(DM_EFFECT_SHIELD_TRIGGER)
end
function Auxiliary.ShieldTriggerCondition2(e,tp,eg,ep,ev,re,r,rp)
	return Auxiliary.ShieldTriggerCondition1(e,tp,eg,ep,ev,re,r,rp) and e:GetLabel()==1 and e:GetHandler():IsBrokenShield()
end
function Auxiliary.ShieldTriggerSummonTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():DMIsSummonable() end
end
function Auxiliary.ShieldTriggerSummonOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoBattle(c,DM_SUMMON_TYPE_NORMAL,tp,tp,false,false,POS_FACEUP_UNTAPPED)
	end
end
--"Power attacker +N000 (While attacking, this creature gets +N000 power.)"
--e.g. "Brawler Zyler" (DM-01 70/110)
function Auxiliary.EnablePowerAttacker(c,val,con_func)
	local con_func=con_func or aux.TRUE
	Auxiliary.EnableUpdatePower(c,val,aux.AND(Auxiliary.SelfAttackerCondition,con_func))
	Auxiliary.EnableEffectCustom(c,DM_EFFECT_POWER_ATTACKER,con_func)
end
--"Each of your creatures has "Power attacker +N000"."
--e.g. "Überdragon Jabaha" (DM-03 43/55), "Terradragon Hulcoon Berga" (Game Original)
function Auxiliary.AddStaticEffectPowerAttacker(c,val,s_range,o_range,targ_func,con_func)
	local s_range=s_range or LOCATION_ALL
	local o_range=o_range or 0
	local targ_func=targ_func or aux.TRUE
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(DM_EFFECT_UPDATE_POWER)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetCondition(Auxiliary.SelfAttackerCondition)
	e1:SetValue(val)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(DM_LOCATION_BATTLE)
	e2:SetTargetRange(s_range,o_range)
	if con_func then e2:SetCondition(con_func) end
	e2:SetTarget(targ_func)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	Auxiliary.EnableEffectCustom(c,DM_EFFECT_POWER_ATTACKER,nil,s_range,o_range,targ_func)
end
--function for a granted "Power attacker +N000" ability
--e.g. "Burning Power" (DM-01 71/110)
function Auxiliary.RegisterEffectPowerAttacker(c,tc,desc_id,val,reset_flag,reset_count)
	local reset_flag=reset_flag or RESET_PHASE+PHASE_END
	local reset_count=reset_count or 1
	Auxiliary.RegisterEffectUpdatePower(c,tc,desc_id,val,reset_flag,reset_count,Auxiliary.SelfAttackerCondition)
	Auxiliary.RegisterEffectCustom(c,tc,desc_id,DM_EFFECT_POWER_ATTACKER,reset_flag,reset_count)
end
--"Slayer (Whenever this creature battles, destroy the other creature after the battle.)"
--"CIVILIZATION1 and CIVILIZATION2 slayer (Whenever this creature battles a CIVILIZATION1 or CIVILIZATION2 creature, destroy the other creature after the battle.)"
--e.g. "Bone Assassin, the Ripper" (DM-01 47/110), "Gigakail" (DM-05 26/55)
function Auxiliary.EnableSlayer(c,con_func,desc,f)
	--desc: DM_DESC_NL_SLAYER for "Nature and light slayer", etc.
	--f: include function for "CIVILIZATION slayer"
	local con_func=con_func or aux.TRUE
	local e1=Effect.CreateEffect(c)
	if desc then
		e1:SetDescription(desc)
	else
		e1:SetDescription(DM_DESC_SLAYER)
	end
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(DM_EVENT_ATTACK_END)
	e1:SetCondition(aux.AND(Auxiliary.SlayerCondition(f),con_func))
	e1:SetTarget(Auxiliary.HintTarget)
	e1:SetOperation(Auxiliary.SlayerOperation)
	c:RegisterEffect(e1)
	Auxiliary.EnableEffectCustom(c,DM_EFFECT_SLAYER,con_func)
end
function Auxiliary.SlayerCondition(f)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local tc=e:GetHandler():GetBattleTarget()
				e:SetLabelObject(tc)
				return tc and tc:IsRelateToBattle() and (not f or f(tc))
			end
end
function Auxiliary.SlayerOperation(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsRelateToBattle() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
--"Each of your creatures has "Slayer"."
--e.g. "Gigaling Q" (DM-05 27/55), "Frost Specter, Shadow of Age" (DM-06 54/110)
function Auxiliary.AddStaticEffectSlayer(c,s_range,o_range,targ_func)
	local s_range=s_range or LOCATION_ALL
	local o_range=o_range or 0
	local targ_func=targ_func or aux.TRUE
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(DM_DESC_SLAYER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(DM_EVENT_ATTACK_END)
	e1:SetCondition(Auxiliary.SlayerCondition())
	e1:SetTarget(Auxiliary.HintTarget)
	e1:SetOperation(Auxiliary.SlayerOperation)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(DM_LOCATION_BATTLE)
	e2:SetTargetRange(s_range,o_range)
	e2:SetTarget(targ_func)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	Auxiliary.EnableEffectCustom(c,DM_EFFECT_SLAYER,nil,s_range,o_range,targ_func)
end
--function for a granted "Slayer" ability
--e.g. "Creeping Plague" (DM-01 49/110)
function Auxiliary.RegisterEffectSlayer(c,tc,desc_id,reset_flag,reset_count)
	local reset_flag=reset_flag or RESET_PHASE+PHASE_END
	local reset_count=reset_count or 1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(DM_DESC_SLAYER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(DM_EVENT_ATTACK_END)
	e1:SetCondition(Auxiliary.SlayerCondition())
	e1:SetTarget(Auxiliary.HintTarget)
	e1:SetOperation(Auxiliary.SlayerOperation)
	if tc==c then
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE-DM_RESET_TOGRAVE-RESET_LEAVE+reset_flag,reset_count)
	else
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-DM_RESET_TOGRAVE-RESET_LEAVE+reset_flag,reset_count)
	end
	tc:RegisterEffect(e1)
	Auxiliary.RegisterEffectCustom(c,tc,desc_id,DM_EFFECT_SLAYER,-DM_RESET_TOGRAVE-RESET_LEAVE+reset_flag,reset_count)
end
--"Breaker (This creature breaks N shields.)"
--"Each creature in the battle zone has "Breaker"."
--e.g. "Gigaberos" (DM-01 55/110), "Chaotic Skyterror" (DM-04 41/55)
function Auxiliary.EnableBreaker(c,code,con_func,s_range,o_range,targ_func)
	--code: DM_EFFECT_DOUBLE_BREAKER, DM_EFFECT_TRIPLE_BREAKER, DM_EFFECT_QUATTRO_BREAKER, etc.
	local con_func=con_func or aux.TRUE
	Auxiliary.EnableEffectCustom(c,DM_EFFECT_BREAKER,con_func,s_range,o_range,targ_func)
	Auxiliary.EnableEffectCustom(c,code,con_func,s_range,o_range,targ_func)
end
--function for a granted "Breaker" ability
--e.g. "Magma Gazer" (DM-01 81/110)
function Auxiliary.RegisterEffectBreaker(c,tc,desc_id,code,reset_flag,reset_count)
	local reset_flag=reset_flag or RESET_PHASE+PHASE_END
	local reset_count=reset_count or 1
	Auxiliary.RegisterEffectCustom(c,tc,desc_id,DM_EFFECT_BREAKER,reset_flag,reset_count)
	Auxiliary.RegisterEffectCustom(c,tc,desc_id,code,reset_flag,reset_count)
end
--"Instead of having this creature attack, you may tap it to use its Tap ability."
--e.g. "Tank Mutant" (DM-06 6/110)
function Auxiliary.EnableTapAbility(c,desc_id,targ_func,op_func,prop)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	if prop then e1:SetProperty(prop) end
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetHintTiming(DM_TIMING_BATTLE,0)
	e1:SetCondition(Auxiliary.TapAbilityCondition)
	e1:SetCost(Auxiliary.SelfTapCost)
	if targ_func then e1:SetTarget(targ_func) end
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
end
function Auxiliary.TapAbilityCondition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Auxiliary.BattlePhaseCondition() and Duel.IsPlayerCanUseTapAbility(tp) and Duel.GetCurrentChain()==0
		and Duel.GetAttacker()==nil and c:GetAttackAnnouncedCount()==0 and c:IsCanAttack()
end
--"Each of your creatures may tap instead of attacking to use this Tap ability."
--e.g. "Arc Bine, the Astounding" (DM-06 12/110)
function Auxiliary.AddStaticEffectTapAbility(c,desc_id,targ_func1,op_func,s_range,o_range,targ_func2,prop)
	--targ_func1: include dm.HintTarget
	local desc_id=desc_id or 0
	local s_range=s_range or LOCATION_ALL
	local o_range=o_range or 0
	local targ_func2=targ_func2 or aux.TRUE
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	if prop then e1:SetProperty(prop) end
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetHintTiming(DM_TIMING_BATTLE,0)
	e1:SetCondition(Auxiliary.TapAbilityCondition)
	e1:SetCost(Auxiliary.SelfTapCost)
	if targ_func1 then e1:SetTarget(targ_func1) end
	e1:SetOperation(op_func)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(DM_LOCATION_BATTLE)
	e2:SetTargetRange(s_range,o_range)
	e2:SetTarget(targ_func2)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
--"CIVILIZATION stealth (This creature can't be blocked while your opponent has any CIVILIZATION cards in his mana zone.)"
--e.g. "Kizar Basiku, the Outrageous" (DM-07 9/55)
function Auxiliary.EnableStealth(c,civ,con_func)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(DM_EFFECT_STEALTH)
	if con_func then e1:SetCondition(con_func) end
	e1:SetValue(civ)
	c:RegisterEffect(e1)
	Auxiliary.EnableCannotBeBlocked(c,nil,Auxiliary.StealthCondition(civ))
end
function Auxiliary.StealthCondition(civ)
	return	function(e)
				local tp=e:GetHandlerPlayer()
				return Duel.IsExistingMatchingCard(Auxiliary.ManaZoneFilter(Card.IsCivilization),tp,0,DM_LOCATION_MANA,1,nil,civ)
			end
end
--"Turbo rush (If any of your other creatures broke any shields this turn, this creature gets its Turborush ability until the end of the turn.)"
--e.g. "Magmadragon Jagalzor" (DM-08 4/55)
function Auxiliary.EnableTurboRush(c,op_func)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(DM_DESC_TURBO_RUSH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(DM_TIMING_BATTLE,0)
	e1:SetCondition(Auxiliary.TurboRushCondition)
	e1:SetTarget(Auxiliary.HintTarget)
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
end
function Auxiliary.TurboRushCondition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBrokenShieldCount()==0 and Duel.GetBrokenShieldCount(tp)>0
		and Duel.GetCurrentChain()==0 and Duel.GetAttacker()==nil
end
--"Silent skill (After your other creatures untap, if this creature is tapped, you may keep it tapped instead and use its Silentskill ability.)"
--e.g. "Kejila, the Hidden Horror" (DM-10 5/110)
function Auxiliary.EnableSilentSkill(c,desc_id,targ_func,op_func,prop)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(DM_EVENT_UNTAP_STEP)
	if prop then e1:SetProperty(prop) end
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetCondition(Auxiliary.SilentSkillCondition)
	e1:SetCost(Auxiliary.SilentSkillCost)
	if targ_func then e1:SetTarget(targ_func) end
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
	Auxiliary.EnableEffectCustom(c,DM_EFFECT_SILENT_SKILL)
end
function Auxiliary.SilentSkillCondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():IsTapped()
end
function Auxiliary.SilentSkillCost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(DM_EFFECT_SILENT_SKILL,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DRAW,0,1)
end
--"Wave striker (While 2 or more other creatures in the battle zone have "wave striker," this creature has its Wavestriker ability.)"
--e.g. "Asra, Vizier of Safety" (DM-11 6/55)
function Auxiliary.EnableWaveStriker(c)
	Auxiliary.EnableEffectCustom(c,DM_EFFECT_WAVE_STRIKER)
end
--condition function for "Wave Striker"
--Note: Always include this function for the specified "Wave Striker" ability
function Auxiliary.WaveStrikerCondition(e)
	local f=function(c)
		return c:IsFaceup() and c:IsHasEffect(DM_EFFECT_WAVE_STRIKER)
	end
	return Duel.IsExistingMatchingCard(f,e:GetHandlerPlayer(),DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,2,e:GetHandler())
end
Auxiliary.wscon=Auxiliary.WaveStrikerCondition
--"Sympathy: "RACE" (This creature/spell costs 1 less to summon/cast for each of your "RACE" creatures in the battle zone. It can't cost less than X.)"
--e.g. "Akashic First, Electro-Dragon" (DM-13 3/55)
--Not fully implemented: If a creature in the battle zone has both specified races listed, it can't count as both 
--https://duelmasters.fandom.com/wiki/Dolgeza,_Veteran_of_Hard_Battle/Rulings
function Auxiliary.EnableSympathy(c,race1,race2)
	Auxiliary.EnableUpdateManaCost(c,Auxiliary.SympathyValue(race1,race2))
	Auxiliary.EnableEffectCustom(c,DM_EFFECT_SYMPATHY)
end
function Auxiliary.SympathyValue(race1,race2)
	return	function(e,c)
				local f1=function(c,race1)
					return c:IsFaceup() and c:DMIsRace(race1)
				end
				local f2=function(c,race2)
					return c:IsFaceup() and c:DMIsRace(race2)
				end
				local ct1=Duel.GetMatchingGroupCount(f1,0,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,nil,race1)
				local ct2=Duel.GetMatchingGroupCount(f2,0,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,nil,race2)
				return (ct1+ct2)*-1
			end
end
--"RACE Hunter (This creature wins all battles against RACE.)"
--e.g. "Pearl Carras, Barrier Guardian" (Game Original)
function Auxiliary.EnableWinsAllBattles(c,desc_id,f)
	--f: include function for "RACE Hunter"
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetCondition(Auxiliary.WinsAllBattlesCondition(f))
	e1:SetOperation(Auxiliary.WinsAllBattlesOperation)
	c:RegisterEffect(e1)
	Auxiliary.EnableEffectCustom(c,DM_EFFECT_WINS_ALL_BATTLES)
end
function Auxiliary.WinsAllBattlesCondition(f)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local tc=e:GetHandler():GetBattleTarget()
				return tc and tc:IsFaceup() and tc:IsControler(1-tp) and (not f or f(tc))
			end
end
function Auxiliary.WinsAllBattlesOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,c:GetOriginalCode())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local tc=c:GetBattleTarget()
	if c:IsHasEffect(DM_EFFECT_WINS_ALL_BATTLES) and tc:IsHasEffect(DM_EFFECT_WINS_ALL_BATTLES) then
		--neither creature is destroyed
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTIBLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		tc:RegisterEffect(e2)
	else
		Duel.Destroy(tc,REASON_RULE)
		--raise event for "When this creature wins a battle"
		Duel.RaiseSingleEvent(c,EVENT_CUSTOM+DM_EVENT_WIN_BATTLE,e,0,0,0,0)
		--raise event for "Whenever one of your creatures wins a battle"
		Duel.RaiseEvent(c,EVENT_CUSTOM+DM_EVENT_WIN_BATTLE,e,0,0,0,0)
		--raise event for "When this creature loses a battle"
		Duel.RaiseSingleEvent(tc,EVENT_CUSTOM+DM_EVENT_LOSE_BATTLE,e,0,0,0,0)
		--raise event for "Whenever one of your creatures loses a battle"
		--Duel.RaiseEvent(tc,EVENT_CUSTOM+DM_EVENT_LOSE_BATTLE,e,0,0,0,0) --reserved
	end
end

--desc_id: the id of the effect's text (0~15)
--optional: true for optional ("you may") abilities
--forced: true for forced abilities
--prop: include EFFECT_FLAG_CARD_TARGET for a targeting ability

--"When this creature would be destroyed, ABILITY."
--e.g. "Chilias, the Oracle" (DM-01 1/110), "Coiling Vines" (DM-01 92/110), "Aless, the Oracle" (DM-03 2/55)
function Auxiliary.AddSingleDestroyReplaceEffect(c,desc_id,targ_func,op_func,con_func)
	--targ_func: targ_func or Auxiliary.SingleDestroyReplaceTarget
	--op_func: op_func or Auxiliary.SingleDestroyReplaceOperation
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(DM_LOCATION_BATTLE)
	if con_func then e1:SetCondition(con_func) end
	e1:SetTarget(targ_func)
	if op_func then e1:SetOperation(op_func) end
	c:RegisterEffect(e1)
end
function Auxiliary.SingleDestroyReplaceTarget(f,...)
	--f: Card.IsAbleToX
	local ext_params={...}
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				local c=e:GetHandler()
				if chk==0 then return not c:IsReason(REASON_REPLACE) and (not f or f(c,table.unpack(ext_params))) end
				return true
			end
end
function Auxiliary.SingleDestroyReplaceOperation(f,...)
	--f: Duel.SendtoX
	local ext_params={...}
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				Duel.Hint(HINT_CARD,0,c:GetOriginalCode())
				f(c,table.unpack(ext_params))
			end
end
--target function for "When this creature would be destroyed, you may ABILITY."
--e.g. "Aqua Agent" (DM-07 16/55)
function Auxiliary.SingleDestroyReplaceTarget2(desc_id,f,...)
	--f: Card.IsAbleToX
	local ext_params={...}
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				local c=e:GetHandler()
				if chk==0 then return not c:IsReason(REASON_REPLACE) and (not f or f(c,table.unpack(ext_params))) end
				if Duel.SelectYesNo(tp,aux.Stringid(c:GetOriginalCode(),desc_id)) then
					return true
				else return false end
			end
end
--"When one of your creatures would be destroyed, ABILITY."
--e.g. "King Ambergris" (Game Original)
function Auxiliary.AddDestroyReplaceEffect(c,desc_id,targ_func,op_func,val)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetTarget(targ_func)
	e1:SetValue(val)
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
end
--"At the end of the turn, ABILITY."
--e.g. "Frei, Vizier of Air" (DM-01 4/110)
function Auxiliary.AddTurnEndEffect(c,desc_id,p,optional,targ_func,op_func,con_func,prop)
	--p: PLAYER_SELF for your turn, PLAYER_OPPO for your opponent's, or nil for either player's
	local con_func=con_func or aux.TRUE
	local typ=(optional and EFFECT_TYPE_TRIGGER_O) or EFFECT_TYPE_TRIGGER_F
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	e1:SetType(EFFECT_TYPE_FIELD+typ)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	if prop then e1:SetProperty(prop) end
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetCountLimit(1)
	if p then
		e1:SetCondition(aux.AND(Auxiliary.TurnPlayerCondition(p),con_func))
	else
		e1:SetCondition(con_func)
	end
	if targ_func then e1:SetTarget(targ_func) end
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
end
--"When you put this creature into the battle zone, ABILITY."
--e.g. "Miele, Vizier of Lightning" (DM-01 13/110)
function Auxiliary.AddSingleComeIntoPlayEffect(c,desc_id,optional,targ_func,op_func,prop,con_func,cost_func,cate)
	local typ=(optional and EFFECT_TYPE_TRIGGER_O) or EFFECT_TYPE_TRIGGER_F
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	if cate then e1:SetCategory(cate) end
	e1:SetType(EFFECT_TYPE_SINGLE+typ)
	e1:SetCode(DM_EVENT_COME_INTO_PLAY_SUCCESS)
	if typ==EFFECT_TYPE_TRIGGER_O and prop then
		e1:SetProperty(EFFECT_FLAG_DELAY+prop)
	elseif typ==EFFECT_TYPE_TRIGGER_O then
		e1:SetProperty(EFFECT_FLAG_DELAY)
	elseif prop then
		e1:SetProperty(prop)
	end
	if con_func then e1:SetCondition(con_func) end
	if cost_func then e1:SetCost(cost_func) end
	if targ_func then e1:SetTarget(targ_func) end
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
end
--"Whenever another creature is put into the battle zone, ABILITY."
--e.g. "Mist Rias, Sonic Guardian" (DM-04 13/55)
function Auxiliary.AddComeIntoPlayEffect(c,desc_id,optional,targ_func,op_func,prop,con_func,cost_func,cate)
	local typ=(optional and EFFECT_TYPE_TRIGGER_O) or EFFECT_TYPE_TRIGGER_F
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	if cate then e1:SetCategory(cate) end
	e1:SetType(EFFECT_TYPE_FIELD+typ)
	e1:SetCode(DM_EVENT_COME_INTO_PLAY_SUCCESS)
	if typ==EFFECT_TYPE_TRIGGER_O and prop then
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY+prop)
	elseif typ==EFFECT_TYPE_TRIGGER_O then
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	elseif prop then
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+prop)
	end
	e1:SetRange(DM_LOCATION_BATTLE)
	if con_func then e1:SetCondition(con_func) end
	if cost_func then e1:SetCost(cost_func) end
	if targ_func then e1:SetTarget(targ_func) end
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
end
--"Each of your creatures has "When you put this creature into the battle zone, ABILITY"."
--e.g. "Forbos, Sanctum Guardian Q" (DM-06 19/110) 
function Auxiliary.AddStaticEffectSingleComeIntoPlay(c,desc_id,optional,targ_func1,op_func,s_range,o_range,targ_func2,prop)
	--targ_func1: include dm.HintTarget
	local desc_id=desc_id or 0
	local s_range=s_range or LOCATION_ALL
	local o_range=o_range or 0
	local targ_func2=targ_func2 or aux.TRUE
	local typ=(optional and EFFECT_TYPE_TRIGGER_O) or EFFECT_TYPE_TRIGGER_F
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	e1:SetType(EFFECT_TYPE_SINGLE+typ)
	e1:SetCode(DM_EVENT_COME_INTO_PLAY_SUCCESS)
	if prop then e1:SetProperty(prop) end
	if targ_func1 then e1:SetTarget(targ_func1) end
	e1:SetOperation(op_func)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(DM_LOCATION_BATTLE)
	e2:SetTargetRange(s_range,o_range)
	e2:SetTarget(targ_func2)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
--"Whenever this creature attacks, ABILITY."
--e.g. "Laguna, Lightning Enforcer" (DM-02 4/55)
function Auxiliary.AddSingleAttackTriggerEffect(c,desc_id,optional,targ_func,op_func,prop,con_func,cost_func,cate)
	local typ=(optional and EFFECT_TYPE_TRIGGER_O) or EFFECT_TYPE_TRIGGER_F
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	if cate then e1:SetCategory(cate) end
	e1:SetType(EFFECT_TYPE_SINGLE+typ)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	if prop then
		e1:SetProperty(DM_EFFECT_FLAG_CHAIN_LIMIT+prop)
	else
		e1:SetProperty(DM_EFFECT_FLAG_CHAIN_LIMIT)
	end
	if con_func then e1:SetCondition(con_func) end
	if cost_func then e1:SetCost(cost_func) end
	if targ_func then e1:SetTarget(targ_func) end
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
end
--"Each of your creatures has "Whenever this creature attacks, ABILITY"."
--e.g. "Split-Head Hydroturtle Q" (DM-05 24/55)
function Auxiliary.AddStaticEffectSingleAttackTrigger(c,desc_id,optional,targ_func1,op_func,s_range,o_range,targ_func2,prop)
	--targ_func1: include dm.HintTarget
	local desc_id=desc_id or 0
	local s_range=s_range or LOCATION_ALL
	local o_range=o_range or 0
	local targ_func2=targ_func2 or aux.TRUE
	local typ=(optional and EFFECT_TYPE_TRIGGER_O) or EFFECT_TYPE_TRIGGER_F
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	e1:SetType(EFFECT_TYPE_SINGLE+typ)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	if prop then
		e1:SetProperty(DM_EFFECT_FLAG_CHAIN_LIMIT+prop)
	else
		e1:SetProperty(DM_EFFECT_FLAG_CHAIN_LIMIT)
	end
	if targ_func1 then e1:SetTarget(targ_func1) end
	e1:SetOperation(op_func)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(DM_LOCATION_BATTLE)
	e2:SetTargetRange(s_range,o_range)
	e2:SetTarget(targ_func2)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
--"Whenever any of your creatures attacks, ABILITY."
--e.g. "Thrumiss, Zephyr Guardian" (DM-08 15/55)
function Auxiliary.AddAttackTriggerEffect(c,desc_id,optional,targ_func,op_func,prop,con_func,cost_func,cate)
	local typ=(optional and EFFECT_TYPE_TRIGGER_O) or EFFECT_TYPE_TRIGGER_F
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	if cate then e1:SetCategory(cate) end
	e1:SetType(EFFECT_TYPE_FIELD+typ)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	if prop then
		e1:SetProperty(DM_EFFECT_FLAG_CHAIN_LIMIT+prop)
	else
		e1:SetProperty(DM_EFFECT_FLAG_CHAIN_LIMIT)
	end
	e1:SetRange(DM_LOCATION_BATTLE)
	if con_func then e1:SetCondition(con_func) end
	if cost_func then e1:SetCost(cost_func) end
	if targ_func then e1:SetTarget(targ_func) end
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
end
--"Whenever this creature is attacked, ABILITY."
--e.g. "Scalpel Spider" (DM-07 32/55)
function Auxiliary.AddSingleBeAttackedEffect(c,desc_id,optional,targ_func,op_func,prop,con_func,cost_func,cate)
	local typ=(optional and EFFECT_TYPE_TRIGGER_O) or EFFECT_TYPE_TRIGGER_F
	local con_func=con_func or aux.TRUE
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	if cate then e1:SetCategory(cate) end
	e1:SetType(EFFECT_TYPE_SINGLE+typ)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	if typ==EFFECT_TYPE_TRIGGER_O and prop then
		e1:SetProperty(EFFECT_FLAG_DELAY+prop)
	elseif typ==EFFECT_TYPE_TRIGGER_O then
		e1:SetProperty(EFFECT_FLAG_DELAY)
	elseif prop then
		e1:SetProperty(prop)
	end
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetCondition(aux.AND(Auxiliary.SelfAttackTargetCondition,con_func))
	if cost_func then e1:SetCost(cost_func) end
	if targ_func then e1:SetTarget(targ_func) end
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
end
--"Whenever your creatures are attacked, ABILITY."
--e.g. "Polaris, the Oracle" (DM-13 21/55)
function Auxiliary.AddBeAttackedEffect(c,desc_id,optional,targ_func,op_func,prop,con_func,cost_func,cate)
	local typ=(optional and EFFECT_TYPE_TRIGGER_O) or EFFECT_TYPE_TRIGGER_F
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	if cate then e1:SetCategory(cate) end
	e1:SetType(EFFECT_TYPE_FIELD+typ)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	if typ==EFFECT_TYPE_TRIGGER_O and prop then
		e1:SetProperty(EFFECT_FLAG_DELAY+prop)
	elseif typ==EFFECT_TYPE_TRIGGER_O then
		e1:SetProperty(EFFECT_FLAG_DELAY)
	elseif prop then
		e1:SetProperty(prop)
	end
	e1:SetRange(DM_LOCATION_BATTLE)
	if con_func then e1:SetCondition(con_func) end
	if cost_func then e1:SetCost(cost_func) end
	if targ_func then e1:SetTarget(targ_func) end
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
end
--"Whenever this creature battles, ABILITY."
--e.g. "Akashic Third, the Electro-Bandit" (DM-13 19/55)
function Auxiliary.AddSingleBattleEffect(c,desc_id,optional,targ_func,op_func,prop,con_func,cost_func,cate)
	local con_func=con_func or aux.TRUE
	Auxiliary.AddSingleAttackTriggerEffect(c,desc_id,optional,targ_func,op_func,prop,aux.AND(Auxiliary.AttackTargetCondition(),con_func),cost_func,cate)
	Auxiliary.AddSingleBeAttackedEffect(c,desc_id,optional,targ_func,op_func,prop,con_func,cost_func,cate)
end
--"Whenever this creature blocks, ABILITY."
--e.g. "Spiral Grass" (DM-02 10/55)
function Auxiliary.AddSingleBlockEffect(c,desc_id,optional,targ_func,op_func,prop,con_func,cost_func,cate)
	local typ=(optional and EFFECT_TYPE_TRIGGER_O) or EFFECT_TYPE_TRIGGER_F
	local con_func=con_func or aux.TRUE
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	if cate then e1:SetCategory(cate) end
	e1:SetType(EFFECT_TYPE_SINGLE+typ)
	e1:SetCode(DM_EVENT_BATTLE_END)
	if typ==EFFECT_TYPE_TRIGGER_O and prop then
		e1:SetProperty(EFFECT_FLAG_DELAY+prop)
	elseif typ==EFFECT_TYPE_TRIGGER_O then
		e1:SetProperty(EFFECT_FLAG_DELAY)
	elseif prop then
		e1:SetProperty(prop)
	end
	e1:SetCondition(aux.AND(Auxiliary.SelfBlockCondition,con_func))
	if cost_func then e1:SetCost(cost_func) end
	if targ_func then e1:SetTarget(targ_func) end
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
end
--"Whenever one of your creatures blocks, ABILITY."
--e.g. "Agira, the Warlord Crawler" (DM-12 16/55)
function Auxiliary.AddBlockEffect(c,desc_id,optional,targ_func,op_func,prop,con_func,cost_func,cate)
	local typ=(optional and EFFECT_TYPE_TRIGGER_O) or EFFECT_TYPE_TRIGGER_F
	local con_func=con_func or aux.TRUE
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	if cate then e1:SetCategory(cate) end
	e1:SetType(EFFECT_TYPE_FIELD+typ)
	e1:SetCode(DM_EVENT_BATTLE_END)
	if typ==EFFECT_TYPE_TRIGGER_O and prop then
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY+prop)
	elseif typ==EFFECT_TYPE_TRIGGER_O then
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	elseif prop then
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+prop)
	end
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetCondition(aux.AND(Auxiliary.BlockCondition,con_func))
	if cost_func then e1:SetCost(cost_func) end
	if targ_func then e1:SetTarget(targ_func) end
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
end
--"When this creature is destroyed, ABILITY."
--e.g. "Bombersaur" (DM-02 36/55)
function Auxiliary.AddSingleDestroyedEffect(c,desc_id,optional,targ_func,op_func,prop,con_func,cost_func,cate)
	local typ=(optional and EFFECT_TYPE_TRIGGER_O) or EFFECT_TYPE_TRIGGER_F
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	if cate then e1:SetCategory(cate) end
	e1:SetType(EFFECT_TYPE_SINGLE+typ)
	e1:SetCode(EVENT_DESTROYED)
	if typ==EFFECT_TYPE_TRIGGER_O and prop then
		e1:SetProperty(EFFECT_FLAG_DELAY+prop)
	elseif typ==EFFECT_TYPE_TRIGGER_O then
		e1:SetProperty(EFFECT_FLAG_DELAY)
	elseif prop then
		e1:SetProperty(prop)
	end
	if con_func then e1:SetCondition(con_func) end
	if cost_func then e1:SetCost(cost_func) end
	if targ_func then e1:SetTarget(targ_func) end
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
end
--"Whenever another creature is destroyed, ABILITY."
--e.g. "Mongrel Man" (DM-04 33/55)
function Auxiliary.AddDestroyedEffect(c,desc_id,optional,targ_func,op_func,prop,con_func,cost_func,cate)
	local typ=(optional and EFFECT_TYPE_TRIGGER_O) or EFFECT_TYPE_TRIGGER_F
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	if cate then e1:SetCategory(cate) end
	e1:SetType(EFFECT_TYPE_FIELD+typ)
	e1:SetCode(EVENT_DESTROYED)
	if typ==EFFECT_TYPE_TRIGGER_O and prop then
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY+prop)
	elseif typ==EFFECT_TYPE_TRIGGER_O then
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	elseif prop then
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+prop)
	end
	e1:SetRange(DM_LOCATION_BATTLE)
	if con_func then e1:SetCondition(con_func) end
	if cost_func then e1:SetCost(cost_func) end
	if targ_func then e1:SetTarget(targ_func) end
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
end
--"Whenever a card is put into your graveyard, ABILITY."
--e.g. "Snork La, Shrine Guardian" (DM-05 13/55)
function Auxiliary.AddEnterGraveEffect(c,desc_id,p,optional,targ_func,op_func,prop,con_func,cost_func,cate)
	--p: PLAYER_SELF for your graveyard, PLAYER_OPPO for your opponent's, or nil for either player's
	local con_func=con_func or aux.TRUE
	local typ=(optional and EFFECT_TYPE_TRIGGER_O) or EFFECT_TYPE_TRIGGER_F
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	if cate then e1:SetCategory(cate) end
	e1:SetType(EFFECT_TYPE_FIELD+typ)
	e1:SetCode(DM_EVENT_TO_GRAVE)
	if typ==EFFECT_TYPE_TRIGGER_O and prop then
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY+prop)
	elseif typ==EFFECT_TYPE_TRIGGER_O then
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	elseif prop then
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+prop)
	end
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetCondition(aux.AND(Auxiliary.EnterGraveCondition(p),con_func))
	if cost_func then e1:SetCost(cost_func) end
	if targ_func then e1:SetTarget(targ_func) end
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
end
--"Whenever this creature becomes blocked, ABILITY."
--e.g. "Avalanche Giant" (DM-05 S5/S5)
function Auxiliary.AddSingleBecomeBlockedEffect(c,desc_id,optional,targ_func,op_func,prop,con_func,cost_func,cate)
	local typ=(optional and EFFECT_TYPE_TRIGGER_O) or EFFECT_TYPE_TRIGGER_F
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	if cate then e1:SetCategory(cate) end
	e1:SetType(EFFECT_TYPE_SINGLE+typ)
	e1:SetCode(EVENT_CUSTOM+DM_EVENT_BECOME_BLOCKED)
	if typ==EFFECT_TYPE_TRIGGER_O and prop then
		e1:SetProperty(EFFECT_FLAG_DELAY+prop)
	elseif typ==EFFECT_TYPE_TRIGGER_O then
		e1:SetProperty(EFFECT_FLAG_DELAY)
	elseif prop then
		e1:SetProperty(prop)
	end
	if con_func then e1:SetCondition(con_func) end
	if cost_func then e1:SetCost(cost_func) end
	if targ_func then e1:SetTarget(targ_func) end
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
end
--"Whenever a player summons a creature, ABILITY."
--e.g. "Aqua Rider" (DM-06 31/110)
function Auxiliary.AddPlayerSummonCreatureEffect(c,desc_id,p,optional,targ_func,op_func,prop)
	--p: PLAYER_SELF if you summon, PLAYER_OPPO if your opponent does, or nil if either player does
	local typ=(optional and EFFECT_TYPE_TRIGGER_O) or EFFECT_TYPE_TRIGGER_F
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	e1:SetType(EFFECT_TYPE_FIELD+typ)
	e1:SetCode(DM_EVENT_SUMMON_SUCCESS)
	if typ==EFFECT_TYPE_TRIGGER_O and prop then
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+prop)
	elseif typ==EFFECT_TYPE_TRIGGER_O then
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	elseif prop then
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+prop)
	end
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetCondition(Auxiliary.PlayerSummonCreatureCondition(p))
	if targ_func then e1:SetTarget(targ_func) end
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
end
function Auxiliary.PlayerSummonCreatureCondition(p)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local sumplayer=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp)
				local f=function(c,sp)
					if not c:IsSummonType(DM_SUMMON_TYPE_NORMAL) then return false end
					return sp and c:GetSummonPlayer()==sp
				end
				return eg:IsExists(f,1,nil,sumplayer)
			end
end
--"Whenever a player uses the "shield trigger" ability of one of their shields, ABILITY."
--e.g. "Emperor Quazla" (DM-08 S2/S5), "Glena Vuele, the Hypnotic" (DM-09 1/55)
function Auxiliary.AddPlayerUseShieldTriggerEffect(c,desc_id,p,optional,targ_func,op_func)
	--p: PLAYER_SELF if you use "shield trigger", PLAYER_OPPO if your opponent does, or nil if either player does
	local typ=(optional and EFFECT_TYPE_TRIGGER_O) or EFFECT_TYPE_TRIGGER_F
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		e:GetLabelObject():SetLabel(0)
	end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(DM_LOCATION_BATTLE)
	e2:SetOperation(Auxiliary.STChainSolvedOperation(p))
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	e3:SetType(EFFECT_TYPE_FIELD+typ)
	e3:SetCode(EVENT_CHAIN_END)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(DM_LOCATION_BATTLE)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetLabel()==1
	end)
	if targ_func then e3:SetTarget(targ_func) end
	e3:SetOperation(op_func)
	c:RegisterEffect(e3)
	e1:SetLabelObject(e3)
	e2:SetLabelObject(e3)
end
function Auxiliary.STChainSolvedOperation(p)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local reason_player=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp)
				if reason_player and rp==reason_player
					and re:IsHasCategory(DM_CATEGORY_SHIELD_TRIGGER) and re:GetHandler():IsBrokenShield() then
					e:GetLabelObject():SetLabel(1)
				end
			end
end
--"Whenever a player casts a spell, ABILITY."
--e.g. "Natalia, Channeler of Suns" (Game Original)
function Auxiliary.AddPlayerCastSpellEffect(c,desc_id,p,f,optional,targ_func,op_func,prop)
	--p: PLAYER_SELF if you cast a spell, PLAYER_OPPO if your opponent does, or nil if either player does
	local typ=(optional and EFFECT_TYPE_TRIGGER_O) or EFFECT_TYPE_TRIGGER_F
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		e:GetLabelObject():SetLabel(0)
	end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(DM_LOCATION_BATTLE)
	e2:SetOperation(Auxiliary.SpellChainSolvedOperation(p,f))
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	e3:SetType(EFFECT_TYPE_FIELD+typ)
	e3:SetCode(EVENT_CHAIN_END)
	if prop then
		e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+prop)
	else
		e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	end
	e3:SetRange(DM_LOCATION_BATTLE)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetLabel()==1
	end)
	if targ_func then e3:SetTarget(targ_func) end
	e3:SetOperation(op_func)
	c:RegisterEffect(e3)
	e1:SetLabelObject(e3)
	e2:SetLabelObject(e3)
end
function Auxiliary.SpellChainSolvedOperation(p,f)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local reason_player=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp)
				local rc=re:GetHandler()
				if reason_player and rp==reason_player and rc:IsSpell() and (not f or f(rc)) then
					e:GetLabelObject():SetLabel(1)
				end
			end
end
--"When this creature leaves the battle zone, ABILITY."
--e.g. "Wise Starnoid, Avatar of Hope" (DM-12 S2/S5)
function Auxiliary.AddSingleLeaveBattleEffect(c,desc_id,optional,targ_func,op_func,prop,con_func,cost_func,cate)
	local con_func=con_func or aux.TRUE
	local typ=(optional and EFFECT_TYPE_TRIGGER_O) or EFFECT_TYPE_TRIGGER_F
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	if cate then e1:SetCategory(cate) end
	e1:SetType(EFFECT_TYPE_SINGLE+typ)
	e1:SetCode(EVENT_LEAVE_FIELD)
	if typ==EFFECT_TYPE_TRIGGER_O and prop then
		e1:SetProperty(EFFECT_FLAG_DELAY+prop)
	elseif typ==EFFECT_TYPE_TRIGGER_O then
		e1:SetProperty(EFFECT_FLAG_DELAY)
	elseif prop then
		e1:SetProperty(prop)
	end
	e1:SetCondition(Auxiliary.PreviousLocationCondition(DM_LOCATION_BATTLE),con_func)
	if cost_func then e1:SetCost(cost_func) end
	if targ_func then e1:SetTarget(targ_func) end
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
end
--"Whenever this creature breaks a shield, ABILITY."
--e.g. "Bolblaze Dragon" (Game Original)
function Auxiliary.AddBreakShieldEffect(c,desc_id,optional,targ_func,op_func,prop,con_func,cost_func,cate)
	local typ=(optional and EFFECT_TYPE_TRIGGER_O) or EFFECT_TYPE_TRIGGER_F
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	if cate then e1:SetCategory(cate) end
	e1:SetType(EFFECT_TYPE_FIELD+typ)
	e1:SetCode(EVENT_CUSTOM+DM_EVENT_BREAK_SHIELD)
	if typ==EFFECT_TYPE_TRIGGER_O and prop then
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY+prop)
	elseif typ==EFFECT_TYPE_TRIGGER_O then
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	elseif prop then
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+prop)
	end
	e1:SetRange(DM_LOCATION_BATTLE)
	if con_func then e1:SetCondition(con_func) end
	if cost_func then e1:SetCost(cost_func) end
	if targ_func then e1:SetTarget(targ_func) end
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
end
--"At the start of the turn, ABILITY."
--e.g. "Altimeth, Holy Divine Dragon" (Game Original)
function Auxiliary.AddTurnStartEffect(c,desc_id,p,optional,targ_func,op_func,con_func,prop)
	--p: PLAYER_SELF for your turn, PLAYER_OPPO for your opponent's, or nil for either player's
	local con_func=con_func or aux.TRUE
	local typ=(optional and EFFECT_TYPE_TRIGGER_O) or EFFECT_TYPE_TRIGGER_F
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	e1:SetType(EFFECT_TYPE_FIELD+typ)
	e1:SetCode(DM_EVENT_UNTAP_STEP)
	if prop then e1:SetProperty(prop) end
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetCountLimit(1)
	if p then
		e1:SetCondition(aux.AND(Auxiliary.TurnPlayerCondition(p),con_func))
	else
		e1:SetCondition(con_func)
	end
	if targ_func then e1:SetTarget(targ_func) end
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
end

--"This creature can't attack players."
--e.g. "Dia Nork, Moonlight Guardian" (DM-01 2/110)
function Auxiliary.EnableCannotAttackPlayer(c)
	Auxiliary.EnableEffectCustom(c,DM_EFFECT_CANNOT_ATTACK_PLAYER,Auxiliary.CannotAttackPlayerCondition)
end
function Auxiliary.CannotAttackPlayerCondition(e)
	return not e:GetHandler():IsHasEffect(DM_EFFECT_IGNORE_CANNOT_ATTACK_PLAYER)
end
--"This creature gets +/-N000 power."
--"Each of your/your opponent's creatures gets +/-N000 power."
--e.g. "Iocant, the Oracle" (DM-01 8/110), "Barkwhip, the Smasher" (DM-02 45/55)
function Auxiliary.EnableUpdatePower(c,val,con_func,s_range,o_range,targ_func)
	--con_func: include dm.SelfAttackerCondition for "while this creature is attacking"
	local e1=Effect.CreateEffect(c)
	if s_range or o_range then
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetTargetRange(s_range,o_range)
		if targ_func then e1:SetTarget(targ_func) end
	else
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	end
	e1:SetCode(DM_EFFECT_UPDATE_POWER)
	e1:SetRange(DM_LOCATION_BATTLE)
	if con_func then e1:SetCondition(con_func) end
	e1:SetValue(val)
	c:RegisterEffect(e1)
end
--"Each of your creatures has "This creature gets +/-N000 power"." 
--e.g. "Smash Horn Q" (DM-05 55/55)
function Auxiliary.AddStaticEffectUpdatePower(c,val,s_range,o_range,targ_func)
	local s_range=s_range or LOCATION_ALL
	local o_range=o_range or 0
	local targ_func=targ_func or aux.TRUE
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(DM_EFFECT_UPDATE_POWER)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetValue(val)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(DM_LOCATION_BATTLE)
	e2:SetTargetRange(s_range,o_range)
	e2:SetTarget(targ_func)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
--function for a granted "+/-N000 power" ability
--e.g. "Rumble Gate" (DM-02 44/55)
function Auxiliary.RegisterEffectUpdatePower(c,tc,desc_id,val,reset_flag,reset_count,con_func)
	local reset_flag=reset_flag or RESET_PHASE+PHASE_END
	local reset_count=reset_count or 1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(DM_EFFECT_UPDATE_POWER)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	if con_func then e1:SetCondition(con_func) end
	e1:SetValue(val)
	if tc==c then
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+reset_flag,reset_count)
	else
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+reset_flag,reset_count)
	end
	tc:RegisterEffect(e1)
end
--"At the end of each of your turns, you may untap this creature."
--e.g. "Ruby Grass" (DM-01 17/110)
function Auxiliary.EnableTurnEndSelfUntap(c,desc_id,con_func,forced)
	local desc_id=desc_id or 0
	local typ=(forced and EFFECT_TYPE_TRIGGER_F) or EFFECT_TYPE_TRIGGER_O
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	e1:SetType(EFFECT_TYPE_FIELD+typ)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(DM_LOCATION_BATTLE)
	if con_func then
		e1:SetCondition(aux.AND(Auxiliary.TurnPlayerCondition(PLAYER_SELF),con_func))
	else
		e1:SetCondition(Auxiliary.TurnPlayerCondition(PLAYER_SELF))
	end
	if typ==EFFECT_TYPE_TRIGGER_O then
		e1:SetTarget(Auxiliary.SelfUntapTarget)
	end
	e1:SetOperation(Auxiliary.SelfUntapOperation())
	c:RegisterEffect(e1)
end
function Auxiliary.SelfUntapTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsFaceup() and e:GetHandler():IsTapped() end
end
function Auxiliary.SelfUntapOperation(ram)
	--ram: true for "untap this creature at random"
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
				local ct=math.random(4) --generate either 2 or 3 for 50% chance
				if ram and ct~=2 then return end
				Duel.Untap(c,REASON_EFFECT)
			end
end
--"This creature can't be blocked."
--e.g. "Candy Drop" (DM-01 28/110)
function Auxiliary.EnableCannotBeBlocked(c,f,con_func)
	local con_func=con_func or aux.TRUE
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetTargetRange(1,1)
	e1:SetCondition(aux.AND(Auxiliary.SelfAttackerCondition,con_func))
	e1:SetValue(Auxiliary.CannotBeBlockedValue(f))
	c:RegisterEffect(e1)
	Auxiliary.EnableEffectCustom(c,DM_EFFECT_UNBLOCKABLE,con_func)
end
--f: include function for "This creature can't be blocked by X creatures."
--e.g. "Stampeding Longhorn" (DM-01 104/110), "Calgo, Vizier of Rainclouds" (DM-05 7/55)
function Auxiliary.CannotBeBlockedValue(f)
	return	function(e,re,tp)
				return re:IsHasCategory(DM_CATEGORY_BLOCKER) and not re:GetHandler():IsImmuneToEffect(e)
					and (not f or f(e,re,tp))
			end
end
function Auxiliary.CannotBeBlockedBoolFunction(f,...)
	local ext_params={...}
	return	function(e,re,tp)
				return f(re:GetHandler(),table.unpack(ext_params))
			end
end
--"Each of your creatures has "This creature can't be blocked"."
--e.g. "King Nautilus" (DM-02 17/55)
function Auxiliary.AddStaticEffectCannotBeBlocked(c,s_range,o_range,targ_func)
	local s_range=s_range or LOCATION_ALL
	local o_range=o_range or 0
	local targ_func=targ_func or aux.TRUE
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetTargetRange(1,1)
	e1:SetCondition(Auxiliary.SelfAttackerCondition)
	e1:SetValue(Auxiliary.CannotBeBlockedValue())
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(DM_LOCATION_BATTLE)
	e2:SetTargetRange(s_range,o_range)
	e2:SetTarget(targ_func)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	Auxiliary.EnableEffectCustom(c,DM_EFFECT_UNBLOCKABLE,nil,s_range,o_range,targ_func)
end
--function for a granted "This creature can't be blocked" ability
--e.g. "Laser Wing" (DM-01 11/110)
function Auxiliary.RegisterEffectCannotBeBlocked(c,tc,desc_id,val,con_func,reset_flag,reset_count)
	local con_func=con_func or aux.TRUE
	local reset_flag=reset_flag or RESET_PHASE+PHASE_END
	local reset_count=reset_count or 1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetTargetRange(1,1)
	e1:SetCondition(aux.AND(Auxiliary.SelfAttackerCondition,con_func))
	e1:SetValue(Auxiliary.CannotBeBlockedValue(val))
	if tc==c then
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+reset_flag,reset_count)
	else
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+reset_flag,reset_count)
	end
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(DM_EFFECT_UNBLOCKABLE)
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetCondition(con_func)
	if tc==c then
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+reset_flag,reset_count)
	else
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+reset_flag,reset_count)
	end
	tc:RegisterEffect(e2)
end
--"This creature can't attack."
--"Creatures can't attack."
--e.g. "Hunter Fish" (DM-01 31/110), "Nariel, the Oracle" (DM-08 11/55)
function Auxiliary.EnableCannotAttack(c,con_func,s_range,o_range,tg)
	local con_func=con_func or aux.TRUE
	local targ_func=aux.AND(Auxiliary.CannotAttackTarget,tg)
	if s_range or o_range then
		Auxiliary.EnableEffectCustom(c,EFFECT_CANNOT_ATTACK,con_func,s_range,o_range,targ_func)
	else
		Auxiliary.EnableEffectCustom(c,EFFECT_CANNOT_ATTACK,aux.AND(Auxiliary.SelfCannotAttackCondition,con_func))
	end
end
function Auxiliary.SelfCannotAttackCondition(e)
	return not e:GetHandler():IsHasEffect(DM_EFFECT_IGNORE_CANNOT_ATTACK)
end
function Auxiliary.CannotAttackTarget(e,c)
	return not c:IsHasEffect(DM_EFFECT_IGNORE_CANNOT_ATTACK)
end
--"When this creature wins a battle, destroy it."
--"When this creature wins a battle, it is destroyed at random."
--e.g. "Bloody Squito" (DM-01 46/110), "Hanakage, Shadow of Transience" (Game Original)
function Auxiliary.EnableBattleWinSelfDestroy(c,desc_id,ram)
	--ram: true for "This creature is destroyed at random"
	local desc_id=desc_id or 0
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(Auxiliary.SelfBattleWinCondition)
	e1:SetOperation(Auxiliary.SelfDestroyOperation(ram))
	c:RegisterEffect(e1)
	--fix for "When this creature wins a battle" abilities not triggering
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_CUSTOM+DM_EVENT_WIN_BATTLE)
	e2:SetOperation(Auxiliary.SelfDestroyOperation(ram))
	c:RegisterEffect(e2)
end
function Auxiliary.SelfDestroyOperation(ram)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				if Duel.GetAttacker()==c then Duel.Tap(c,REASON_RULE) end --fix creature not being tapped when attacking
				if not c:IsRelateToEffect(e) then return end
				local ct=math.random(4) --generate either 2 or 3 for 50% chance
				if ram and ct~=2 then return end
				Duel.Destroy(c,REASON_EFFECT)
			end
end
--"Whenever this creature wins a battle, [you may] untap this creature."
--e.g. "Mobile Saint Meermax" (DM-13 17/55)
function Auxiliary.EnableBattleWinSelfUntap(c,desc_id,forced)
	local desc_id=desc_id or 0
	local typ=(forced and EFFECT_TYPE_TRIGGER_F) or EFFECT_TYPE_TRIGGER_O
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	e1:SetType(EFFECT_TYPE_SINGLE+typ)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(Auxiliary.SelfBattleWinCondition)
	if typ==EFFECT_TYPE_TRIGGER_O then
		e1:SetTarget(Auxiliary.SelfUntapTarget)
	end
	e1:SetOperation(Auxiliary.SelfUntapOperation())
	c:RegisterEffect(e1)
	--fix for "When this creature wins a battle" abilities not triggering
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	e2:SetType(EFFECT_TYPE_SINGLE+typ)
	e2:SetCode(EVENT_CUSTOM+DM_EVENT_WIN_BATTLE)
	if typ==EFFECT_TYPE_TRIGGER_O then
		e2:SetTarget(Auxiliary.SelfUntapTarget)
	end
	e2:SetOperation(Auxiliary.SelfUntapOperation())
	c:RegisterEffect(e2)
end
--"This creature can attack untapped creatures."
--"This creature can attack untapped CIVILIZATION creatures."
--"Each of your creatures in the battle zone can attack untapped creatures."
--e.g. "Gatling Skyterror" (DM-01 79/110), "Aeris, Flight Elemental" (DM-04 6/55), "Storm Javelin Wyvern" (Game Original)
function Auxiliary.EnableAttackUntapped(c,val,con_func,s_range,o_range,targ_func)
	local e1=Effect.CreateEffect(c)
	if s_range or o_range then
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(DM_LOCATION_BATTLE)
		e1:SetTargetRange(s_range,o_range)
		if targ_func then e1:SetTarget(targ_func) end
	else
		e1:SetType(EFFECT_TYPE_SINGLE)
	end
	e1:SetCode(DM_EFFECT_ATTACK_UNTAPPED)
	if con_func then e1:SetCondition(con_func) end
	if val then e1:SetValue(val) end
	c:RegisterEffect(e1)
end
--"A player's creatures/spells each cost N more/less to summon/cast."
--"Each creature costs N more/less to summon and each spell costs N more/less to cast."
--e.g. "Elf-X" (DM-02 46/55), "Milieus, the Daystretcher" (DM-04 12/55)
function Auxiliary.EnableUpdateManaCost(c,val,s_range,o_range,targ_func)
	local e1=Effect.CreateEffect(c)
	if s_range or o_range then
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(DM_LOCATION_BATTLE)
		e1:SetTargetRange(s_range,o_range)
		if targ_func then e1:SetTarget(targ_func) end
	else
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_HAND+DM_LOCATION_BATTLE)
	end
	e1:SetCode(DM_EFFECT_UPDATE_MANA_COST)
	e1:SetValue(val)
	c:RegisterEffect(e1)
end
--"This creature can't attack creatures."
--e.g. "Dawn Giant" (DM-03 46/55)
function Auxiliary.EnableCannotAttackCreature(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetValue(aux.TargetBoolFunction(Card.IsCreature))
	c:RegisterEffect(e1)
	Auxiliary.EnableEffectCustom(c,DM_EFFECT_CANNOT_ATTACK_CREATURE)
end
--"This creature can't be attacked"
--e.g. "Gulan Rias, Speed Guardian" (DM-04 10/55), "Misha, Channeler of Suns" (DM-08 10/55)
function Auxiliary.EnableCannotBeAttacked(c,f)
	--f: include function for "This creature can't be attacked by X creatures."
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetValue(Auxiliary.CannotBeAttackedValue(f))
	c:RegisterEffect(e1)
end
function Auxiliary.CannotBeAttackedValue(f)
	return	function(e,c)
				return not c:IsImmuneToEffect(e) and (not f or f(e,c))
			end
end
--"At the end of each of your turns, destroy this creature."
--e.g. "Gnarvash, Merchant of Blood" (DM-06 57/110)
function Auxiliary.EnableTurnEndSelfDestroy(c,desc_id,con_func)
	local desc_id=desc_id or 0
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(DM_LOCATION_BATTLE)
	if con_func then
		e1:SetCondition(aux.AND(Auxiliary.TurnPlayerCondition(PLAYER_SELF),con_func))
	else
		e1:SetCondition(Auxiliary.TurnPlayerCondition(PLAYER_SELF))
	end
	e1:SetOperation(Auxiliary.SelfDestroyOperation())
	c:RegisterEffect(e1)
end
--"When this creature battles, destroy it after the battle."
--e.g. "Vile Mulder, Wing of the Void" (DM-06 69/110)
function Auxiliary.EnableBattleEndSelfDestroy(c,desc_id)
	local desc_id=desc_id or 0
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(DM_EVENT_BATTLE_END)
	e1:SetCondition(Auxiliary.SelfBattleEndCondition)
	e1:SetOperation(Auxiliary.SelfBattleEndOperation)
	c:RegisterEffect(e1)
end
function Auxiliary.SelfBattleEndCondition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget()
end
function Auxiliary.SelfBattleEndOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToBattle() then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
--"Whenever another creature would be destroyed, it stays in the battle zone instead."
--e.g. "Mihail, Celestial Elemental" (DM-09 12/55)
function Auxiliary.EnableCannotBeDestroyed(c,s_range,o_range,targ_func)
	local e1=Effect.CreateEffect(c)
	if s_range or o_range then
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(DM_LOCATION_BATTLE)
		e1:SetTargetRange(s_range,o_range)
		if targ_func then e1:SetTarget(targ_func) end
	else
		e1:SetType(EFFECT_TYPE_SINGLE)
	end
	e1:SetCode(EFFECT_INDESTRUCTIBLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTIBLE_BATTLE)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_INDESTRUCTIBLE_ABILITY)
	c:RegisterEffect(e3)
end
--"Whenever your opponent would choose a creature in the battle zone, he can't choose this one."
--e.g. "Petrova, Channeler of Suns" (DM-09 S1/S5)
function Auxiliary.EnableCannotBeTargeted(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
end
--"At the end of your turn, [you may] return this creature to your hand."
--e.g. "Ganzo, Flame Fisherman" (Game Original)
function Auxiliary.EnableTurnEndSelfReturn(c,desc_id,con_func,optional)
	local desc_id=desc_id or 0
	local typ=(optional and EFFECT_TYPE_TRIGGER_O) or EFFECT_TYPE_TRIGGER_F
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	e1:SetType(EFFECT_TYPE_FIELD+typ)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(DM_LOCATION_BATTLE)
	if con_func then
		e1:SetCondition(aux.AND(Auxiliary.TurnPlayerCondition(PLAYER_SELF),con_func))
	else
		e1:SetCondition(Auxiliary.TurnPlayerCondition(PLAYER_SELF))
	end
	if typ==EFFECT_TYPE_TRIGGER_O then e1:SetTarget(Auxiliary.SelfReturnTarget) end
	e1:SetOperation(Auxiliary.SelfReturnOperation)
	c:RegisterEffect(e1)
end
function Auxiliary.SelfReturnTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
end
function Auxiliary.SelfReturnOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.SendtoHand(c,PLAYER_OWNER,REASON_EFFECT)
	end
end
--========== Break ==========
--operation function for abilities that break shields
function Auxiliary.BreakOperation(sp,tgp,min,max,rc,ignore_breaker)
	--sp,min,max: nil to break all shields
	--ignore_breaker: true to not break a number of shields according to the breaker abilities a creature may have
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local sel_player=(sp==PLAYER_SELF and tp) or (sp==PLAYER_OPPO and 1-tp)
				local target_player=(tgp==PLAYER_SELF and tp) or (tgp==PLAYER_OPPO and 1-tp)
				if e:IsHasType(EFFECT_TYPE_CONTINUOUS) then Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode()) end
				Duel.BreakShield(e,sel_player,target_player,min,max,rc,REASON_EFFECT,ignore_breaker)
			end
end
--========== Confirm ==========
--operation function for abilities that let a player look at cards that are not public knowledge
function Auxiliary.ConfirmOperation(p,f,s,o,min,max,ex,...)
	--f: include Card.IsFacedown for DM_LOCATION_SHIELD, not Card.IsPublic for LOCATION_HAND
	--p,min,max: nil to look at all cards
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local player=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp)
				local max=max or min
				local c=e:GetHandler()
				if c:IsSpell() and c:IsLocation(LOCATION_HAND) and (s==LOCATION_HAND or o==LOCATION_HAND) then ex=c end
				if e:IsHasType(EFFECT_TYPE_CONTINUOUS) then Duel.Hint(HINT_CARD,0,c:GetOriginalCode()) end
				local g=Duel.GetMatchingGroup(f,tp,s,o,ex,table.unpack(funs))
				if g:GetCount()==0 then return end
				if min and max then
					Duel.Hint(HINT_SELECTMSG,player,DM_HINTMSG_CONFIRM)
					local sg=g:Select(player,min,max,ex,table.unpack(funs))
					local hg=sg:Filter(Card.IsLocation,nil,DM_LOCATION_BATTLE+DM_LOCATION_SHIELD)
					Duel.HintSelection(hg)
					Duel.ConfirmCards(player,sg)
				else
					Duel.ConfirmCards(player,g)
				end
			end
end
--operation function for abilities that target cards that are not public knowledge to let a player look at them
function Auxiliary.TargetConfirmOperation(turn_faceup)
	--turn_faceup: true to turn a shield face up
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
				if g:GetCount()>0 then
					Duel.ConfirmCards(tp,g,turn_faceup)
				end
			end
end
--operation function for abilities that let a player look at cards from the top of a player's deck
function Auxiliary.DecktopConfirmOperation(p,ct)
	--p: PLAYER_SELF/tp for the top of your deck or PLAYER_OPPO/1-tp for your opponent's
	--ct: the number of cards to look at
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local player1=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp) or (p==PLAYER_ALL and tp)
				local player2=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp) or (p==PLAYER_ALL and 1-tp)
				if e:IsHasType(EFFECT_TYPE_CONTINUOUS) then Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode()) end
				local g1=Duel.GetDecktopGroup(player1,ct)
				local g2=Duel.GetDecktopGroup(player2,ct)
				if g1:GetCount()>0 then
					Duel.ConfirmCards(player1,g1)
				end
				if g2:GetCount()>0 and p==PLAYER_ALL then
					Duel.ConfirmCards(player2,g2)
				end
			end
end
--========== Destroy ==========
--operation function for abilities that destroy cards
function Auxiliary.DestroyOperation(p,f,s,o,min,max,ram,ex,...)
	--p,min,max: nil to destroy all cards
	--ram: true to destroy cards at random
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local player=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp)
				local max=max or min
				local c=e:GetHandler()
				if c:IsSpell() and c:IsLocation(LOCATION_HAND) and (s==LOCATION_HAND or o==LOCATION_HAND) then ex=c end
				if e:IsHasType(EFFECT_TYPE_CONTINUOUS) then Duel.Hint(HINT_CARD,0,c:GetOriginalCode()) end
				local g=Duel.GetMatchingGroup(f,tp,s,o,ex,table.unpack(funs))
				local sg=nil
				if min and max then
					if ram then
						sg=g:RandomSelect(player,min)
					else
						Duel.Hint(HINT_SELECTMSG,player,DM_HINTMSG_DESTROY)
						sg=g:Select(player,min,max,ex,table.unpack(funs))
					end
					local hg=sg:Filter(Card.IsLocation,nil,DM_LOCATION_BATTLE)
					Duel.HintSelection(hg)
					Duel.Destroy(sg,REASON_EFFECT)
				else
					Duel.Destroy(g,REASON_EFFECT)
				end
			end
end
--operation function for abilities that target cards to destroy
function Auxiliary.TargetDestroyOperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
--========== Discard ==========
--operation function for abilities that discard cards
function Auxiliary.DiscardOperation(p,f,s,o,min,max,ram,ex,...)
	--p,min,max: nil to discard all cards
	--ram: true to discard cards at random
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local player=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp)
				local max=max or min
				local c=e:GetHandler()
				if c:IsSpell() and c:IsLocation(LOCATION_HAND) and (s==LOCATION_HAND or o==LOCATION_HAND) then ex=c end
				if e:IsHasType(EFFECT_TYPE_CONTINUOUS) then Duel.Hint(HINT_CARD,0,c:GetOriginalCode()) end
				local g=Duel.GetMatchingGroup(f,tp,s,o,ex,table.unpack(funs))
				local sg=nil
				if min and max then
					if ram then
						sg=g:RandomSelect(player,min)
					else
						Duel.Hint(HINT_SELECTMSG,player,DM_HINTMSG_DISCARD)
						sg=g:Select(player,min,max,ex,table.unpack(funs))
					end
					Duel.DMSendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
				else
					Duel.DMSendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
				end
			end
end
--operation function for abilities that target cards to discard
function Auxiliary.TargetDiscardOperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.DMSendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	end
end
--========== Draw ==========
--target and operation functions for abilities that draw a specified number of cards
function Auxiliary.DrawTarget(p)
	--p: PLAYER_SELF/tp for you to draw or PLAYER_OPPO/1-tp for your opponent to draw
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				local player=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp)
				if chk==0 then return Duel.IsPlayerCanDraw(player,1) end
			end
end
function Auxiliary.DrawOperation(p,ct)
	--ct: the number of cards to draw
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local player=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp)
				Duel.Draw(player,ct,REASON_EFFECT)
			end
end
--operation function for abilities that draw an unspecified number of cards
--use Auxiliary.DrawTarget for the target function, if needed
function Auxiliary.DrawUpToOperation(p,ct)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local player=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp)
				Duel.DrawUpTo(player,ct,REASON_EFFECT)
			end
end
--========== SendtoBattle ==========
--target and operation functions for abilities that put creatures into the battle zone
function Auxiliary.SendtoBattleFilter(c,e,tp,f,...)
	return c:IsCanSendtoBattle(e,0,tp,false,false) and (not f or f(c,e,tp,...))
end
function Auxiliary.SendtoBattleTarget(f,s,o,ex,...)
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				if chk==0 then
					if s==LOCATION_DECK or o==LOCATION_DECK then
						return Duel.GetFieldGroupCount(tp,s,o)>0
					else
						return Duel.IsExistingMatchingCard(Auxiliary.SendtoBattleFilter,tp,s,o,1,ex,e,tp,f,table.unpack(funs))
					end
				end
			end
end
function Auxiliary.SendtoBattleOperation(p,f,s,o,min,max,pos,ex,...)
	--p,min,max: nil to put all creatures into the battle zone
	--pos: POS_FACEUP_UNTAPPED to put in untapped position or POS_FACEUP_TAPPED to put in tapped position
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local player=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp)
				local max=max or min
				local pos=pos or POS_FACEUP_UNTAPPED
				local ft=Duel.GetLocationCount(player,DM_LOCATION_BATTLE)
				if max>=0 and ft>max then ft=max end
				if e:IsHasType(EFFECT_TYPE_CONTINUOUS) then Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode()) end
				local g=Duel.GetMatchingGroup(Auxiliary.SendtoBattleFilter,tp,s,o,ex,e,tp,f,table.unpack(funs))
				if g:GetCount()>0 then
					if min and max then
						Duel.Hint(HINT_SELECTMSG,player,DM_HINTMSG_TOBATTLE)
						local sg=g:Select(player,min,ft,ex,table.unpack(funs))
						Duel.SendtoBattle(sg,0,player,player,false,false,pos)
					else
						Duel.SendtoBattle(g,0,player,player,false,false,pos)
					end
				else
					Duel.Hint(HINT_MESSAGE,player,DM_HINTMSG_NOTARGETS)
				end
			end
end
--operation function for abilities that target creatures to put into the battle zone
function Auxiliary.TargetSendtoBattleOperation(sump,tgp,pos)
	--sump: PLAYER_SELF/tp for you to put a creature into the battle zone or PLAYER_OPPO/1-tp for your opponent to
	--tgp: PLAYER_SELF/tp to put a creature into your battle zone or PLAYER_OPPO/1-tp to put into your opponent's
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local sumplayer=(sump==PLAYER_SELF and tp) or (sump==PLAYER_OPPO and 1-tp)
				local target_player=(tgp==PLAYER_SELF and tp) or (tgp==PLAYER_OPPO and 1-tp)
				local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
				if g:GetCount()>0 then
					Duel.SendtoBattle(g,0,sumplayer,target_player,false,false,pos)
				end
			end
end
--========== SendtoDeck ==========
--operation function for abilities that target cards to put into a player's deck
function Auxiliary.TargetSendtoDeckOperation(seq)
	--seq: where to put the cards (DECK_SEQUENCE_TOP|BOTTOM|SHUFFLE)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
				if g:GetCount()>0 then
					Duel.SendtoDeck(g,PLAYER_OWNER,seq,REASON_EFFECT)
				end
			end
end
--========== SendtoGrave ==========
--operation function for abilities that put cards into the graveyard
function Auxiliary.SendtoGraveOperation(p,f,s,o,min,max,ex,...)
	--p,min,max: nil to put all cards into the graveyard
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local player=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp)
				local max=max or min
				local c=e:GetHandler()
				if c:IsSpell() and c:IsLocation(LOCATION_HAND) and (s==LOCATION_HAND or o==LOCATION_HAND) then ex=c end
				if e:IsHasType(EFFECT_TYPE_CONTINUOUS) then Duel.Hint(HINT_CARD,0,c:GetOriginalCode()) end
				local g=Duel.GetMatchingGroup(aux.AND(Card.DMIsAbleToGrave,f),tp,s,o,ex,table.unpack(funs))
				if g:GetCount()>0 then
					if min and max then
						Duel.Hint(HINT_SELECTMSG,player,DM_HINTMSG_TOGRAVE)
						local sg=g:Select(player,min,max,ex,table.unpack(funs))
						local hg=sg:Filter(Card.IsLocation,nil,DM_LOCATION_BATTLE+DM_LOCATION_SHIELD)
						Duel.HintSelection(hg)
						Duel.DMSendtoGrave(sg,REASON_EFFECT)
					else
						Duel.DMSendtoGrave(g,REASON_EFFECT)
					end
				else
					Duel.Hint(HINT_MESSAGE,player,DM_HINTMSG_NOTARGETS)
				end
			end
end
--operation function for abilities that target cards to put into the graveyard
function Auxiliary.TargetSendtoGraveOperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.DMSendtoGrave(g,REASON_EFFECT)
	end
end
--========== SendtoHand ==========
--operation function for abilities that put cards into a player's hand
function Auxiliary.SendtoHandOperation(p,f,s,o,min,max,conf,ex,...)
	--p,min,max: nil to put all cards into a player's hand
	--conf: true to show cards added from the deck to the opponent
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local player=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp)
				local max=max or min
				local desc=DM_HINTMSG_RTOHAND
				if e:IsHasType(EFFECT_TYPE_CONTINUOUS) then Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode()) end
				local g=Duel.GetMatchingGroup(aux.AND(Card.IsAbleToHand,f),tp,s,o,ex,table.unpack(funs))
				if g:GetCount()>0 then
					if min and max then
						if s==LOCATION_DECK or o==LOCATION_DECK then desc=DM_HINTMSG_ATOHAND end
						Duel.Hint(HINT_SELECTMSG,player,desc)
						local sg=g:Select(player,min,max,ex,table.unpack(funs))
						local hg=sg:Filter(Card.IsLocation,nil,DM_LOCATION_BATTLE+DM_LOCATION_SHIELD)
						Duel.HintSelection(hg)
						Duel.SendtoHand(sg,PLAYER_OWNER,REASON_EFFECT)
					else
						Duel.SendtoHand(g,PLAYER_OWNER,REASON_EFFECT)
					end
					local og1=Duel.GetOperatedGroup():Filter(Card.IsControler,nil,tp)
					local og2=Duel.GetOperatedGroup():Filter(Card.IsControler,nil,1-tp)
					local og3=Duel.GetOperatedGroup():Filter(Card.IsPreviousLocation,nil,LOCATION_DECK)
					local og4=Duel.GetOperatedGroup():Filter(Card.IsPreviousLocation,nil,LOCATION_GRAVE+LOCATION_REMOVED)
					if (conf and og1:GetCount()>0 and og3:GetCount()>0) or og4:GetCount()>0 then Duel.ConfirmCards(1-tp,og1) end
					if (conf and og2:GetCount()>0 and og3:GetCount()>0) or og4:GetCount()>0 then Duel.ConfirmCards(tp,og2) end
				else
					Duel.Hint(HINT_MESSAGE,player,DM_HINTMSG_NOTARGETS)
				end
			end
end
--operation function for abilities that target cards to put into a player's hand
function Auxiliary.TargetSendtoHandOperation(conf,use_shield_trigger)
	--conf: true to show cards added from the deck to the opponent
	--use_shield_trigger: true if the controller of the returned card can use its "shield trigger" ability
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
				if g:GetCount()==0 then return end
				Duel.SendtoHand(g,PLAYER_OWNER,REASON_EFFECT,use_shield_trigger)
				local og1=Duel.GetOperatedGroup():Filter(Card.IsControler,nil,tp)
				local og2=Duel.GetOperatedGroup():Filter(Card.IsControler,nil,1-tp)
				local og3=Duel.GetOperatedGroup():Filter(Card.IsPreviousLocation,nil,LOCATION_DECK)
				local og4=Duel.GetOperatedGroup():Filter(Card.IsPreviousLocation,nil,LOCATION_GRAVE+LOCATION_REMOVED)
				if (conf and og1:GetCount()>0 and og3:GetCount()>0) or og4:GetCount()>0 then Duel.ConfirmCards(1-tp,og1) end
				if (conf and og2:GetCount()>0 and og3:GetCount()>0) or og4:GetCount()>0 then Duel.ConfirmCards(tp,og2) end
			end
end
--========== SendtoMana ==========
--operation function for abilities that put cards into the mana zone
function Auxiliary.SendtoManaOperation(p,f,s,o,min,max,ex,...)
	--p,min,max: nil to put all cards into the mana zone
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local player=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp)
				local max=max or min
				local c=e:GetHandler()
				if c:IsSpell() and c:IsLocation(LOCATION_HAND) and (s==LOCATION_HAND or o==LOCATION_HAND) then ex=c end
				if e:IsHasType(EFFECT_TYPE_CONTINUOUS) then Duel.Hint(HINT_CARD,0,c:GetOriginalCode()) end
				local g=Duel.GetMatchingGroup(aux.AND(Card.IsAbleToMana,f),tp,s,o,ex,table.unpack(funs))
				if g:GetCount()>0 then
					if min and max then
						Duel.Hint(HINT_SELECTMSG,player,DM_HINTMSG_TOMANA)
						local sg=g:Select(player,min,max,ex,table.unpack(funs))
						local hg=sg:Filter(Card.IsLocation,nil,DM_LOCATION_BATTLE+DM_LOCATION_SHIELD)
						Duel.HintSelection(hg)
						Duel.SendtoMana(sg,POS_FACEUP_UNTAPPED,REASON_EFFECT)
					else
						Duel.SendtoMana(g,POS_FACEUP_UNTAPPED,REASON_EFFECT)
					end
				else
					Duel.Hint(HINT_MESSAGE,player,DM_HINTMSG_NOTARGETS)
				end
			end
end
--operation function for abilities that target cards to put into the mana zone
function Auxiliary.TargetSendtoManaOperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoMana(g,POS_FACEUP_UNTAPPED,REASON_EFFECT)
	end
end
--target and operation functions for abilities that put cards from the top of a player's deck into the mana zone
function Auxiliary.DecktopSendtoManaTarget(p)
	--p: PLAYER_SELF/tp for the top of your deck or PLAYER_OPPO/1-tp for your opponent's
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				local player=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp)
				if chk==0 then return Duel.IsPlayerCanSendDecktoptoMana(player,1) end
			end
end
function Auxiliary.DecktopSendtoManaOperation(p,ct)
	--ct: the number of cards to put into the mana zone
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local player=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp)
				if e:IsHasType(EFFECT_TYPE_CONTINUOUS) then Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode()) end
				Duel.SendDecktoptoMana(player,ct,POS_FACEUP_UNTAPPED,REASON_EFFECT)
			end
end
--========== SendtoShield ==========
--operation function for abilities that put cards into the shield zone
function Auxiliary.SendtoShieldOperation(p,f,s,o,min,max,ex,...)
	--p,min,max: nil to put all cards into the shield zone
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local player=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp)
				local max=max or min
				local ft=Duel.GetLocationCount(player,DM_LOCATION_SHIELD)
				if max>=0 and ft>max then ft=max end
				local c=e:GetHandler()
				if c:IsSpell() and c:IsLocation(LOCATION_HAND) and (s==LOCATION_HAND or o==LOCATION_HAND) then ex=c end
				if e:IsHasType(EFFECT_TYPE_CONTINUOUS) then Duel.Hint(HINT_CARD,0,c:GetOriginalCode()) end
				local g=Duel.GetMatchingGroup(aux.AND(Card.IsAbleToShield,f),player,s,o,ex,table.unpack(funs))
				if g:GetCount()>0 then
					if min and max then
						Duel.Hint(HINT_SELECTMSG,player,DM_HINTMSG_TOSHIELD)
						local sg=g:Select(player,min,ft,ex,table.unpack(funs))
						local hg=sg:Filter(Card.IsLocation,nil,DM_LOCATION_BATTLE)
						Duel.HintSelection(hg)
						Duel.SendtoShield(sg,player)
					else
						Duel.SendtoShield(g,player)
					end
					local og=Duel.GetOperatedGroup()
					if og:GetCount()==0 then return end
					for oc in aux.Next(og) do
						if oc:IsPreviousLocation(LOCATION_GRAVE+LOCATION_REMOVED) then
							Duel.ConfirmCards(1-oc:GetControler(),oc)
						end
					end
				else
					Duel.Hint(HINT_MESSAGE,player,DM_HINTMSG_NOTARGETS)
				end
			end
end
--operation function for abilities that target cards to put into the shield zone
function Auxiliary.TargetSendtoShieldOperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 then return end
	for tc in aux.Next(g) do
		local p=tc:GetControler()
		Duel.SendtoShield(tc,p)
		if tc:IsPreviousLocation(LOCATION_GRAVE+LOCATION_REMOVED) then
			Duel.ConfirmCards(1-p,tc)
		end
	end
end
--operation function for abilities that put cards from the top of a player's deck into the shield zone
--use Auxiliary.CheckDeckFunction for the target function, if needed
function Auxiliary.DecktopSendtoShieldOperation(p,ct)
	--p: PLAYER_SELF/tp for the top of your deck or PLAYER_OPPO/1-tp for your opponent's
	--ct: the number of cards to put into the shield zone
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local player1=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp) or (p==PLAYER_ALL and tp)
				local player2=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp) or (p==PLAYER_ALL and 1-tp)
				if e:IsHasType(EFFECT_TYPE_CONTINUOUS) then Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode()) end
				Duel.SendDecktoptoShield(player1,ct)
				if p==PLAYER_ALL then
					Duel.SendDecktoptoShield(player2,ct)
				end
			end
end
--operation function for abilities that put an unspecified number of cards from the top of a player's deck into the shield zone
function Auxiliary.DecktopSendtoShieldUpToOperation(p,ct)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local player=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp)
				if e:IsHasType(EFFECT_TYPE_CONTINUOUS) then Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode()) end
				Duel.SendDecktoptoShieldUpTo(player,ct)
			end
end
--========== Sort ==========
--operation function for abilities that let a player look at the top cards of a player's deck and return them in any order
--use Auxiliary.CheckDeckFunction for the target function, if needed
function Auxiliary.SortDecktopOperation(sortp,tgp,ct)
	--sortp: PLAYER_SELF/tp for you to sort cards or PLAYER_OPPO/1-tp for your opponent to sort
	--tgp: PLAYER_SELF/tp to sort your cards or PLAYER_OPPO/1-tp to sort your opponent's
	--ct: the number of cards to sort
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local sort_player=(sortp==PLAYER_SELF and tp) or (sortp==PLAYER_OPPO and 1-tp)
				local target_player=(tgp==PLAYER_SELF and tp) or (tgp==PLAYER_OPPO and 1-tp)
				if e:IsHasType(EFFECT_TYPE_CONTINUOUS) then Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode()) end
				local g=Duel.GetDecktopGroup(target_player,ct)
				Duel.SortDecktop(sort_player,target_player,ct)
			end
end
--========== TapUntap ==========
--operation function for abilities that tap cards
function Auxiliary.TapOperation(p,f,s,o,min,max,ram,ex,...)
	--p,min,max: nil to tap all cards
	--ram: true to tap cards at random
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local player=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp)
				if e:IsHasType(EFFECT_TYPE_CONTINUOUS) then Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode()) end
				local g=Duel.GetMatchingGroup(f,tp,s,o,ex,table.unpack(funs))
				local a=Duel.GetAttacker()
				if a and a:IsUntapped() then Duel.Tap(a,REASON_RULE) end --fix creature not being tapped when attacking
				local sg=nil
				if min and max then
					if ram then
						sg=g:RandomSelect(player,min)
					else
						Duel.Hint(HINT_SELECTMSG,player,DM_HINTMSG_TAP)
						sg=g:Select(player,min,max,ex,table.unpack(funs))
					end
					local hg=sg:Filter(Card.IsLocation,nil,DM_LOCATION_BATTLE)
					Duel.HintSelection(hg)
					Duel.Tap(sg,REASON_EFFECT)
				else
					Duel.Tap(g,REASON_EFFECT)
				end
			end
end
--operation function for abilities untap cards
function Auxiliary.UntapOperation(p,f,s,o,min,max,ram,ex,...)
	--p,min,max: nil to untap all cards
	--ram: true to untap cards at random
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local player=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp)
				if e:IsHasType(EFFECT_TYPE_CONTINUOUS) then Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode()) end
				local g=Duel.GetMatchingGroup(f,tp,s,o,ex,table.unpack(funs))
				local a=Duel.GetAttacker()
				if a and a:IsUntapped() then Duel.Tap(a,REASON_RULE) end --fix creature not being tapped when attacking
				local sg=nil
				if min and max then
					if ram then
						sg=g:RandomSelect(player,min)
					else
						Duel.Hint(HINT_SELECTMSG,player,DM_HINTMSG_UNTAP)
						sg=g:Select(player,min,max,ex,table.unpack(funs))
					end
					local hg=sg:Filter(Card.IsLocation,nil,DM_LOCATION_BATTLE)
					Duel.HintSelection(hg)
					Duel.Untap(sg,REASON_EFFECT)
				else
					Duel.Untap(g,REASON_EFFECT)
				end
			end
end
--operation function for abilities that target cards to tap
function Auxiliary.TargetTapOperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Tap(g,REASON_EFFECT)
	end
end
--operation function for abilities that target cards to untap
function Auxiliary.TargetUntapOperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Untap(g,REASON_EFFECT)
	end
end

--condition to check who the turn player is
function Auxiliary.TurnPlayerCondition(p)
	return	function(e)
				local tp=e:GetHandlerPlayer()
				local player=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp)
				return Duel.GetTurnPlayer()==player
			end
end
Auxiliary.turnpcon=Auxiliary.TurnPlayerCondition
--condition to check who the reason player is
function Auxiliary.ReasonPlayerCondition(p)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local player=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp)
				return rp==player
			end
end
Auxiliary.rpcon=Auxiliary.ReasonPlayerCondition
--condition for the battle phase
function Auxiliary.BattlePhaseCondition()
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end
Auxiliary.bpcon=Auxiliary.BattlePhaseCondition
--condition of "While this creature is attacking"
--e.g. "Bolshack Dragon" (DM-01 69/110)
function Auxiliary.SelfAttackerCondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler()
end
Auxiliary.satcon=Auxiliary.SelfAttackerCondition
--condition of "Whenever this creature is attacked"
--e.g. "Scalpel Spider" (DM-07 32/55)
function Auxiliary.SelfAttackTargetCondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()==e:GetHandler()
end
Auxiliary.sdfcon=Auxiliary.SelfAttackTargetCondition
--condition of "While this creature is battling"
--e.g. "Sasha, Channeler of Suns" (DM-08 12/55)
function Auxiliary.SelfBattlingCondition(f)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				local d=Duel.GetAttackTarget()
				return (Duel.GetAttacker()==c or d==c) and c:IsRelateToBattle() and (not f or f(d))
			end
end
Auxiliary.sbatcon=Auxiliary.SelfBattlingCondition
--condition to return the creature another creature is attacking
--e.g. "Akashic Third, the Electro-Bandit" (DM-13 19/55)
function Auxiliary.AttackTargetCondition(f)
	return	function(e,tp,eg,ep,ev,re,r,rp) 
				local d=Duel.GetAttackTarget()
				return d and d:IsFaceup() and (not f or f(d))
			end
end
Auxiliary.dfcon=Auxiliary.AttackTargetCondition
--condition of "Whenever this creature wins a battle" + EVENT_BATTLE_DESTROYING
--e.g. "Bloody Squito" (DM-01 46/110), "Hanakage, Shadow of Transience" (Game Original)
function Auxiliary.SelfBattleWinCondition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:IsOnField()
end
Auxiliary.sbwcon=Auxiliary.SelfBattleWinCondition
--condition of "Whenever this creature blocks" + DM_EVENT_BATTLE_END
--e.g. "Spiral Grass" (DM-02 10/55)
function Auxiliary.SelfBlockCondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetBlocker()==e:GetHandler()
end
Auxiliary.sblcon=Auxiliary.SelfBlockCondition
--condition of "Whenever one of your creatures blocks" + DM_EVENT_BATTLE_END
--e.g. "Agira, the Warlord Crawler" (DM-12 16/55)
function Auxiliary.BlockCondition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(Duel.GetBlocker())
end
Auxiliary.blcon=Auxiliary.BlockCondition
--condition to check what a card's previous location was
--e.g. "Bombersaur" (DM-02 36/55), "Altimeth, Holy Divine Dragon" (Game Original)
function Auxiliary.PreviousLocationCondition(loc)
	--loc: DM_LOCATION_BATTLE for "When this creature is destroyed/leaves the battle zone" + EVENT_DESTROYED
	return	function(e,tp,eg,ep,ev,re,r,rp)
				return e:GetHandler():IsPreviousLocation(loc)
			end
end
Auxiliary.plocon=Auxiliary.PreviousLocationCondition
--condition of "While this creature is tapped"
--e.g. "Barkwhip, the Smasher" (DM-02 45/55)
function Auxiliary.SelfTappedCondition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsTapped()
end
Auxiliary.stapcon=Auxiliary.SelfTappedCondition
--condition of "While all the cards in your mana zone are CIVILIZATION cards"
--e.g. "Sparkle Flower" (DM-03 9/55)
function Auxiliary.ManaExclusiveCondition(f,...)
	local ext_params={...}
	return	function(e)
				local tp=e:GetHandlerPlayer()
				local filter_func=function(c,f,...)
					return not f(c,...)
				end
				return Duel.IsExistingMatchingCard(Auxiliary.ManaZoneFilter(),tp,DM_LOCATION_MANA,0,1,nil,f,table.unpack(ext_params))
					and not Duel.IsExistingMatchingCard(Auxiliary.ManaZoneFilter(filter_func),tp,DM_LOCATION_MANA,0,1,nil,f,table.unpack(ext_params))
			end
end
Auxiliary.mexcon=Auxiliary.ManaExclusiveCondition
--condition of "When a card is put into your graveyard" + DM_EVENT_TO_GRAVE
--e.g. "Snork La, Shrine Guardian" (DM-05 13/55)
function Auxiliary.EnterGraveCondition(p)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local player=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp)
				local f=function(c,player)
					if player then
						return c:IsControler(player)
					else return true end
				end
				return eg:IsExists(Auxiliary.DMGraveFilter(f),1,nil,player)
			end
end
Auxiliary.tgcon=Auxiliary.EnterGraveCondition
--condition of "While a player has no shields"
--e.g. "Gigazoul" (DM-05 28/55)
function Auxiliary.NoShieldsCondition(p)
	return	function(e)
				local tp=e:GetHandlerPlayer()
				local player=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp)
				return Duel.GetShieldCount(player)==0
			end
end
Auxiliary.nszcon=Auxiliary.NoShieldsCondition
--condition of "While a player has no cards in their hand"
--e.g. "Headlong Giant" (DM-07 S5/S5)
function Auxiliary.NoHandCondition(p)
	return	function(e)
				local tp=e:GetHandlerPlayer()
				local player=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp)
				return Duel.GetFieldGroupCount(player,LOCATION_HAND,0)==0
			end
end
Auxiliary.nhcon=Auxiliary.NoHandCondition
--cost function for a card tapping itself
--e.g. "Millstone Man" (Game Original)
function Auxiliary.SelfTapCost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsFaceup() and c:IsUntapped() end
	Duel.Tap(c,REASON_COST)
end
Auxiliary.stapcost=Auxiliary.SelfTapCost
--target function for optional abilities that do not target cards
function Auxiliary.CheckCardFunction(f,s,o,ex,...)
	--f: include Card.IsAbleToX for Duel.SendtoX, Card.IsDiscardable for Duel.DiscardHand, etc.
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				local c=e:GetHandler()
				if c:IsSpell() and c:IsLocation(LOCATION_HAND) and (s==LOCATION_HAND or o==LOCATION_HAND) then ex=c end
				if chk==0 then return Duel.IsExistingMatchingCard(f,tp,s,o,1,ex,table.unpack(funs)) end
			end
end
Auxiliary.chktg=Auxiliary.CheckCardFunction
--target function for abilities that target cards
function Auxiliary.TargetCardFunction(p,f,s,o,min,max,desc,ex,...)
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				local player=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp)
				local max=max or min
				local desc=desc or DM_HINTMSG_TARGET
				local c=e:GetHandler()
				if c:IsSpell() and c:IsLocation(LOCATION_HAND) and (s==LOCATION_HAND or o==LOCATION_HAND) then ex=c end
				local extype=type(ex)
				local exg=Group.CreateGroup()
				if extype=="Card" then exg:AddCard(ex)
				elseif extype=="Group" then exg:Merge(ex)
				elseif extype=="function" then
					exg=ex(e,tp,eg,ep,ev,re,r,rp)
				end
				if chkc then
					if min>1 then return false end
					if not chkc:IsLocation(s+o) then return false end
					if s==0 and o>0 and chkc:IsControler(tp) then return false end
					if o==0 and s>0 and chkc:IsControler(1-tp) then return false end
					if f and not f(chkc,e,tp,eg,ep,ev,re,r,rp) then return false end
					if exg:GetCount()>0 and exg:IsContains(chkc) then return false end
					return true
				end
				if chk==0 then
					if e:IsHasType(EFFECT_TYPE_TRIGGER_F) or e:IsHasType(EFFECT_TYPE_QUICK_F) or c:IsSpell() then
						return true
					else
						return Duel.IsExistingTarget(f,tp,s,o,1,ex,table.unpack(funs))
					end
				end
				Duel.Hint(HINT_SELECTMSG,player,desc)
				Duel.SelectTarget(player,f,tp,s,o,min,max,ex,table.unpack(funs))
			end
end
Auxiliary.targtg=Auxiliary.TargetCardFunction
--target function to check if a player has cards in their deck
function Auxiliary.CheckDeckFunction(p)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				local player=(p==PLAYER_SELF and tp) or (p==PLAYER_OPPO and 1-tp)
				if chk==0 then return Duel.GetFieldGroupCount(player,LOCATION_DECK,0)>0 end
			end
end
Auxiliary.chkdtg=Auxiliary.CheckDeckFunction
--target function for Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
function Auxiliary.HintTarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if e:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		if chkc then return false end
	end
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
Auxiliary.hinttg=Auxiliary.HintTarget
--filter to return a card in the mana zone
function Auxiliary.ManaZoneFilter(f)
	--DM_LOCATION_MANA + f: function
	return	function(target,...)
				return target:IsMana() and (not f or f(target,...))
			end
end
Auxiliary.mzfilter=Auxiliary.ManaZoneFilter
--filter to return a card in the graveyard
function Auxiliary.DMGraveFilter(f)
	--DM_LOCATION_GRAVE + f: function
	return	function(target,...)
				return target:IsGrave() and (not f or f(target,...))
			end
end
Auxiliary.gyfilter=Auxiliary.DMGraveFilter
--filter to return a card in the shield zone
function Auxiliary.ShieldZoneFilter(f)
	--DM_LOCATION_SHIELD + f: function
	return	function(target,...)
				return target:IsShield() and (not f or f(target,...))
			end
end
Auxiliary.szfilter=Auxiliary.ShieldZoneFilter
return Auxiliary
--[[
	References
		1. Prevent multiple "shield trigger" abilities from chaining
			1.1. Voltanis the Adjudicator
			https://github.com/Fluorohydride/ygopro-scripts/blob/967a2fe/c20951752.lua#L12
		2. Auxiliary.mana_cost_list
		https://duelmasters.fandom.com/wiki/Category:Cards_by_Mana_Cost
]]
