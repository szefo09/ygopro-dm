--[[
	Duel Masters Trading Card Game Utility

	Usage: Put this file in the expansions folder
	
	Include the following code in your script
	
	local dm=require "expansions.utility_dmtcg"
]]

--CONTENTS
--[+UniversalFunctions]......................................functions that are included on every script
--[+RuleFunctions]...........................................functions that are included on the rules card
--[+Creature]................................................functions that are included on every creature
--[+EvolutionCreature].......................................functions that are included on every evolution creature
--[+Spell]...................................................functions that are included on every spell
--[+KeywordAbilities]........................................keyword abilities that are shared by many cards
--[+Abilities]...............................................abilities that are shared by many cards
--[+Conditions]..............................................condition functions
--[+Costs]...................................................cost functions
--[+Targets].................................................target functions
--[+Filters].................................................filter functions

local Auxiliary={}
local DMTCG=require "expansions.constant_dmtcg"
DM_CIVILIZATIONS_LW=DM_CIVILIZATIONS_LIGHT_WATER
DM_CIVILIZATIONS_LD=DM_CIVILIZATIONS_LIGHT_DARKNESS
DM_CIVILIZATIONS_LF=DM_CIVILIZATIONS_LIGHT_FIRE
DM_CIVILIZATIONS_LN=DM_CIVILIZATIONS_LIGHT_NATURE
DM_CIVILIZATIONS_WD=DM_CIVILIZATIONS_WATER_DARKNESS
DM_CIVILIZATIONS_WF=DM_CIVILIZATIONS_WATER_FIRE
DM_CIVILIZATIONS_WN=DM_CIVILIZATIONS_WATER_NATURE
DM_CIVILIZATIONS_DF=DM_CIVILIZATIONS_DARKNESS_FIRE
DM_CIVILIZATIONS_DN=DM_CIVILIZATIONS_DARKNESS_NATURE
DM_CIVILIZATIONS_FN=DM_CIVILIZATIONS_FIRE_NATURE
EFFECT_INDESTRUCTIBLE=EFFECT_INDESTRUCTABLE
EFFECT_INDESTRUCTIBLE_EFFECT=EFFECT_INDESTRUCTABLE_EFFECT
EFFECT_INDESTRUCTIBLE_BATTLE=EFFECT_INDESTRUCTABLE_BATTLE

--==========[+UniversalFunctions]==========
--get the script's name and card id
function Auxiliary.GetID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local scard=_G[str]
	local sid=tonumber(string.sub(str,2))
	return scard,sid
end
--include this code on each script: local scard,sid=dm.GetID()

--========== Lua ==========
--get the value type of a variable
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
--check if a card can be put into the battle zone
local card_is_can_be_special_summoned=Card.IsCanBeSpecialSummoned
function Card.IsCanBeSpecialSummoned(c,...)
	if c:IsLocation(LOCATION_REMOVED) and c:IsFacedown() then
		return true --temporary workaround to allow face-down banished monsters to special summon
	else return card_is_can_be_special_summoned(c,...) end
end
Card.IsCanBePutIntoBattleZone=Card.IsCanBeSpecialSummoned
--check if a card can be discarded from a player's hand
local card_is_discardable=Card.IsDiscardable
function Card.IsDiscardable(c,...)
	if c:IsHasEffect(EFFECT_CANNOT_BE_DISCARD) or c:IsHasEffect(EFFECT_CANNOT_REMOVE) then return false end
	return card_is_discardable(c,...)
end
--check if a card can attack
--[[
local card_is_attackable=Card.IsAttackable
function Card.IsAttackable(c)
	if c:IsHasEffect(DM_EFFECT_IGNORE_CANNOT_ATTACK) then return true end
	return card_is_attackable(c)
end
]]
--check if a card is a creature
function Card.IsCreature(c)
	return c:IsType(DM_TYPE_CREATURE)
end
--check if a card is an evolution creature
function Card.IsEvolutionCreature(c)
	return c:IsCreature() and c:IsType(DM_TYPE_EVOLUTION)
end
--check if a card is a spell
function Card.IsSpell(c)
	return c:IsType(TYPE_SPELL)
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
Card.IsFaceupUntapped=aux.AND(Card.IsFaceup,Card.IsUntapped)
--check if a card is tapped
function Card.IsTapped(c)
	if c:IsLocation(LOCATION_REMOVED) then
		return c:IsFacedown()
	elseif c:IsLocation(LOCATION_MZONE) then 
		return c:IsDefensePos()
	else return false end
end
Card.IsFaceupTapped=aux.AND(Card.IsFaceup,Card.IsTapped)
--check if a card can be untapped
function Card.IsAbleToUntap(c)
	if c:IsHasEffect(DM_EFFECT_CANNOT_CHANGE_POS_ABILITY) or not c:IsTapped() then return false end
	if c:IsLocation(LOCATION_REMOVED) then
		return c:IsAbleToGrave()
	elseif c:IsLocation(LOCATION_MZONE) then
		return c:IsDefensePos()
	else return false end
end
--check if a card can be tapped
function Card.IsAbleToTap(c)
	if c:IsHasEffect(DM_EFFECT_CANNOT_CHANGE_POS_ABILITY) or not c:IsUntapped() then return false end
	if c:IsLocation(LOCATION_GRAVE) then
		return c:IsAbleToRemove()
	elseif c:IsLocation(LOCATION_MZONE) then
		return c:IsAttackPos()
	else return false end
end
--check if a card can be untapped as a cost
function Card.IsAbleToUntapAsCost(c)
	if not c:IsTapped() then return false end
	if c:IsLocation(LOCATION_REMOVED) then
		return c:IsAbleToGraveAsCost()
	elseif c:IsLocation(LOCATION_MZONE) then
		return c:IsDefensePos()
	else return false end
end
--check if a card can be tapped as a cost
function Card.IsAbleToTapAsCost(c)
	if not c:IsUntapped() then return false end
	if c:IsLocation(LOCATION_GRAVE) then
		return c:IsAbleToRemoveAsCost()
	elseif c:IsLocation(LOCATION_MZONE) then
		return c:IsAttackPos()
	else return false end
end
--check if a card is a broken shield
function Card.IsBrokenShield(c)
	return c:GetFlagEffect(DM_EFFECT_BROKEN_SHIELD)>0
end
--check if a card can be summoned or cast for no cost
function Card.IsCanCastFree(c)
	return c:GetLevel()<=0 or (c:IsBrokenShield() and c:IsHasEffect(DM_EFFECT_SHIELD_TRIGGER))
end
--check if a creature has become blocked
function Card.IsBlocked(c)
	return c:GetFlagEffect(DM_EFFECT_BLOCKED)>0
end
--check if a creature can attack
function Card.IsCanAttack(c)
	if c:IsHasEffect(DM_EFFECT_IGNORE_CANNOT_ATTACK) then return true end
	return --[[c:IsAttackable() and]] not c:IsHasEffect(EFFECT_CANNOT_ATTACK)
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
	return c:IsEvolutionCreature() or c:IsHasEffect(DM_EFFECT_SPEED_ATTACKER)
		or c:IsHasEffect(DM_EFFECT_IGNORE_SUMMONING_SICKNESS)
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
	return c:IsFaceupUntapped() --and not c:IsHasEffect(DM_EFFECT_CANNOT_BLOCK) --reserved
end
--check if a creature has no abilities
--reserved
function Card.IsHasNoAbility(c)
	return c:IsType(DM_TYPE_NO_ABILITY)
end
--get the number of shields a creature broke during the current turn
function Card.GetBrokenShieldCount(c)
	return c:GetFlagEffect(DM_EFFECT_BREAK_SHIELD)
end
--check if a card has a particular race
Card.IsDMRace=Card.IsSetCard
--check if a card originally had a particular race
Card.IsOriginalDMRace=Card.IsOriginalSetCard
--check if a card had a particular race when it was in the battle zone
Card.IsPreviousDMRace=Card.IsPreviousSetCard
--check if a card is included in a particular name category
Card.IsNameCategory=Card.IsSetCard
--check if a card was originally included in a particular name category
Card.IsOriginalNameCategory=Card.IsOriginalSetCard
--check if a card was included in a particular name category when it was in the battle zone
Card.IsPreviousNameCategory=Card.IsPreviousSetCard
--get a card's CURRENT mana cost
Card.GetManaCost=Card.GetLevel
--get a card's ORIGINAL mana cost
Card.GetOriginalManaCost=Card.GetOriginalLevel
--get the mana cost a card had when it was in the battle zone
Card.GetPreviousManaCostOnField=Card.GetPreviousLevelOnField
--check if a card's mana cost is n
function Card.IsLevel(c,lv)
	return c:GetLevel()==lv
end
Card.IsManaCost=Card.IsLevel
--check if a card's mana cost is n or less
Card.IsManaCostBelow=Card.IsLevelBelow
--check if a card's mana cost is n or more
Card.IsManaCostAbove=Card.IsLevelAbove
--get a card's CURRENT civilization
Card.GetCivilization=Card.GetAttribute
--get a card's ORIGINAL civilization
Card.GetOriginalCivilization=Card.GetOriginalAttribute
--get the civilization a card had when it was in the battle zone
Card.GetPreviousCivilizationOnField=Card.GetPreviousAttributeOnField
--check what a card's current civilization is
Card.IsCivilization=Card.IsAttribute
--get a creature's CURRENT power
Card.GetPower=Card.GetAttack
--get a creature's ORIGINAL power
Card.GetBasePower=Card.GetBaseAttack
--get the power printed on a card
Card.GetTextPower=Card.GetTextAttack
--get the power a creature had when it was in the battle zone
Card.GetPreviousPowerOnField=Card.GetPreviousAttackOnField
--check if a creature's power is n
function Card.IsAttack(c,atk)
	return c:GetAttack()==atk
end
Card.IsPower=Card.IsAttack
--check if a creature's power is n or less
Card.IsPowerBelow=Card.IsAttackBelow
--check if a creature's power is n or more
Card.IsPowerAbove=Card.IsAttackAbove
--check if a card can be put into the mana zone
Card.IsAbleToMana=Card.IsAbleToGrave
--check if a card can be put into the graveyard
Card.IsAbleToDMGrave=Card.IsAbleToRemove
--check if a card can be put into the graveyard as a cost
Card.IsAbleToDMGraveAsCost=Card.IsAbleToRemoveAsCost
--get the cards stacked under a card
Card.GetStackGroup=Card.GetOverlayGroup
--get the number of cards stacked under a card
Card.GetStackCount=Card.GetOverlayCount
--========== Group ==========
--select a specified card from a group
local group_filter_select=Group.FilterSelect
function Group.FilterSelect(g,player,f,min,max,ex,...)
	if not g:IsExists(f,1,ex,...) then Duel.Hint(HINT_MESSAGE,player,DM_HINTMSG_NOTARGETS) end
	return group_filter_select(g,player,f,min,max,ex,...)
end
--select a card from a group
local group_select=Group.Select
function Group.Select(g,player,min,max,ex)
	if g:GetCount()==0 then Duel.Hint(HINT_MESSAGE,player,DM_HINTMSG_NOTARGETS) end
	return group_select(g,player,min,max,ex)
end
--select a number of cards from a group at random
local group_random_select=Group.RandomSelect
function Group.RandomSelect(g,player,count)
	if g:GetCount()==0 then Duel.Hint(HINT_MESSAGE,player,DM_HINTMSG_NOTARGETS) end
	return group_random_select(g,player,count)
end
--========== Duel ==========
--put a card into a player's hand
local duel_send_to_hand=Duel.SendtoHand
function Duel.SendtoHand(targets,player,reason)
	if type(targets)=="Card" then targets=Group.FromCards(targets) end
	for tc in aux.Next(targets) do
		local g=tc:GetStackGroup()
		targets:Merge(g)
	end
	return duel_send_to_hand(targets,player,reason)
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
		if Duel.GetLocationCount(target_player,DM_LOCATION_BATTLE)<=0 then
			Duel.Hint(HINT_MESSAGE,sumplayer,DM_HINTMSG_NOBZONES)
			Duel.SendtoDMGrave(tc,REASON_RULE) --put into the graveyard if all zones are occupied
		end
		if Duel.SpecialSummonStep(tc,sumtype,sumplayer,target_player,nocheck,nolimit,pos,zone) then
			ct=ct+1
		end
	end
	Duel.SpecialSummonComplete()
	return ct
end
Duel.PutIntoBattleZone=Duel.SpecialSummon
Duel.PutIntoBattleZoneStep=Duel.SpecialSummonStep
Duel.PutIntoBattleZoneComplete=Duel.SpecialSummonComplete
--untap/tap a card in the battle/mana zone
local duel_change_position=Duel.ChangePosition
function Duel.ChangePosition(targets,au)
	if type(targets)=="Card" then targets=Group.FromCards(targets) end
	for tc in aux.Next(targets) do
		if au==POS_FACEUP_UNTAPPED and tc:IsAbleToUntap() then
			if tc:IsLocation(LOCATION_REMOVED) then
				Duel.SendtoGrave(tc,REASON_EFFECT)
			end
		elseif au==POS_FACEUP_TAPPED and tc:IsAbleToTap() then
			if tc:IsLocation(LOCATION_GRAVE) then
				Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
	return duel_change_position(targets,au)
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
local duel_select_matching_card=Duel.SelectMatchingCard
function Duel.SelectMatchingCard(sel_player,f,player,s,o,min,max,ex,...)
	if not Duel.IsExistingMatchingCard(f,player,s,o,1,ex,...) then
		Duel.Hint(HINT_MESSAGE,sel_player,DM_HINTMSG_NOTARGETS)
	end
	return duel_select_matching_card(sel_player,f,player,s,o,min,max,ex,...)
end
--choose a card
local duel_select_target=Duel.SelectTarget
function Duel.SelectTarget(sel_player,f,player,s,o,min,max,ex,...)
	if not Duel.IsExistingTarget(f,player,s,o,1,ex,...) then
		Duel.Hint(HINT_MESSAGE,sel_player,DM_HINTMSG_NOTARGETS)
	end
	return duel_select_target(sel_player,f,player,s,o,min,max,ex,...)
end
--tap a card in the mana zone to summon a creature or to cast a spell
function Duel.PayManaCost(targets)
	if type(targets)=="Card" then targets=Group.FromCards(targets) end
	local ct=0
	for tc in aux.Next(targets) do
		ct=ct+Duel.Remove(tc,POS_FACEDOWN,REASON_COST)
	end
	return ct
end
--break a shield
function Duel.BreakShield(e,sel_player,target_player,min,max,rc,reason)
	local reason=reason or 0
	local g=Duel.GetMatchingGroup(Auxiliary.ShieldZoneFilter(),target_player,DM_LOCATION_SHIELD,0,nil)
	local ct1=g:GetCount()
	if ct1==0 then return end
	if rc then
		if rc:IsBlocked() then return end
		local db=rc:IsHasEffect(DM_EFFECT_DOUBLE_BREAKER)
		local tb=rc:IsHasEffect(DM_EFFECT_TRIPLE_BREAKER)
		if rc:GetEffectCount(DM_EFFECT_BREAKER)==1 then
			if db then min,max=2,2
			elseif tb then min,max=3,3 end
		elseif rc:GetEffectCount(DM_EFFECT_BREAKER)>1 then
			local available_list={}
			if db then table.insert(available_list,1) end
			if tb then table.insert(available_list,2) end
			local option_list={}
			for _,ab in pairs(available_list) do
				table.insert(option_list,Auxiliary.break_select_list[ab])
			end
			Duel.Hint(HINT_SELECTMSG,sel_player,DM_HINTMSG_APPLYABILITY)
			local opt=Duel.SelectOption(sel_player,table.unpack(option_list))+1
			if opt==1 then min,max=2,2
			elseif opt==2 then min,max=3,3 end
		end
	end
	Duel.Hint(HINT_SELECTMSG,sel_player,DM_HINTMSG_BREAK)
	local sg=g:Select(sel_player,min,max,nil)
	Duel.HintSelection(sg)
	local ct2=ct2+Duel.SendtoHand(sg,PLAYER_OWNER,reason+DM_REASON_BREAK)
	--raise event for "Whenever this creature breaks a shield" + re:GetHandler()==e:GetHandler()
	Duel.RaiseEvent(sg,EVENT_CUSTOM+DM_EVENT_BREAK_SHIELD,e,0,0,0,0)
	return ct2
end
--put a card into the mana zone
function Duel.SendtoMana(targets,pos,reason)
	if type(targets)=="Card" then targets=Group.FromCards(targets) end
	local ct=0
	for tc in aux.Next(targets) do
		if pos==POS_FACEUP_UNTAPPED then
			ct=ct+Duel.SendtoGrave(tc,reason)
		elseif pos==POS_FACEUP_TAPPED then
			Duel.DisableShuffleCheck()
			ct=ct+Duel.Remove(tc,POS_FACEDOWN,reason)
		end
	end
	return ct
end
--put a card from the top of a player's deck into the mana zone
function Duel.SendDecktoptoMana(player,count,pos,reason)
	local ct=0
	if pos==POS_FACEUP_UNTAPPED then
		ct=ct+Duel.DiscardDeck(player,count,reason)
	elseif pos==POS_FACEUP_TAPPED then
		local g=Duel.GetDecktopGroup(player,count)
		Duel.DisableShuffleCheck()
		ct=ct+Duel.Remove(g,POS_FACEDOWN,reason)
	end
	return ct
end
--put up to a number of cards from the top of a player's deck into the mana zone
--reserved
--[[
function Duel.SendDecktoptoManaUpTo(player,count,pos,reason)
	local ct=0
	if pos==POS_FACEUP_UNTAPPED then
		repeat
			ct=ct+Duel.DiscardDeck(player,1,reason)
			count=count-1
		until count==0 or not Duel.IsPlayerCanSendDecktoptoMana(player,1) or not Duel.SelectYesNo(player,DN_QHINTMSG_TOMANAEXTRA)
	elseif pos==POS_FACEUP_TAPPED then
		local tc=Duel.GetDecktopGroup(player,1):GetFirst()
		repeat
			ct=ct+Duel.Remove(tc,POS_FACEDOWN,reason)
			count=count-1
		until count==0 or not Duel.IsPlayerCanSendDecktoptoMana(player,1) or not Duel.SelectYesNo(player,DN_QHINTMSG_TOMANAEXTRA)
	end
	return ct
end
]]
--put a card into the graveyard
function Duel.SendtoDMGrave(targets,reason)
	if type(targets)=="Card" then targets=Group.FromCards(targets) end
	local ct=0
	for tc1 in aux.Next(targets) do
		local g=tc1:GetStackGroup()
		for tc2 in aux.Next(g) do
			ct=ct+Duel.Remove(tc2,POS_FACEUP,reason)
		end
		if tc1:IsLocation(LOCATION_REMOVED) and tc1:IsFacedown() then
			--workaround to banish a banished card
			if Duel.SendtoHand(tc1,PLAYER_OWNER,REASON_RULE)~=0 then Duel.ConfirmCards(1-tc1:GetControler(),tc1) end
		end
		ct=ct+Duel.Remove(tc1,POS_FACEUP,reason)
	end
	return ct
end
--add a card to a player's shields face down
function Duel.SendtoShield(targets,player)
	if type(targets)=="Card" then targets=Group.FromCards(targets) end
	local b=nil
	for tc1 in aux.Next(targets) do
		local g=tc1:GetStackGroup()
		for tc2 in aux.Next(g) do
			if Duel.GetLocationCount(player,DM_LOCATION_SHIELD)<=0 then
				Duel.Hint(HINT_MESSAGE,player,DM_HINTMSG_NOSZONES)
				Duel.SendtoDMGrave(tc2,REASON_RULE) --put into the graveyard if all zones are occupied
			end
			b=Duel.MoveToField(tc2,player,player,DM_LOCATION_SHIELD,POS_FACEDOWN,true)
		end
		if Duel.GetLocationCount(player,DM_LOCATION_SHIELD)<=0 then
			Duel.Hint(HINT_MESSAGE,player,DM_HINTMSG_NOSZONES)
			Duel.SendtoDMGrave(tc1,REASON_RULE) --put into the graveyard if all zones are occupied
		end
		b=Duel.MoveToField(tc1,player,player,DM_LOCATION_SHIELD,POS_FACEDOWN,true)
	end
	return b
end
--draw up to a number of cards
function Duel.DrawUpTo(player,count,reason)
	local ct=Duel.GetFieldGroupCount(player,LOCATION_DECK,0)
	if ct==0 or not Duel.IsPlayerCanDraw(player,1) or not Duel.SelectYesNo(player,DM_QHINTMSG_DRAW) then return end
	if ct>count then ct=count end
	local t={}
	for i=1,ct do t[i]=i end
	Duel.Hint(HINT_SELECTMSG,player,DM_QHINTMSG_NUMBERDRAW)
	local an=Duel.AnnounceNumber(player,table.unpack(t))
	return Duel.Draw(player,an,reason)
end
--discard a card at random
function Duel.RandomDiscardHand(player,count,reason,ex)
	local reason=reason or REASON_EFFECT
	local g=Duel.GetFieldGroup(player,LOCATION_HAND,0):RandomSelect(player,count)
	if type(ex)=="Card" then g:RemoveCard(ex)
	elseif type(ex)=="Group" then g:Sub(ex) end
	return Duel.Remove(g,POS_FACEUP,reason+REASON_DISCARD)
end
--get the number of shields a player's creatures broke during the current turn
function Duel.GetBrokenShieldCount(player)
	return Duel.GetFlagEffect(player,DM_EFFECT_BREAK_SHIELD)
end
--check if a player can trigger a creature's "blocker" ability
--reserved
function Duel.IsPlayerCanBlock(player)
	return not Duel.IsPlayerAffectedByEffect(player,DM_EFFECT_CANNOT_BLOCK)
end
--put a card on top of another card
Duel.PutOnTop=Duel.Overlay
--check if a player can put the top card of their deck into the mana zone
Duel.IsPlayerCanSendDecktoptoMana=Duel.IsPlayerCanDiscardDeck
--check if a player can put the top card of their deck into the mana zone as a cost
Duel.IsPlayerCanSendDecktoptoManaAsCost=Duel.IsPlayerCanDiscardDeckAsCost
--========== Auxiliary ==========
--add and remove a description from a card
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
				if c:GetFlagEffect(10+desc_id)>0 then return end
				c:RegisterFlagEffect(10+desc_id,RESET_EVENT+RESETS_STANDARD+RESET_DISABLE,EFFECT_FLAG_CLIENT_HINT,1,0,desc)
			end
end
function Auxiliary.RemoveEffectDescOperation(desc_id)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				if e:GetHandler():GetFlagEffect(10+desc_id)==0 then return end
				e:GetHandler():ResetFlagEffect(10+desc_id)
			end
end

--==========[+RuleFunctions]==========
--functions that are included on the rules card
function Auxiliary.RuleProtect(c)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(DM_LOCATION_RULES)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e1b=e1:Clone()
	e1b:SetCode(EFFECT_IMMUNE_EFFECT)
	e1b:SetValue(function(e,re)
		return re:GetHandler()~=e:GetHandler()
	end)
	c:RegisterEffect(e1b)
	--indestructible
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTIBLE)
	e2:SetRange(DM_LOCATION_RULES)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e2b=e2:Clone()
	e2b:SetCode(EFFECT_INDESTRUCTIBLE_BATTLE)
	c:RegisterEffect(e2b)
	local e2c=e2:Clone()
	e2c:SetCode(EFFECT_INDESTRUCTIBLE_EFFECT)
	c:RegisterEffect(e2c)
	--cannot release
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UNRELEASABLE_SUM)
	e3:SetRange(DM_LOCATION_RULES)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e3b=e3:Clone()
	e3b:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e3b)
	local e3c=e3:Clone()
	e3c:SetCode(EFFECT_UNRELEASABLE_EFFECT)
	c:RegisterEffect(e3c)
	--cannot be material
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e4b=e4:Clone()
	e4b:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e4b)
	local e4c=e4:Clone()
	e4c:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e4c)
	local e4d=e4:Clone()
	e4d:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e4d)
	--cannot change zone
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_TO_HAND)
	e5:SetRange(DM_LOCATION_RULES)
	c:RegisterEffect(e5)
	local e5b=e5:Clone()
	e5b:SetCode(EFFECT_CANNOT_TO_DECK)
	c:RegisterEffect(e5b)
	local e5c=e5:Clone()
	e5c:SetCode(EFFECT_CANNOT_REMOVE) 
	c:RegisterEffect(e5c)
	local e5d=e5:Clone()
	e5d:SetCode(EFFECT_CANNOT_TO_GRAVE)
	c:RegisterEffect(e5d)
	local e6=Effect.CreateEffect(c)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e6)
	local e6b=e6:Clone()
	e6b:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e6b)
	local e6c=e6:Clone()
	e6c:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e6c)
	local e6d=e6:Clone()
	e6d:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(e6d)
	local e6e=e6:Clone()
	e6e:SetCode(EFFECT_CANNOT_SSET)
	c:RegisterEffect(e6e)
	local e6f=e6:Clone()
	e6f:SetCode(EFFECT_CANNOT_USE_AS_COST)
	c:RegisterEffect(e6f)
	if c:IsLocation(LOCATION_FZONE) then
		local e7=Effect.CreateEffect(c)
		e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_PLAYER_TARGET)
		e7:SetType(EFFECT_TYPE_FIELD)
		e7:SetCode(EFFECT_CANNOT_ACTIVATE)
		e7:SetRange(DM_LOCATION_RULES)
		e7:SetTargetRange(1,0)
		e7:SetValue(function(e,re)
			return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsType(TYPE_FIELD)
		end)
		c:RegisterEffect(e7)
	end
	--remove type
	local e8=Effect.CreateEffect(c)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_REMOVE_TYPE)
	e8:SetRange(DM_LOCATION_RULES)
	e8:SetValue(DM_TYPE_RULE)
	c:RegisterEffect(e8)
end
--skip
function Auxiliary.RuleSkipPhase(c,code)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(code)
	e1:SetRange(DM_LOCATION_RULES)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)
end
--infinite hand
function Auxiliary.RuleInfiniteHand(c)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_HAND_LIMIT)
	e1:SetRange(DM_LOCATION_RULES)
	e1:SetTargetRange(1,0)
	e1:SetValue(MAX_NUMBER)
	c:RegisterEffect(e1)
end
--infinite attacks
function Auxiliary.RuleInfiniteAttack(c)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetRange(DM_LOCATION_RULES)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(MAX_NUMBER)
	c:RegisterEffect(e1)
end
--cannot change position
function Auxiliary.RuleCannotChangePosition(c)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e1:SetRange(DM_LOCATION_RULES)
	e1:SetTargetRange(LOCATION_MZONE,0)
	c:RegisterEffect(e1)
end
--no effect damage
function Auxiliary.RuleNoEffectDamage(c)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetRange(DM_LOCATION_RULES)
	e1:SetTargetRange(1,0)
	e1:SetValue(function(e,re,val,r,rp,rc)
		if bit.band(r,REASON_EFFECT)~=0 then return 0 end
		return val
	end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetRange(DM_LOCATION_RULES)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
end
--cannot summon/mset
function Auxiliary.RuleCannotSummonMSet(c)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetRange(DM_LOCATION_RULES)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(e2)
end
--cannot replay
function Auxiliary.RuleCannotReplay(c)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetRange(DM_LOCATION_RULES)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_ONFIELD)
			and Duel.GetTurnPlayer()==e:GetHandlerPlayer() and Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local a=Duel.GetAttacker()
		local d=Duel.GetAttackTarget()
		--[[if not d or not d:IsOnField() then
			Duel.ChangePosition(a,POS_FACEUP_TAPPED)
			return
		end]]
		Duel.ChangeAttackTarget(d)
	end)
	c:RegisterEffect(e1)
end

--==========[+Creature]==========
--summon procedure
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
	c:RegisterEffect(e1)
end
function Auxiliary.PayManaFilter(c)
	return c:IsUntapped() and c:IsAbleToTapAsCost()
end
function Auxiliary.NonEvolutionSummonCondition(e,c)
	if c==nil then return true end
	if c:IsEvolutionCreature() then return false end
	if c:IsCanCastFree() then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(Auxiliary.PayManaFilter,tp,DM_LOCATION_MANA,0,nil)
	if Duel.GetLocationCount(tp,DM_LOCATION_BATTLE)<=0 or g:GetCount()<c:GetManaCost() then return false end
	return g:IsExists(Card.IsCivilization,1,nil,c:GetCivilization())
end
function Auxiliary.NonEvolutionSummonOperation(e,tp,eg,ep,ev,re,r,rp,c)
	local civ=c:GetCivilization()
	local cost=c:GetManaCost()
	local desc=DM_HINTMSG_TAP
	if civ==DM_CIVILIZATION_LIGHT then desc=DM_HINTMSG_LTAP
	elseif civ==DM_CIVILIZATION_WATER then desc=DM_HINTMSG_WTAP
	elseif civ==DM_CIVILIZATION_DARKNESS then desc=DM_HINTMSG_DTAP
	elseif civ==DM_CIVILIZATION_FIRE then desc=DM_HINTMSG_FTAP
	elseif civ==DM_CIVILIZATION_NATURE then desc=DM_HINTMSG_NTAP end
	local g=Duel.GetMatchingGroup(Auxiliary.PayManaFilter,tp,DM_LOCATION_MANA,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,desc)
	local sg1=g:FilterSelect(tp,Card.IsCivilization,1,1,nil,civ)
	g:Sub(sg1)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TAP)
	local sg2=g:Select(tp,cost-1,cost-1,nil)
	sg2:Merge(sg1)
	Duel.PayManaCost(sg2)
end
--functions that are included on every creature
function Auxiliary.EnableCreatureAttribute(c)
	--summon
	Auxiliary.AddSummonProcedure(c)
	--cannot be battle target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetCondition(Auxiliary.CannotBeBattleTargetCondition)
	e1:SetValue(Auxiliary.CannotBeBattleTargetValue)
	c:RegisterEffect(e1)
	--attack shield
	--not yet implemented: quattro, world, galaxy, infinity, crew, civilization, age, master
	--note: must be updated each time new "breaker" abilities are released
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(DM_EVENT_ATTACK_SHIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCondition(Auxiliary.AttackShieldCondition)
	e2:SetTarget(Auxiliary.AttackShieldTarget)
	e2:SetOperation(Auxiliary.AttackShieldOperation)
	c:RegisterEffect(e2)
end
--cannot be battle target
function Auxiliary.CannotBeBattleTargetCondition(e)
	local c=e:GetHandler()
	return c:IsFaceupUntapped() and not c:IsCanBeUntappedAttacked()
end
function Auxiliary.CannotBeBattleTargetValue(e,c)
	local ab1=c:IsHasEffect(DM_EFFECT_ATTACK_UNTAPPED_LIGHT)
	local ab2=c:IsHasEffect(DM_EFFECT_ATTACK_UNTAPPED_WATER)
	local ab3=c:IsHasEffect(DM_EFFECT_ATTACK_UNTAPPED_DARKNESS)
	local ab4=c:IsHasEffect(DM_EFFECT_ATTACK_UNTAPPED_FIRE)
	local ab5=c:IsHasEffect(DM_EFFECT_ATTACK_UNTAPPED_NATURE)
	local civ=0
	if ab1 then civ=civ+DM_CIVILIZATION_LIGHT end
	if ab2 then civ=civ+DM_CIVILIZATION_WATER end
	if ab3 then civ=civ+DM_CIVILIZATION_DARKNESS end
	if ab4 then civ=civ+DM_CIVILIZATION_FIRE end
	if ab5 then civ=civ+DM_CIVILIZATION_NATURE end
	if civ>0 then
		return not c:IsCanAttackUntapped() and not e:GetHandler():IsCivilization(civ)
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
Auxiliary.break_select_list={
	[1]=DM_DESC_DOUBLE_BREAKER,
	[2]=DM_DESC_TRIPLE_BREAKER,
}
function Auxiliary.AttackShieldOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ChangePosition(c,POS_FACEUP_TAPPED) --fix attack cost position
	--raise event for attacking a player
	Duel.RaiseEvent(c,EVENT_CUSTOM+DM_EVENT_ATTACK_PLAYER,e,0,0,0,0)
	--raise event for "Whenever this creature attacks a player"
	Duel.RaiseSingleEvent(c,EVENT_CUSTOM+DM_EVENT_ATTACK_PLAYER,e,0,0,0,0)
	Duel.BreakShield(e,tp,1-tp,1,1,c)
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

--==========[+EvolutionCreature]==========
--evolution procedure
function Auxiliary.AddEvolutionProcedure(c,f)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(DM_DESC_EVOLUTION)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(DM_EFFECT_SUMMON_PROC)
	e1:SetProperty(DM_EFFECT_FLAG_SUMMON_PARAM+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_UNTAPPED,0)
	e1:SetCondition(Auxiliary.SummonEvolutionCondition(f))
	e1:SetTarget(Auxiliary.SummonEvolutionTarget(f))
	e1:SetOperation(Auxiliary.SummonEvolutionOperation)
	e1:SetValue(DM_SUMMON_TYPE_EVOLUTION)
	c:RegisterEffect(e1)
end
function Auxiliary.EvolutionFilter(c,f)
	return c:IsFaceup() and (not f or f(c))
end
function Auxiliary.SummonEvolutionCondition(f)
	return	function(e,c)
				if c==nil or c:IsCanCastFree() then return true end
				local tp=c:GetControler()
				local g=Duel.GetMatchingGroup(Auxiliary.PayManaFilter,tp,DM_LOCATION_MANA,0,nil)
				if Duel.GetLocationCount(tp,DM_LOCATION_BATTLE)<-1 or g:GetCount()<c:GetManaCost() then return false end
				return Duel.IsExistingMatchingCard(f,tp,DM_LOCATION_BATTLE,0,1,nil)
					and g:IsExists(Card.IsCivilization,1,nil,c:GetCivilization())
			end
end
function Auxiliary.SummonEvolutionTarget(f)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c)
				Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_EVOLVE)
				local g=Duel.SelectMatchingCard(tp,Auxiliary.EvolutionFilter,tp,DM_LOCATION_BATTLE,0,1,1,nil,f)
				local pos=g:GetFirst():GetPosition()
				if g then
					Duel.HintSelection(g)
					g:KeepAlive()
					e:SetLabelObject(g)
					e:SetTargetRange(pos,0)
					return true
				else return false end
			end
end
function Auxiliary.SummonEvolutionOperation(e,tp,eg,ep,ev,re,r,rp,c)
	local civ=c:GetCivilization()
	local cost=c:GetManaCost()
	local desc=DM_HINTMSG_TAP
	if civ==DM_CIVILIZATION_LIGHT then desc=DM_HINTMSG_LTAP
	elseif civ==DM_CIVILIZATION_WATER then desc=DM_HINTMSG_WTAP
	elseif civ==DM_CIVILIZATION_DARKNESS then desc=DM_HINTMSG_DTAP
	elseif civ==DM_CIVILIZATION_FIRE then desc=DM_HINTMSG_FTAP
	elseif civ==DM_CIVILIZATION_NATURE then desc=DM_HINTMSG_NTAP end
	local g1=Duel.GetMatchingGroup(Auxiliary.PayManaFilter,tp,DM_LOCATION_MANA,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,desc)
	local sg1=g1:FilterSelect(tp,Card.IsCivilization,1,1,nil,civ)
	g1:Sub(sg1)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TAP)
	local sg2=g1:Select(tp,cost-1,cost-1,nil)
	sg2:Merge(sg1)
	Duel.PayManaCost(sg2)
	local g2=e:GetLabelObject()
	local sg3=g2:GetFirst():GetStackGroup()
	if sg3:GetCount()~=0 then
		Duel.PutOnTop(c,sg3)
	end
	c:SetMaterial(g2)
	Duel.PutOnTop(c,g2)
	g2:DeleteGroup()
end

--==========[+Spell]==========
--functions that are included on every spell
--desc_id: 0~15 the string id of the script's text
--prop: include DM_EFFECT_FLAG_CARD_CHOOSE for a targeting ("choose") ability
function Auxiliary.EnableSpellAttribute(c)
end
function Auxiliary.AddSpellCastEffect(c,desc_id,targ_func,op_func,prop,cost_func,con_func,cate)
	--cost_func: include dm.CastSpellCost
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	if cate then e1:SetCategory(cate) end
	e1:SetType(DM_EFFECT_TYPE_CAST_SPELL)
	if prop then e1:SetProperty(prop) end
	e1:SetRange(LOCATION_HAND)
	if con_func then e1:SetCondition(con_func) end
	if cost_func then
		e1:SetCost(cost_func)
	else
		e1:SetCost(Auxiliary.CastSpellCost)
	end
	if targ_func then e1:SetTarget(targ_func) end
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	if cate then e2:SetCategory(cate) end
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_CUSTOM+DM_EVENT_BECOME_SHIELD_TRIGGER)
	if prop then e2:SetProperty(prop) end
	if con_func then e2:SetCondition(con_func) end
	if cost_func then e2:SetCost(cost_func) end
	if targ_func then e2:SetTarget(targ_func) end
	e2:SetOperation(op_func)
	c:RegisterEffect(e2)
end
--cost for casting spells
function Auxiliary.CastSpellCost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if c:IsCanCastFree() then return true end
	local cost=c:GetManaCost()
	local g=Duel.GetMatchingGroup(Auxiliary.PayManaFilter,tp,DM_LOCATION_MANA,0,nil)
	if g:GetCount()<cost then return false end
	local civ=c:GetCivilization()
	if chk==0 then return g:IsExists(Card.IsCivilization,1,nil,civ) end
	local desc=DM_HINTMSG_TAP
	if civ==DM_CIVILIZATION_LIGHT then desc=DM_HINTMSG_LTAP
	elseif civ==DM_CIVILIZATION_WATER then desc=DM_HINTMSG_WTAP
	elseif civ==DM_CIVILIZATION_DARKNESS then desc=DM_HINTMSG_DTAP
	elseif civ==DM_CIVILIZATION_FIRE then desc=DM_HINTMSG_FTAP
	elseif civ==DM_CIVILIZATION_NATURE then desc=DM_HINTMSG_NTAP end
	Duel.Hint(HINT_SELECTMSG,tp,desc)
	local sg1=g:FilterSelect(tp,Card.IsCivilization,1,1,nil,civ)
	g:Sub(sg1)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TAP)
	local sg2=g:Select(tp,cost-1,cost-1,nil)
	sg2:Merge(sg1)
	Duel.PayManaCost(sg2)
end

--==========[+KeywordAbilities]==========
--desc_id: 0~15 the string id of the script's text
--prop: include DM_EFFECT_FLAG_CARD_CHOOSE for a targeting ("choose") ability
--a creature applies a specified ability while in the battle zone
--e.g. "Dia Nork, Moonlight Guardian" (DM-01 2/110), "Brawler Zyler" (DM-01 70/110), "Holy Awe" (DM-01 6/110)
function Auxiliary.EnableEffectCustom(c,code,con_func,range,s_range,o_range,targ_func)
	--code: DM_EFFECT_BLOCKER, DM_EFFECT_POWER_ATTACKER, DM_EFFECT_SHIELD_TRIGGER, etc.
	local e1=Effect.CreateEffect(c)
	if s_range or o_range then
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetTargetRange(s_range,o_range)
		if targ_func then e1:SetTarget(targ_func) end
	else
		e1:SetType(EFFECT_TYPE_SINGLE)
	end
	e1:SetCode(code)
	if range then e1:SetRange(range) end
	if con_func then e1:SetCondition(con_func) end
	c:RegisterEffect(e1)
end
--a creature gets a specified ability
--e.g. "Chaos Strike" (DM-01 72/110), "Diamond Cutter" (DM-02 1/55), "Rumble Gate" (DM-02 44/55)
function Auxiliary.GainEffectCustom(c,tc,desc_id,code,reset_flag,reset_count)
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
--e.g. "Dia Nork, Moonlight Guardian" (DM-01 2/110), "Lurking Eel" (DM-05 18/55)
function Auxiliary.EnableBlocker(c,con_func,desc)
	--con_func: include dm.CivilizationBlockerCondition for "CIVILIZATION blocker"
	--desc: DM_DESC_FIRE_NATURE_BLOCKER for "Fire and nature blocker", etc.
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
	e1:SetCondition(aux.AND(Auxiliary.BlockerCondition,con_func))
	e1:SetTarget(Auxiliary.BlockerTarget)
	e1:SetOperation(Auxiliary.BlockerOperation)
	c:RegisterEffect(e1)
	Auxiliary.EnableEffectCustom(c,DM_EFFECT_BLOCKER,con_func)
end
function Auxiliary.BlockerCondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():GetControler()~=tp and Duel.IsPlayerCanBlock(tp)
end
function Auxiliary.BlockerTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBlock() end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function Auxiliary.BlockerOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsFaceupUntapped() then return end
	local a=Duel.GetAttacker()
	if not a --[[or not a:IsAttackable()]] or a:IsImmuneToEffect(e) --[[or a:IsStatus(STATUS_ATTACK_CANCELED)]] then return end
	Duel.ChangePosition(c,POS_FACEUP_TAPPED)
	if not Duel.ChangeAttackTarget(c) then return end
	--register flag effect for Card.IsBlocked
	a:RegisterFlagEffect(DM_EFFECT_BLOCKED,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	Duel.Hint(HINT_OPSELECTED,1-tp,DM_DESC_BLOCKED)
	--raise event for "Whenever this creature blocks"
	Duel.RaiseSingleEvent(c,EVENT_CUSTOM+DM_EVENT_BLOCK,e,0,0,0,0)
	--raise event for "Whenever this creature becomes blocked"
	Duel.RaiseSingleEvent(a,EVENT_CUSTOM+DM_EVENT_BECOMES_BLOCKED,e,0,0,0,0)
	--raise event for "Whenever any of your creatures becomes blocked"
	Duel.RaiseEvent(a,EVENT_CUSTOM+DM_EVENT_BECOMES_BLOCKED,e,0,0,0,0)
end
function Auxiliary.CivilizationBlockerCondition(civ)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				return Duel.GetAttacker():GetControler()~=tp and Duel.GetAttacker():IsCivilization(civ)
			end
end
Auxiliary.civblcon=Auxiliary.CivilizationBlockerCondition
--a creature gets "Blocker"
--e.g. "Full Defensor" (DM-04 9/55)
function Auxiliary.GainEffectBlocker(c,tc,desc_id,reset_flag,reset_count)
	local reset_flag=reset_flag or RESET_PHASE+PHASE_END
	local reset_count=reset_count or 1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(DM_DESC_BLOCKER)
	e1:SetCategory(DM_CATEGORY_BLOCKER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetCondition(Auxiliary.BlockerCondition)
	e1:SetTarget(Auxiliary.BlockerTarget)
	e1:SetOperation(Auxiliary.BlockerOperation)
	if tc==c then
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+reset_flag,reset_count)
	else
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+reset_flag,reset_count)
	end
	tc:RegisterEffect(e1)
	Auxiliary.GainEffectCustom(c,tc,desc_id,DM_EFFECT_BLOCKER,reset_flag,reset_count)
end
--"Shield trigger (When this spell is put into your hand from your shield zone, you may cast it immediately for no cost.)"
--"Shield trigger (When this creature is put into your hand from your shield zone, you may summon it immediately for no cost.)"
--e.g. "Holy Awe" (DM-01 6/110), "Amber Grass" (DM-04 7/55)
function Auxiliary.EnableShieldTrigger(c,con_func)
	local con_func=con_func or aux.TRUE
	Auxiliary.EnableEffectCustom(c,DM_EFFECT_SHIELD_TRIGGER,con_func)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(DM_DESC_SHIELD_TRIGGER_CREATURE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(aux.AND(Auxiliary.ShieldTriggerSummonCondition,con_func))
	e1:SetTarget(Auxiliary.ShieldTriggerSummonTarget)
	e1:SetOperation(Auxiliary.ShieldTriggerSummonOperation)
	c:RegisterEffect(e1)
end
function Auxiliary.ShieldTriggerCondition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(DM_LOCATION_SHIELD) and c:IsReason(DM_REASON_BREAK)
end
function Auxiliary.ShieldTriggerSummonCondition(e,tp,eg,ep,ev,re,r,rp)
	return Auxiliary.ShieldTriggerCondition(e,tp,eg,ep,ev,re,r,rp) and e:GetHandler():IsCreature()
end
function Auxiliary.ShieldTriggerSummonTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBePutIntoBattleZone(e,0,tp,false,false) end
end
function Auxiliary.ShieldTriggerSummonOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.PutIntoBattleZone(c,0,tp,tp,false,false,POS_FACEUP_UNTAPPED)
end
function Auxiliary.AddShieldTriggerCastEffect(c,desc_id,targ_func,op_func,prop,cost_func,con_func,cate)
	local con_func=con_func or aux.TRUE
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	if cate then e1:SetCategory(cate) end
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	if prop then
		e1:SetProperty(EFFECT_FLAG_DELAY+prop)
	else
		e1:SetProperty(EFFECT_FLAG_DELAY)
	end
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(aux.AND(Auxiliary.ShieldTriggerCondition,con_func))
	if cost_func then e1:SetCost(cost_func) end
	if targ_func then e1:SetTarget(targ_func) end
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetOperation(Auxiliary.ShieldTriggerOperation)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAIN_END)
	if prop then
		e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+prop)
	else
		e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	end
	e3:SetCondition(aux.AND(Auxiliary.ShieldTriggerCondition2,con_func))
	c:RegisterEffect(e3)
	e2:SetLabelObject(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	if cate then e4:SetCategory(cate) end
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_CUSTOM+DM_EVENT_BECOME_SHIELD_TRIGGER)
	if prop then
		e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+prop)
	else
		e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	end
	e4:SetCondition(aux.AND(Auxiliary.ShieldTriggerCondition,con_func))
	if cost_func then e4:SetCost(cost_func) end
	if targ_func then e4:SetTarget(targ_func) end
	e4:SetOperation(op_func)
	c:RegisterEffect(e4)
end
function Auxiliary.ShieldTriggerOperation(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not rc:IsHasEffect(DM_EFFECT_SHIELD_TRIGGER) and not rc:IsBrokenShield() and not rc:IsControler(tp) then return end
	e:GetLabelObject():SetLabel(1)
end
function Auxiliary.ShieldTriggerCondition2(e,tp,eg,ep,ev,re,r,rp)
	return Auxiliary.ShieldTriggerCondition(e,tp,eg,ep,ev,re,r,rp) and e:GetLabel()==1
end
--"Power attacker +N000 (While attacking, this creature gets +N000 power.)"
--e.g. "Brawler Zyler" (DM-01 70/110)
function Auxiliary.EnablePowerAttacker(c,val,con_func)
	local con_func=con_func or aux.TRUE
	Auxiliary.EnableUpdatePower(c,val,aux.AND(Auxiliary.SelfAttackerCondition,con_func))
	Auxiliary.EnableEffectCustom(c,DM_EFFECT_POWER_ATTACKER,con_func)
end
--a creature gets "Power attacker +N000"
--e.g. "Burning Power" (DM-01 71/110)
function Auxiliary.GainEffectPowerAttacker(c,tc,desc_id,val,reset_flag,reset_count)
	local reset_flag=reset_flag or RESET_PHASE+PHASE_END
	local reset_count=reset_count or 1
	Auxiliary.GainEffectUpdatePower(c,tc,desc_id,val,reset_flag,reset_count,Auxiliary.SelfAttackerCondition)
	Auxiliary.GainEffectCustom(c,tc,desc_id,DM_EFFECT_POWER_ATTACKER,reset_flag,reset_count)
end
--"Slayer (Whenever this creature battles, destroy the other creature after the battle.)"
--"CIVILIZATION1 and CIVILIZATION2 slayer (Whenever this creature battles a CIVILIZATION1 or CIVILIZATION2 creature, destroy the other creature after the battle.)"
--e.g. "Bone Assassin, the Ripper" (DM-01 47/110), "Gigakail" (DM-05 26/55)
function Auxiliary.EnableSlayer(c,con_func,targ_func,desc)
	--targ_func: include dm.CivilizationSlayerTarget for "CIVILIZATION slayer"
	--desc: DM_DESC_NATURE_LIGHT_SLAYER for "Nature and light slayer", etc.
	local con_func=con_func or aux.TRUE
	local e1=Effect.CreateEffect(c)
	if desc then
		e1:SetDescription(desc)
	else
		e1:SetDescription(DM_DESC_SLAYER)
	end
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(DM_EVENT_ATTACK_END)
	e1:SetCondition(aux.AND(Auxiliary.SlayerCondition,con_func))
	if targ_func then
		e1:SetTarget(targ_func)
	else
		e1:SetTarget(Auxiliary.HintTarget)
	end
	e1:SetOperation(Auxiliary.SlayerOperation)
	c:RegisterEffect(e1)
	Auxiliary.EnableEffectCustom(c,DM_EFFECT_SLAYER,con_func)
end
function Auxiliary.SlayerCondition(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	e:SetLabelObject(tc)
	return tc and tc:IsRelateToBattle()
end
function Auxiliary.SlayerOperation(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc:IsRelateToBattle() then return end
	Duel.Destroy(tc,REASON_EFFECT)
end
function Auxiliary.CivilizationSlayerTarget(civ)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				local tc=e:GetHandler():GetBattleTarget()
				if chk==0 then return tc and tc:IsCivilization(civ) and tc:IsRelateToBattle() end
				Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
			end
end
Auxiliary.civsltg=Auxiliary.CivilizationSlayerTarget
--a creature gets "Slayer"
--e.g. "Creeping Plague" (DM-01 49/110)
function Auxiliary.GainEffectSlayer(c,tc,desc_id,reset_flag,reset_count)
	local reset_flag=reset_flag or RESET_PHASE+PHASE_END
	local reset_count=reset_count or 1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(DM_DESC_SLAYER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(DM_EVENT_ATTACK_END)
	e1:SetCondition(Auxiliary.SlayerCondition)
	e1:SetTarget(Auxiliary.HintTarget)
	e1:SetOperation(Auxiliary.SlayerOperation)
	if tc==c then
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE-DM_RESET_TOGRAVE-RESET_LEAVE+reset_flag,reset_count)
	else
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-DM_RESET_TOGRAVE-RESET_LEAVE+reset_flag,reset_count)
	end
	tc:RegisterEffect(e1)
	Auxiliary.GainEffectCustom(c,tc,desc_id,DM_EFFECT_SLAYER,-DM_RESET_TOGRAVE-RESET_LEAVE+reset_flag,reset_count)
end
--"Breaker (This creature breaks N shields.)"
--"Each creature in the battle zone has "Breaker""
--e.g. "Gigaberos" (DM-01 55/110), "Chaotic Skyterror" (DM-04 41/55)
function Auxiliary.EnableBreaker(c,code,con_func,range,s_range,o_range,targ_func)
	--code: DM_EFFECT_DOUBLE_BREAKER, DM_EFFECT_TRIPLE_BREAKER, DM_EFFECT_QUATTRO_BREAKER, etc.
	local con_func=con_func or aux.TRUE
	Auxiliary.EnableEffectCustom(c,DM_EFFECT_BREAKER,con_func,range,s_range,o_range,targ_func)
	Auxiliary.EnableEffectCustom(c,code,con_func,range,s_range,o_range,targ_func)
end
--a creature gets "Breaker"
--e.g. "Magma Gazer" (DM-01 81/110)
function Auxiliary.GainEffectBreaker(c,tc,desc_id,code,reset_flag,reset_count)
	local reset_flag=reset_flag or RESET_PHASE+PHASE_END
	local reset_count=reset_count or 1
	Auxiliary.GainEffectCustom(c,tc,desc_id,DM_EFFECT_BREAKER,reset_flag,reset_count)
	Auxiliary.GainEffectCustom(c,tc,desc_id,code,reset_flag,reset_count)
end
--"Instead of having this creature attack, you may tap it to use its Tap ability."
--e.g. "Tank Mutant" (DM-06 6/110)
function Auxiliary.EnableTapAbility(c,desc_id,targ_func,op_func,prop,cate)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	if cate then e1:SetCategory(cate) end
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	if prop then e1:SetProperty(prop) end
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetHintTiming(DM_TIMING_TAP_ABILITY,0)
	e1:SetCondition(Auxiliary.TapAbilityCondition)
	e1:SetCost(Auxiliary.SelfTapCost)
	if targ_func then e1:SetTarget(targ_func) end
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
end
function Auxiliary.TapAbilityCondition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Auxiliary.BattlePhaseCondition() and Duel.GetAttacker()==nil and Duel.GetCurrentChain()==0
		and c:GetAttackAnnouncedCount()==0 and c:IsAttackable()
end
--"RACE Hunter (This creature wins all battles against RACE.)"
--e.g. "Pearl Carras, Barrier Guardian" (Game Original)
function Auxiliary.EnableWinsAllBattles(c,desc_id,con_func,f)
	--f: include filter for "RACE Hunter"
	local con_func=con_func or aux.TRUE
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetCondition(aux.AND(Auxiliary.WinsAllBattlesCondition(f),con_func))
	e1:SetOperation(Auxiliary.WinsAllBattlesOperation)
	c:RegisterEffect(e1)
	Auxiliary.EnableEffectCustom(c,DM_EFFECT_WINS_ALL_BATTLES,con_func)
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
	else Duel.Destroy(tc,REASON_EFFECT+REASON_BATTLE) end
end

--==========[+Abilities]==========
--desc_id: 0~15 the string id of the script's text
--optional: true for optional ("you may") abilities
--forced: true for forced abilities
--prop: include DM_EFFECT_FLAG_CARD_CHOOSE for a targeting ("choose") ability
--"When this creature would be destroyed, ABILITY."
--e.g. "Chilias, the Oracle" (DM-01 1/110)
function Auxiliary.AddSingleDestroyReplaceEffect(c,desc_id,targ_func,op_func,con_func,prop)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	if prop then
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+prop)
	else
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	end
	e1:SetRange(DM_LOCATION_BATTLE)
	if con_func then e1:SetCondition(con_func) end
	e1:SetTarget(targ_func)
	if op_func then e1:SetOperation(op_func) end
	c:RegisterEffect(e1)
end
function Auxiliary.SingleDestroyReplaceTarget(f,...)
	--f: Card.IsAbleToX
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				local c=e:GetHandler()
				if chk==0 then return not c:IsReason(REASON_REPLACE) and (not f or f(c,table.unpack(funs))) end
				return true
			end
end
--"Return it to your hand instead"
--e.g. "Chilias, the Oracle" (DM-01 1/110)
function Auxiliary.SelftoHandDestroyReplaceOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,c:GetOriginalCode())
	Duel.SendtoHand(c,PLAYER_OWNER,REASON_EFFECT+REASON_REPLACE)
end
--"Put it into your mana zone instead"
--e.g. "Coiling Vines" (DM-01 92/110)
function Auxiliary.SelftoManaDestroyReplaceOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,c:GetOriginalCode())
	Duel.SendtoMana(c,POS_FACEUP_UNTAPPED,REASON_EFFECT+REASON_REPLACE)
end
--"Add it to your shields face down instead"
--e.g. "Aless, the Oracle" (DM-03 2/55)
function Auxiliary.SelftoShieldDestroyReplaceOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,c:GetOriginalCode())
	Duel.SendtoShield(c,tp)
end
--"When one of your creatures would be destroyed, ABILITY."
--e.g. "King Ambergris" (Game Original)
function Auxiliary.AddDestroyReplaceEffect(c,desc_id,targ_func,op_func,val,con_func)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(DM_LOCATION_BATTLE)
	if con_func then e1:SetCondition(con_func) end
	e1:SetTarget(targ_func)
	e1:SetValue(val)
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
end
--"At the end of the turn, ABILITY."
--e.g. "Frei, Vizier of Air" (DM-01 4/110)
function Auxiliary.AddTurnEndEffect(c,desc_id,optional,targ_func,op_func,prop,con_func,lmct,lmcd,cost_func,range,cate)
	local typ=EFFECT_TYPE_TRIGGER_F
	if optional then typ=EFFECT_TYPE_TRIGGER_O end
	local range=range or DM_LOCATION_BATTLE
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	if cate then e1:SetCategory(cate) end
	e1:SetType(EFFECT_TYPE_FIELD+typ)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	if prop then e1:SetProperty(prop) end
	e1:SetRange(range)
	if lmct then e1:SetCountLimit(lmct,lmcd) end
	if con_func then e1:SetCondition(con_func) end
	if cost_func then e1:SetCost(cost_func) end
	if targ_func then e1:SetTarget(targ_func) end
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
end
--"When you put this creature into the battle zone, ABILITY."
--e.g. "Miele, Vizier of Lightning" (DM-01 13/110)
function Auxiliary.AddSingleComeIntoPlayEffect(c,desc_id,optional,targ_func,op_func,prop,con_func,cost_func,cate)
	local typ=EFFECT_TYPE_TRIGGER_F
	if optional then typ=EFFECT_TYPE_TRIGGER_O end
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
function Auxiliary.AddComeIntoPlayEffect(c,desc_id,optional,targ_func,op_func,prop,con_func,cost_func,range,cate)
	local typ=EFFECT_TYPE_TRIGGER_F
	if optional then typ=EFFECT_TYPE_TRIGGER_O end
	local range=range or DM_LOCATION_BATTLE
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
	e1:SetRange(range)
	if con_func then e1:SetCondition(con_func) end
	if cost_func then e1:SetCost(cost_func) end
	if targ_func then e1:SetTarget(targ_func) end
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
end
--"Whenever this creature attacks, ABILITY."
--e.g. "Laguna, Lightning Enforcer" (DM-02 4/55)
function Auxiliary.AddSingleAttackTriggerEffect(c,desc_id,optional,targ_func,op_func,prop,con_func,cost_func,cate)
	local typ=EFFECT_TYPE_TRIGGER_F
	if optional then typ=EFFECT_TYPE_TRIGGER_O end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	if cate then e1:SetCategory(cate) end
	e1:SetType(EFFECT_TYPE_SINGLE+typ)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	if prop then
		e1:SetProperty(DM_EFFECT_FLAG_ATTACK_TRIGGER+prop)
	else
		e1:SetProperty(DM_EFFECT_FLAG_ATTACK_TRIGGER)
	end
	if con_func then e1:SetCondition(con_func) end
	if cost_func then e1:SetCost(cost_func) end
	if targ_func then e1:SetTarget(targ_func) end
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
end
--"Whenever this creature blocks, ABILITY."
--e.g. "Spiral Grass" (DM-02 10/55)
function Auxiliary.AddSingleBlockEffect(c,desc_id,optional,targ_func,op_func,prop,con_func,cost_func,cate)
	local typ=EFFECT_TYPE_TRIGGER_F
	if optional then typ=EFFECT_TYPE_TRIGGER_O end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	if cate then e1:SetCategory(cate) end
	e1:SetType(EFFECT_TYPE_SINGLE+typ)
	e1:SetCode(EVENT_CUSTOM+DM_EVENT_BLOCK)
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
--"When this creature is destroyed, ABILITY."
--e.g. "Bombersaur" (DM-02 36/55)
function Auxiliary.AddSingleDestroyedEffect(c,desc_id,optional,targ_func,op_func,prop,con_func,cost_func,cate)
	local typ=EFFECT_TYPE_TRIGGER_F
	if optional then typ=EFFECT_TYPE_TRIGGER_O end
	local con_func=con_func or aux.TRUE
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
	e1:SetCondition(Auxiliary.PreviousLocationCondition(DM_LOCATION_BATTLE),con_func)
	if cost_func then e1:SetCost(cost_func) end
	if targ_func then e1:SetTarget(targ_func) end
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
end
--"Whenever another creature is destroyed, ABILITY."
--e.g. "Mongrel Man" (DM-04 33/55)
function Auxiliary.AddDestroyedEffect(c,desc_id,optional,targ_func,op_func,prop,con_func,cost_func,range,cate)
	local typ=EFFECT_TYPE_TRIGGER_F
	if optional then typ=EFFECT_TYPE_TRIGGER_O end
	local range=range or DM_LOCATION_BATTLE
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
	e1:SetRange(range)
	if con_func then e1:SetCondition(con_func) end
	if cost_func then e1:SetCost(cost_func) end
	if targ_func then e1:SetTarget(targ_func) end
	e1:SetOperation(op_func)
	c:RegisterEffect(e1)
end
--"Whenever a player casts a spell, ABILITY."
--e.g. "Natalia, Channeler of Suns" (Game Original)
function Auxiliary.AddPlayerCastSpellEffect(c,desc_id,p,optional,targ_func,op_func,con_func,prop,cate)
	--p: PLAYER_PLAYER/tp if you cast a spell, PLAYER_OPPONENT/1-tp if your opponent does, or nil if either player does
	local typ=EFFECT_TYPE_TRIGGER_F
	if optional then typ=EFFECT_TYPE_TRIGGER_O end
	local con_func=con_func or aux.TRUE
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetOperation(Auxiliary.EventChainingOperation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(DM_LOCATION_BATTLE)
	e2:SetOperation(Auxiliary.EventChainSolvedOperation(p))
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	if cate then e3:SetCategory(cate) end
	e3:SetType(EFFECT_TYPE_FIELD+typ)
	e3:SetCode(EVENT_CHAIN_END)
	if prop then
		e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+prop)
	else
		e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	end
	e3:SetRange(DM_LOCATION_BATTLE)
	e3:SetCondition(aux.AND(Auxiliary.EventChainEndCondition,con_func))
	if targ_func then e3:SetTarget(targ_func) end
	e3:SetOperation(op_func)
	c:RegisterEffect(e3)
	e1:SetLabelObject(e3)
	e2:SetLabelObject(e3)
end
function Auxiliary.EventChainingOperation(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(0)
end
function Auxiliary.EventChainSolvedOperation(p)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local reason_player=nil
				if p==PLAYER_PLAYER or p==tp then reason_player=tp
				elseif p==PLAYER_OPPONENT or p==1-tp then reason_player=1-tp end
				if reason_player and rp~=reason_player or not re:GetHandler():IsSpell() then return end
				e:GetLabelObject():SetLabel(1)
			end
end
function Auxiliary.EventChainEndCondition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()==1
end
--"When this creature leaves the battle zone, ABILITY."
--e.g. "Altimeth, Holy Divine Dragon" (Game Original)
function Auxiliary.AddSingleLeavePlayEffect(c,desc_id,optional,targ_func,op_func,prop,con_func,cost_func,cate)
	local typ=EFFECT_TYPE_TRIGGER_F
	if optional then typ=EFFECT_TYPE_TRIGGER_O end
	local con_func=con_func or aux.TRUE
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
	local typ=EFFECT_TYPE_TRIGGER_F
	if optional then typ=EFFECT_TYPE_TRIGGER_O end
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
--"This creature can't attack players."
--e.g. "Dia Nork, Moonlight Guardian" (DM-01 2/110)
function Auxiliary.EnableCannotAttackPlayer(c,con_func)
	local con_func=con_func or aux.TRUE
	Auxiliary.EnableEffectCustom(c,DM_EFFECT_CANNOT_ATTACK_PLAYER,con_func)
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
--a creature gets "+/-N000 power"
--e.g. "Rumble Gate" (DM-02 44/55)
function Auxiliary.GainEffectUpdatePower(c,tc,desc_id,val,reset_flag,reset_count,con_func)
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
	local typ=EFFECT_TYPE_TRIGGER_O
	if forced then typ=EFFECT_TYPE_TRIGGER_F end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	e1:SetType(EFFECT_TYPE_FIELD+typ)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(DM_LOCATION_BATTLE)
	if con_func then
		e1:SetCondition(aux.AND(Auxiliary.TurnPlayerCondition(PLAYER_PLAYER),con_func))
	else
		e1:SetCondition(Auxiliary.TurnPlayerCondition(PLAYER_PLAYER))
	end
	if typ==EFFECT_TYPE_TRIGGER_O then
		e1:SetTarget(Auxiliary.SelfTapUntapTarget(POS_FACEUP_UNTAPPED))
	end
	e1:SetOperation(Auxiliary.SelfTapUntapOperation(POS_FACEUP_UNTAPPED))
	c:RegisterEffect(e1)
end
--pos: POS_FACEUP_TAPPED for "tap this creature" or POS_FACEUP_UNTAPPED for "untap this creature"
function Auxiliary.SelfTapUntapTarget(pos)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				local c=e:GetHandler()
				local b=c:IsFaceupUntapped()
				if pos==POS_FACEUP_UNTAPPED then b=c:IsFaceupTapped() end
				if chk==0 then return b end
			end
end
function Auxiliary.SelfTapUntapOperation(pos)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
				Duel.ChangePosition(c,pos)
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
function Auxiliary.CannotBeBlockedValue(f)
	return	function(e,re,tp)
				return re:IsHasCategory(DM_CATEGORY_BLOCKER) and not re:GetHandler():IsImmuneToEffect(e)
					and (not f or f(e,re,tp))
			end
end
--filter for "This creature can't be blocked by creatures that have power N000 or less."
--e.g. "Stampeding Longhorn" (DM-01 104/110)
function Auxiliary.CannotBeBlockedPowerBelowValue(pwr)
	return	function(e,re,tp)
				return re:GetHandler():IsPowerBelow(pwr)
			end
end
--filter for "This creature can't be blocked by creatures that have power N000 or more."
--e.g. "Calgo, Vizier of Rainclouds" (DM-05 7/55)
function Auxiliary.CannotBeBlockedPowerAboveValue(pwr)
	return	function(e,re,tp)
				return re:GetHandler():IsPowerAbove(pwr)
			end
end
--filter for "This creature can't be blocked by CIVILIZATION creatures."
--e.g. "Gulan Rias, Speed Guardian" (DM-04 10/55)
function Auxiliary.CannotBeBlockedCivValue(civ)
	return	function(e,re,tp)
				return re:GetHandler():IsCivilization(civ)
			end
end
--a creature gets "This creature can't be blocked."
--e.g. "Laser Wing" (DM-01 11/110)
function Auxiliary.GainEffectCannotBeBlocked(c,tc,desc_id,con_func,reset_flag,reset_count)
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
	e1:SetValue(Auxiliary.CannotBeBlockedValue())
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
--e.g. "Hunter Fish" (DM-01 31/110)
function Auxiliary.EnableCannotAttack(c,con_func)
	local con_func=con_func or aux.TRUE
	Auxiliary.EnableEffectCustom(c,EFFECT_CANNOT_ATTACK,aux.AND(Auxiliary.CannotAttackCondition,con_func))
end
function Auxiliary.CannotAttackCondition(e)
	return not e:GetHandler():IsHasEffect(DM_EFFECT_IGNORE_CANNOT_ATTACK)
end
--"When this creature wins a battle, destroy it."
--"When this creature wins a battle, it is destroyed at random."
--e.g. "Bloody Squito" (DM-01 46/110), "Hanakage, Shadow of Transience" (Game Original)
function Auxiliary.EnableBattleWinSelfDestroy(c,desc_id,ram)
	local desc_id=desc_id or 0
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(Auxiliary.SelfBattleWinCondition)
	e1:SetOperation(Auxiliary.SelfDestroyOperation(ram))
	c:RegisterEffect(e1)
end
function Auxiliary.SelfDestroyOperation(ram)
	--ram: true for "destroyed at random"
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				Duel.ChangePosition(c,POS_FACEUP_TAPPED) --fix attack cost position
				if not c:IsRelateToEffect(e) then return end
				local ct=math.random(4) --either 2 or 3: 50% chance to destroy
				if ram and ct~=2 then return end
				Duel.Destroy(c,REASON_EFFECT)
			end
end
--"This creature attacks each turn if able."
--e.g. "Deadly Fighter Braid Claw" (DM-01 74/110)
function Auxiliary.EnableAttackIfAble(c,con_func)
	local con_func=con_func or aux.TRUE
	Auxiliary.EnableEffectCustom(c,EFFECT_MUST_ATTACK,con_func)
end
--"This creature can attack untapped creatures."
--"This creature can attack untapped CIVILIZATION creatures."
--"This creature can attack untapped CIVILIZATION1 or CIVILIZATION2 creatures."
--e.g. "Gatling Skyterror" (DM-01 79/110), "Aeris, Flight Elemental" (DM-04 6/55), "Storm Javelin Wyvern" (Game Original)
function Auxiliary.EnableAttackUntapped(c,code1,code2,con_func)
	--code1,code2: DM_EFFECT_ATTACK_UNTAPPED_X
	local code1=code1 or DM_EFFECT_ATTACK_UNTAPPED
	local con_func=con_func or aux.TRUE
	Auxiliary.EnableEffectCustom(c,code1,con_func)
	if not code2 then return end
	Auxiliary.EnableEffectCustom(c,code2,con_func)
end
--"A player's creatures/spells each cost N more/less to summon/cast. [They can't cost less than 1.]"
--"Each creature costs N more/less to summon and each spell costs N more/less to cast. [They can't cost less than 1.]"
--e.g. "Elf-X" (DM-02 46/55), "Milieus, the Daystretcher" (DM-04 12/55)
function Auxiliary.EnableUpdateManaCost(c,s_range,o_range,con_func1,targ_func1,val,con_func2,targ_func2)
	--s_range,o_range: LOCATION_HAND (mostly)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(DM_EFFECT_UPDATE_MANA_COST)
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetTargetRange(s_range,o_range)
	if con_func1 then e1:SetCondition(con_func1) end
	if targ_func1 then e1:SetTarget(targ_func1) end
	e1:SetValue(val)
	c:RegisterEffect(e1)
	if not con_func2 and not targ_func2 then return end
	local e2=e1:Clone()
	e2:SetCondition(con_func2)
	e2:SetTarget(targ_func2)
	c:RegisterEffect(e2)
end
--"This creature can't attack creatures."
--e.g. "Dawn Giant" (DM-03 46/55)
function Auxiliary.EnableCannotAttackCreature(c,con_func)
	local con_func=con_func or aux.TRUE
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetCondition(con_func)
	e1:SetValue(Auxiliary.CannotAttackCreatureValue)
	c:RegisterEffect(e1)
	Auxiliary.EnableEffectCustom(c,DM_EFFECT_CANNOT_ATTACK_CREATURE,con_func)
end
function Auxiliary.CannotAttackCreatureValue(e,c)
	return c:IsCreature()
end
--"This creature can't be attacked"
--e.g. "Gulan Rias, Speed Guardian" (DM-04 10/55)
function Auxiliary.EnableCannotBeAttacked(c,f,con_func)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(DM_LOCATION_BATTLE)
	if con_func then e1:SetCondition(con_func) end
	e1:SetValue(Auxiliary.CannotBeAttackedValue(f))
	c:RegisterEffect(e1)
end
function Auxiliary.CannotBeAttackedValue(f)
	return	function(e,c)
				return not c:IsImmuneToEffect(e) and (not f or f(e,c))
			end
end
--filter for "This creature can't be attacked by CIVILIZATION creatures"
--e.g. "Gulan Rias, Speed Guardian" (DM-04 10/55)
function Auxiliary.CannotBeAttackedCivValue(civ)
	return	function(e,c)
				return c:IsCivilization(civ)
			end
end
--"At the end of your turn, [you may] return this creature to your hand."
--e.g. "Ganzo, Flame Fisherman" (Game Original)
function Auxiliary.EnableTurnEndSelfReturn(c,desc_id,con_func,optional)
	local desc_id=desc_id or 0
	local typ=EFFECT_TYPE_TRIGGER_F
	if optional then typ=EFFECT_TYPE_TRIGGER_O end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),desc_id))
	e1:SetType(EFFECT_TYPE_FIELD+typ)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(DM_LOCATION_BATTLE)
	if con_func then
		e1:SetCondition(aux.AND(Auxiliary.TurnPlayerCondition(PLAYER_PLAYER),con_func))
	else
		e1:SetCondition(Auxiliary.TurnPlayerCondition(PLAYER_PLAYER))
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
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.SendtoHand(c,PLAYER_OWNER,REASON_EFFECT)
end
--========== Break ==========
--operation function for abilities that break shields
function Auxiliary.BreakOperation(sp,tgp,min,max,rc)
	--sp: the player that selects the shields
	--tgp: the player whose shields to break
	--min,max: the number of shields to break
	--rc: the creature that breaks the shields
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local sel_player=nil
				local target_player=nil
				if sp==PLAYER_PLAYER or sp==tp then sel_player=tp
				elseif sp==PLAYER_OPPONENT or sp==1-tp then sel_player=1-tp end
				if tgp==PLAYER_PLAYER or tgp==tp then target_player=tp
				elseif tgp==PLAYER_OPPONENT or tgp==1-tp then target_player=1-tp end
				if e:IsHasType(EFFECT_TYPE_CONTINUOUS) then Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode()) end
				Duel.BreakShield(e,sel_player,target_player,min,max,rc,REASON_EFFECT)
			end
end
--========== Confirm ==========
--operation function for abilities that let a player to look at cards that are not public knowledge
function Auxiliary.ConfirmOperation(p,f,s,o,min,max,ex,...)
	--f: include Card.IsFacedown for DM_LOCATION_SHIELD, not Card.IsPublic for LOCATION_HAND
	--p,min,max: nil to look at all cards
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local player=nil
				if p==PLAYER_PLAYER or p==tp then player=tp
				elseif p==PLAYER_OPPONENT or p==1-tp then player=1-tp end
				local max=max or min
				if e:IsHasType(EFFECT_TYPE_CONTINUOUS) then Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode()) end
				local g=Duel.GetMatchingGroup(f,tp,s,o,ex,table.unpack(funs))
				if g:GetCount()==0 then return end
				if min and max then
					Duel.Hint(HINT_SELECTMSG,player,DM_HINTMSG_CONFIRM)
					local sg=g:Select(player,min,max,ex,table.unpack(funs))
					if s==DM_LOCATION_SHIELD or o==DM_LOCATION_SHIELD then Duel.HintSelection(sg) end
					Duel.ConfirmCards(player,sg)
				else
					Duel.ConfirmCards(player,g)
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
				local player=nil
				if p==PLAYER_PLAYER or p==tp then player=tp
				elseif p==PLAYER_OPPONENT or p==1-tp then player=1-tp end
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
					if s==DM_LOCATION_BATTLE or o==DM_LOCATION_BATTLE then Duel.HintSelection(sg) end
					Duel.Destroy(sg,REASON_EFFECT)
				else
					Duel.Destroy(g,REASON_EFFECT)
				end
			end
end
--operation function for abilities that choose cards to destroy
function Auxiliary.ChooseDestroyOperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not g then return end
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(sg,REASON_EFFECT)
end
--========== Discard ==========
--operation function for abilities that discard cards
function Auxiliary.DiscardOperation(p,f,s,o,min,max,ram,ex,...)
	--p,min,max: nil to discard all cards
	--ram: true to discard cards at random
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local player=nil
				if p==PLAYER_PLAYER or p==tp then player=tp
				elseif p==PLAYER_OPPONENT or p==1-tp then player=1-tp end
				local max=max or min
				local c=e:GetHandler()
				if c:IsSpell() and c:IsLocation(LOCATION_HAND) and (s==LOCATION_HAND or o==LOCATION_HAND) then ex=c end
				if e:IsHasType(EFFECT_TYPE_CONTINUOUS) then Duel.Hint(HINT_CARD,0,c:GetOriginalCode()) end
				local g=Duel.GetMatchingGroup(f,tp,s,o,ex,table.unpack(funs))
				if min and max then
					if ram then
						Duel.RandomDiscardHand(player,min,REASON_EFFECT,ex)
					else
						Duel.DiscardHand(player,f,min,max,REASON_EFFECT,ex,table.unpack(funs))
					end
				else
					Duel.SendtoDMGrave(g,REASON_EFFECT+REASON_DISCARD)
				end
			end
end
--operation function for abilities that choose cards to discard
function Auxiliary.ChooseDiscardOperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not g then return end
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoDMGrave(sg,REASON_EFFECT+REASON_DISCARD)
end
--========== Draw ==========
--target and operation functions for abilities that draw a specified number of cards
function Auxiliary.DrawTarget(p)
	--p: PLAYER_PLAYER/tp for you to draw or PLAYER_OPPONENT/1-tp for your opponent to draw
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				local player=nil
				if p==PLAYER_PLAYER or p==tp then player=tp
				elseif p==PLAYER_OPPONENT or p==1-tp then player=1-tp end
				if chk==0 then return Duel.IsPlayerCanDraw(player,1) end
			end
end
function Auxiliary.DrawOperation(p,ct)
	--ct: the number of cards to draw
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local player=nil
				if p==PLAYER_PLAYER or p==tp then player=tp
				elseif p==PLAYER_OPPONENT or p==1-tp then player=1-tp end
				Duel.Draw(player,ct,REASON_EFFECT)
			end
end
--operation function for abilities that draw an unspecified number of cards
--use Auxiliary.DrawTarget for the target function
function Auxiliary.DrawUpToOperation(p,ct)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local player=nil
				if p==PLAYER_PLAYER or p==tp then player=tp
				elseif p==PLAYER_OPPONENT or p==1-tp then player=1-tp end
				Duel.DrawUpTo(player,ct,REASON_EFFECT)
			end
end
--========== PutIntoBattle ==========
--target and operation functions for abilities that put creatures into the battle zone
function Auxiliary.PutIntoBattleFilter(c,e,tp,f,...)
	return c:IsCanBePutIntoBattleZone(e,0,tp,false,false) and (not f or f(c,e,tp,...))
end
function Auxiliary.PutIntoBattleTarget(f,s,o,ex,...)
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				if chk==0 then
					if s==LOCATION_DECK or o==LOCATION_DECK then
						return Duel.GetFieldGroupCount(tp,s,o)>0
					else
						return Duel.IsExistingMatchingCard(Auxiliary.PutIntoBattleFilter,tp,s,o,1,ex,e,tp,f,table.unpack(funs))
					end
				end
			end
end
function Auxiliary.PutIntoBattleOperation(p,f,s,o,min,max,pos,ex,...)
	--p,min,max: nil to put all creatures into the battle zone
	--pos: POS_FACEUP_UNTAPPED to put in untapped position or POS_FACEUP_TAPPED to put in tapped position
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local player=nil
				if p==PLAYER_PLAYER or p==tp then player=tp
				elseif p==PLAYER_OPPONENT or p==1-tp then player=1-tp end
				local max=max or min
				local pos=pos or POS_FACEUP_UNTAPPED
				local ft=Duel.GetLocationCount(player,DM_LOCATION_BATTLE)
				if max>=0 and ft>max then ft=max end
				if e:IsHasType(EFFECT_TYPE_CONTINUOUS) then Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode()) end
				local g=Duel.GetMatchingGroup(f,tp,s,o,ex,table.unpack(funs))
				if s==LOCATION_DECK or o==LOCATION_DECK then
					local dg=Duel.GetFieldGroup(player,s,o)
					Duel.ConfirmCards(player,dg)
				end
				if g:GetCount()>0 then
					if min and max then
						Duel.Hint(HINT_SELECTMSG,player,DM_HINTMSG_TOBATTLE)
						local sg=g:Select(player,min,ft,ex,table.unpack(funs))
						if sg:GetCount()==0 and s==LOCATION_DECK then Duel.ShuffleDeck(player) end
						if sg:GetCount()==0 and o==LOCATION_DECK then Duel.ShuffleDeck(1-player) end
						Duel.PutIntoBattleZone(sg,0,player,player,false,false,pos)
					else
						Duel.PutIntoBattleZone(g,0,player,player,false,false,pos)
					end
				else
					Duel.Hint(HINT_MESSAGE,player,DM_HINTMSG_NOTARGETS)
					if s==LOCATION_DECK then Duel.ShuffleDeck(player) end
					if o==LOCATION_DECK then Duel.ShuffleDeck(1-player) end
				end
			end
end
--target and operation functions for abilities that choose creatures to put into the battle zone
function Auxiliary.ChoosePutIntoBattleTarget(p,f,s,o,min,max,ex,...)
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				local player=nil
				if p==PLAYER_PLAYER or p==tp then player=tp
				elseif p==PLAYER_OPPONENT or p==1-tp then player=1-tp end
				local f=f or aux.TRUE
				local max=max or min
				local location=s
				local controler=tp
				if s==0 and o~=0 then location=o end
				if location==o then controler=1-tp end
				if chkc then
					if s==o then
						return chkc:IsLocation(location) and Auxiliary.PutIntoBattleFilter(chkc,e,tp,f,table.unpack(funs))
					elseif type(ex)=="Card" then
						return chkc:IsLocation(location) and chkc:IsControler(controler)
							and Auxiliary.PutIntoBattleFilter(chkc,e,tp,f,table.unpack(funs)) and chkc~=ex
					else
						return chkc:IsLocation(location) and chkc:IsControler(controler)
							and Auxiliary.PutIntoBattleFilter(chkc,e,tp,f,table.unpack(funs))
					end
				end
				if chk==0 then
					if e:IsHasType(EFFECT_TYPE_TRIGGER_F) or e:IsHasType(EFFECT_TYPE_QUICK_F) or e:GetHandler():IsSpell() then
						return true
					end
					if s==LOCATION_DECK or o==LOCATION_DECK then
						return Duel.GetFieldGroupCount(tp,s,o)>0
					else
						return Duel.IsExistingTarget(Auxiliary.PutIntoBattleFilter,tp,s,o,1,ex,e,tp,f,table.unpack(funs))
					end
				end
				if s==LOCATION_DECK or o==LOCATION_DECK then
					local g=Duel.GetFieldGroup(player,s,o)
					Duel.ConfirmCards(player,g)
					if g:IsExists(f,1,ex,table.unpack(funs)) then
						Duel.Hint(HINT_SELECTMSG,player,DM_HINTMSG_TOBATTLE)
						local sg=Duel.SelectTarget(player,f,tp,s,o,min,max,ex,table.unpack(funs))
						if sg:GetCount()==0 then return Duel.ShuffleDeck(player) end
					else
						Duel.Hint(HINT_MESSAGE,player,DM_HINTMSG_NOTARGETS)
						Duel.ShuffleDeck(player)
					end
				else
					Duel.Hint(HINT_SELECTMSG,player,DM_HINTMSG_TOBATTLE)
					Duel.SelectTarget(player,f,tp,s,o,min,max,ex,table.unpack(funs))
				end
			end
end
function Auxiliary.ChoosePutIntoBattleOperation(pos)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local pos=pos or POS_FACEUP_UNTAPPED
				local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
				if not g then return end
				local sg=g:Filter(Card.IsRelateToEffect,nil,e)
				Duel.PutIntoBattleZone(sg,0,tp,tp,false,false,pos)
			end
end
--========== SendtoDeck ==========
--operation function for abilities that choose cards to put into a player's deck
function Auxiliary.ChooseSendtoDeckOperation(seq)
	--seq: where to put the cards: DECK_SEQUENCE_TOP|BOTTOM|SHUFFLE
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
				if not g then return end
				local sg=g:Filter(Card.IsRelateToEffect,nil,e)
				Duel.SendtoDeck(sg,PLAYER_OWNER,seq,REASON_EFFECT)
			end
end
--========== SendtoGrave ==========
--operation function for abilities that put cards into the graveyard
function Auxiliary.SendtoGraveOperation(p,f,s,o,min,max,ex,...)
	--p,min,max: nil to put all cards into into the graveyard
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local player=nil
				if p==PLAYER_PLAYER or p==tp then player=tp
				elseif p==PLAYER_OPPONENT or p==1-tp then player=1-tp end
				local max=max or min
				local c=e:GetHandler()
				if c:IsSpell() and c:IsLocation(LOCATION_HAND) and (s==LOCATION_HAND or o==LOCATION_HAND) then ex=c end
				if e:IsHasType(EFFECT_TYPE_CONTINUOUS) then Duel.Hint(HINT_CARD,0,c:GetOriginalCode()) end
				local g=Duel.GetMatchingGroup(f,tp,s,o,ex,table.unpack(funs))
				if s==LOCATION_DECK or o==LOCATION_DECK then
					local dg=Duel.GetFieldGroup(player,s,o)
					Duel.ConfirmCards(player,dg)
				end
				if g:GetCount()>0 then
					if min and max then
						Duel.Hint(HINT_SELECTMSG,player,DM_HINTMSG_TOGRAVE)
						local sg=g:Select(player,min,max,ex,table.unpack(funs))
						if sg:GetCount()==0 and s==LOCATION_DECK then Duel.ShuffleDeck(player) end
						if sg:GetCount()==0 and o==LOCATION_DECK then Duel.ShuffleDeck(1-player) end
						if s==DM_LOCATION_BATTLE or o==DM_LOCATION_BATTLE or s==DM_LOCATION_SHIELD or o==DM_LOCATION_SHIELD then
							Duel.HintSelection(sg)
						end
						Duel.SendtoDMGrave(sg,REASON_EFFECT)
					else
						Duel.SendtoDMGrave(g,REASON_EFFECT)
					end
				else
					Duel.Hint(HINT_MESSAGE,player,DM_HINTMSG_NOTARGETS)
					if s==LOCATION_DECK then Duel.ShuffleDeck(player) end
					if o==LOCATION_DECK then Duel.ShuffleDeck(1-player) end
				end
			end
end
--operation functions for abilities that choose cards to put into the graveyard
function Auxiliary.ChooseSendtoGraveOperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not g then return end
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoDMGrave(sg,REASON_EFFECT)
end
--========== SendtoHand ==========
--operation function for abilities that put cards into a player's hand
function Auxiliary.SendtoHandOperation(p,f,s,o,min,max,conf,ex,...)
	--p,min,max: nil to put all cards into a player's hand
	--conf: true to show cards added from the deck to the opponent
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local player=nil
				if p==PLAYER_PLAYER or p==tp then player=tp
				elseif p==PLAYER_OPPONENT or p==1-tp then player=1-tp end
				local max=max or min
				local desc=DM_HINTMSG_RTOHAND
				if e:IsHasType(EFFECT_TYPE_CONTINUOUS) then Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode()) end
				local g=Duel.GetMatchingGroup(f,tp,s,o,ex,table.unpack(funs))
				if s==LOCATION_DECK or o==LOCATION_DECK then
					local dg=Duel.GetFieldGroup(player,s,o)
					Duel.ConfirmCards(player,dg)
				end
				if g:GetCount()>0 then
					if min and max then
						if s==LOCATION_DECK or o==LOCATION_DECK then desc=DM_HINTMSG_ATOHAND end
						Duel.Hint(HINT_SELECTMSG,player,desc)
						local sg=g:Select(player,min,max,ex,table.unpack(funs))
						if sg:GetCount()==0 and s==LOCATION_DECK then Duel.ShuffleDeck(player) end
						if sg:GetCount()==0 and o==LOCATION_DECK then Duel.ShuffleDeck(1-player) end
						if s==DM_LOCATION_BATTLE or o==DM_LOCATION_BATTLE or s==DM_LOCATION_SHIELD or o==DM_LOCATION_SHIELD then
							Duel.HintSelection(sg)
						end
						Duel.SendtoHand(sg,PLAYER_OWNER,REASON_EFFECT)
					else
						Duel.SendtoHand(g,PLAYER_OWNER,REASON_EFFECT)
					end
					local og1=Duel.GetOperatedGroup():Filter(Card.IsControler,nil,tp)
					local og2=Duel.GetOperatedGroup():Filter(Card.IsControler,nil,1-tp)
					local og3=Duel.GetOperatedGroup():Filter(Card.IsPreviousLocation,nil,LOCATION_DECK)
					local og4=Duel.GetOperatedGroup():Filter(Card.IsPreviousLocation,nil,DM_LOCATION_MANA+DM_LOCATION_GRAVE)
					if (conf and og1:GetCount()>0 and og3:GetCount()>0) or og4:GetCount()>0 then Duel.ConfirmCards(1-tp,og1) end
					if (conf and og2:GetCount()>0 and og3:GetCount()>0) or og4:GetCount()>0 then Duel.ConfirmCards(tp,og2) end
				else
					Duel.Hint(HINT_MESSAGE,player,DM_HINTMSG_NOTARGETS)
					if s==LOCATION_DECK then Duel.ShuffleDeck(player) end
					if o==LOCATION_DECK then Duel.ShuffleDeck(1-player) end
				end
			end
end
--operation function for abilities that choose cards to put into a player's hand
function Auxiliary.ChooseSendtoHandOperation(conf)
	--conf: true to show cards added from the deck to the opponent
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
				if not g then return end
				local sg=g:Filter(Card.IsRelateToEffect,nil,e)
				Duel.SendtoHand(sg,PLAYER_OWNER,REASON_EFFECT)
				local og1=Duel.GetOperatedGroup():Filter(Card.IsControler,nil,tp)
				local og2=Duel.GetOperatedGroup():Filter(Card.IsControler,nil,1-tp)
				local og3=Duel.GetOperatedGroup():Filter(Card.IsPreviousLocation,nil,LOCATION_DECK)
				local og4=Duel.GetOperatedGroup():Filter(Card.IsPreviousLocation,nil,DM_LOCATION_MANA+DM_LOCATION_GRAVE)
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
				local player=nil
				if p==PLAYER_PLAYER or p==tp then player=tp
				elseif p==PLAYER_OPPONENT or p==1-tp then player=1-tp end
				local max=max or min
				local c=e:GetHandler()
				if c:IsSpell() and c:IsLocation(LOCATION_HAND) and (s==LOCATION_HAND or o==LOCATION_HAND) then ex=c end
				if e:IsHasType(EFFECT_TYPE_CONTINUOUS) then Duel.Hint(HINT_CARD,0,c:GetOriginalCode()) end
				local g=Duel.GetMatchingGroup(f,tp,s,o,ex,table.unpack(funs))
				if s==LOCATION_DECK or o==LOCATION_DECK then
					local dg=Duel.GetFieldGroup(player,s,o)
					Duel.ConfirmCards(player,dg)
				end
				if g:GetCount()>0 then
					if min and max then
						Duel.Hint(HINT_SELECTMSG,player,DM_HINTMSG_TOMANA)
						local sg=g:Select(player,min,max,ex,table.unpack(funs))
						if sg:GetCount()==0 and s==LOCATION_DECK then Duel.ShuffleDeck(player) end
						if sg:GetCount()==0 and o==LOCATION_DECK then Duel.ShuffleDeck(1-player) end
						if s==DM_LOCATION_BATTLE or o==DM_LOCATION_BATTLE or s==DM_LOCATION_SHIELD or o==DM_LOCATION_SHIELD then
							Duel.HintSelection(sg)
						end
						Duel.SendtoMana(sg,POS_FACEUP_UNTAPPED,REASON_EFFECT)
					else
						Duel.SendtoMana(g,POS_FACEUP_UNTAPPED,REASON_EFFECT)
					end
				else
					Duel.Hint(HINT_MESSAGE,player,DM_HINTMSG_NOTARGETS)
					if s==LOCATION_DECK then Duel.ShuffleDeck(player) end
					if o==LOCATION_DECK then Duel.ShuffleDeck(1-player) end
				end
			end
end
--operation function for abilities that choose cards to put into the mana zone
function Auxiliary.ChooseSendtoManaOperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not g then return end
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoMana(sg,POS_FACEUP_UNTAPPED,REASON_EFFECT)
end
--target and operation functions for abilities that put cards from the top of a player's deck into the mana zone
function Auxiliary.DecktopSendtoManaTarget(p)
	--p: PLAYER_PLAYER/tp for the top of your deck or PLAYER_OPPONENT/1-tp for your opponent's
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				local player=nil
				if p==PLAYER_PLAYER or p==tp then player=tp
				elseif p==PLAYER_OPPONENT or p==1-tp then player=1-tp end
				if chk==0 then return Duel.IsPlayerCanSendDecktoptoMana(player,1) end
			end
end
function Auxiliary.DecktopSendtoManaOperation(p,ct)
	--ct: the number of cards to put into the mana zone
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local player=nil
				if p==PLAYER_PLAYER or p==tp then player=tp
				elseif p==PLAYER_OPPONENT or p==1-tp then player=1-tp end
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
				local player=nil
				if p==PLAYER_PLAYER or p==tp then player=tp
				elseif p==PLAYER_OPPONENT or p==1-tp then player=1-tp end
				local max=max or min
				local ft=Duel.GetLocationCount(player,DM_LOCATION_SHIELD)
				if max>=0 and ft>max then ft=max end
				local c=e:GetHandler()
				if c:IsSpell() and c:IsLocation(LOCATION_HAND) and (s==LOCATION_HAND or o==LOCATION_HAND) then ex=c end
				if e:IsHasType(EFFECT_TYPE_CONTINUOUS) then Duel.Hint(HINT_CARD,0,c:GetOriginalCode()) end
				local g=Duel.GetMatchingGroup(f,player,s,o,ex,table.unpack(funs))
				if s==LOCATION_DECK or o==LOCATION_DECK then
					local dg=Duel.GetFieldGroup(player,s,o)
					Duel.ConfirmCards(player,dg)
				end
				if g:GetCount()>0 then
					if min and max then
						Duel.Hint(HINT_SELECTMSG,player,DM_HINTMSG_TOSHIELD)
						local sg=g:Select(player,min,ft,ex,table.unpack(funs))
						if s==DM_LOCATION_BATTLE or o==DM_LOCATION_BATTLE then Duel.HintSelection(sg) end
						Duel.SendtoShield(sg,player)
					else
						Duel.SendtoShield(g,player)
					end
					local og1=Duel.GetOperatedGroup():Filter(Card.IsControler,nil,tp)
					local og2=Duel.GetOperatedGroup():Filter(Card.IsControler,nil,1-tp)
					if og1:GetCount()>0 then Duel.ConfirmCards(1-tp,og1) end
					if og2:GetCount()>0 then Duel.ConfirmCards(tp,og2) end
				else
					Duel.Hint(HINT_MESSAGE,player,DM_HINTMSG_NOTARGETS)
					if s==LOCATION_DECK then Duel.ShuffleDeck(player) end
					if o==LOCATION_DECK then Duel.ShuffleDeck(1-player) end
				end
			end
end
--operation functions for abilities that choose cards to put into the shield zone
--reserved
--[[
function Auxiliary.ChooseSendtoShieldOperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not g then return end
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoShield(sg,tp)
	Duel.ConfirmCards(1-tp,sg)
end
]]
--target and operation functions for abilities that put cards from the top of a player's deck into the shield zone
--reserved
--[[
function Auxiliary.DecktopSendtoShieldTarget(p)
	--p: PLAYER_PLAYER/tp for the top of your deck or PLAYER_OPPONENT/1-tp for your opponent's
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				local player=nil
				if p==PLAYER_PLAYER or p==tp then player=tp
				elseif p==PLAYER_OPPONENT or p==1-tp then player=1-tp end
				if chk==0 then return Duel.GetFieldGroupCount(player,LOCATION_DECK,0)>0 end
			end
end
]]
function Auxiliary.DecktopSendtoShieldOperation(p,ct)
	--ct: the number of cards to put into the shield zone
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local player1=nil
				local player2=nil
				if p==PLAYER_PLAYER or p==tp then player1=tp
				elseif p==PLAYER_OPPONENT or p==1-tp then player2=1-tp
				elseif p==PLAYER_ALL then
					player1=tp
					player2=1-tp
				end
				if e:IsHasType(EFFECT_TYPE_CONTINUOUS) then Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode()) end
				local g1=Duel.GetDecktopGroup(player1,ct)
				Duel.DisableShuffleCheck()
				Duel.SendtoShield(g1,player1)
				if p~=PLAYER_ALL then return end
				local g2=Duel.GetDecktopGroup(player2,ct)
				Duel.DisableShuffleCheck()
				Duel.SendtoShield(g2,player2)
			end
end
--========== TapUntap ==========
--operation function for abilities that tap/untap cards
function Auxiliary.TapUntapOperation(p,f,s,o,min,max,pos,ram,ex,...)
	--p,min,max: nil to tap/untap all cards
	--pos: POS_FACEUP_TAPPED to tap or POS_FACEUP_UNTAPPED to untap
	--ram: true to tap/untap cards at random
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local player=nil
				if p==PLAYER_PLAYER or p==tp then player=tp
				elseif p==PLAYER_OPPONENT or p==1-tp then player=1-tp end
				local desc=DM_HINTMSG_TAP
				if pos==POS_FACEUP_UNTAPPED then desc=DM_HINTMSG_UNTAP end
				if e:IsHasType(EFFECT_TYPE_CONTINUOUS) then Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode()) end
				local g=Duel.GetMatchingGroup(f,tp,s,o,ex,table.unpack(funs))
				--the attacker is excluded because it's supposed to be tapped according to the attack rule
				g:RemoveCard(Duel.GetAttacker())
				local sg=nil
				if min and max then
					if ram then
						sg=g:RandomSelect(player,min)
					else
						Duel.Hint(HINT_SELECTMSG,player,desc)
						sg=g:Select(player,min,max,ex,table.unpack(funs))
					end
					if s==DM_LOCATION_BATTLE or o==DM_LOCATION_BATTLE then Duel.HintSelection(sg) end
					Duel.ChangePosition(sg,pos)
				else
					Duel.ChangePosition(g,pos)
				end
			end
end
--operation function for abilities that choose cards to tap/untap
function Auxiliary.ChooseTapUntapOperation(pos)
	--pos: POS_FACEUP_TAPPED to tap or POS_FACEUP_UNTAPPED to untap
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
				if not g then return end
				local sg=g:Filter(Card.IsRelateToEffect,nil,e)
				Duel.ChangePosition(sg,pos)
			end
end

--==========[+Conditions]==========
--condition for a player's turn
function Auxiliary.TurnPlayerCondition(p)
	return	function(e)
				local tp=e:GetHandlerPlayer()
				local player=nil
				if p==PLAYER_PLAYER or p==tp then player=tp
				elseif p==PLAYER_OPPONENT or p==1-tp then player=1-tp end
				return Duel.GetTurnPlayer()==player
			end
end
Auxiliary.turnpcon=Auxiliary.TurnPlayerCondition
--condition for the battle phase
function Auxiliary.BattlePhaseCondition()
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end
Auxiliary.bpcon=Auxiliary.BattlePhaseCondition
--condition for "While this creature is attacking"
--e.g. "Bolshack Dragon" (DM-01 69/110)
function Auxiliary.SelfAttackerCondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler()
end
Auxiliary.satcon=Auxiliary.SelfAttackerCondition
--condition for "Whenever this creature wins a battle" + EVENT_BATTLE_DESTROYING
--e.g. "Bloody Squito" (DM-01 46/110), "Hanakage, Shadow of Transience" (Game Original)
function Auxiliary.SelfBattleWinCondition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:IsOnField()
end
Auxiliary.sbwcon=Auxiliary.SelfBattleWinCondition
--condition to get a card's previous location
--e.g. "Bombersaur" (DM-02 36/55), "Altimeth, Holy Divine Dragon" (Game Original)
function Auxiliary.PreviousLocationCondition(loc)
	--loc: DM_LOCATION_BATTLE for "When this creature is destroyed/leaves the battle zone" + EVENT_DESTROYED
	return	function(e,tp,eg,ep,ev,re,r,rp)
				return e:GetHandler():IsPreviousLocation(loc)
			end
end
Auxiliary.plocon=Auxiliary.PreviousLocationCondition
--condition for "While this creature is tapped"
--e.g. "Barkwhip, the Smasher" (DM-02 45/55)
function Auxiliary.SelfTappedCondition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsTapped()
end
Auxiliary.stapcon=Auxiliary.SelfTappedCondition
--condition for "While all the cards in your mana zone are CIVILIZATION cards"
--e.g. "Sparkle Flower" (DM-03 9/55)
function Auxiliary.ManaExclusiveCondition(f2,...)
	local funs={...}
	return	function(e)
				local tp=e:GetHandlerPlayer()
				local f1=function(c,f2,...)
					return not f2(c,...)
				end
				return Duel.IsExistingMatchingCard(Auxiliary.ManaZoneFilter(),tp,DM_LOCATION_MANA,0,1,nil,f2,table.unpack(funs))
					and not Duel.IsExistingMatchingCard(Auxiliary.ManaZoneFilter(f1),tp,DM_LOCATION_MANA,0,1,nil,f2,table.unpack(funs))
			end
end
Auxiliary.mexcon=Auxiliary.ManaExclusiveCondition
--condition for "While a player has no shields"
--e.g. "Gigazoul" (DM-05 28/55)
function Auxiliary.NoShieldsCondition(p)
	return	function(e)
				local player=nil
				if p==PLAYER_PLAYER or p==tp then player=tp
				elseif p==PLAYER_OPPONENT or p==1-tp then player=1-tp end
				return Duel.GetMatchingGroupCount(Auxiliary.ShieldZoneFilter(),player,DM_LOCATION_SHIELD,0,nil)==0
			end
end
Auxiliary.nszcon=Auxiliary.NoShieldsCondition

--==========[+Costs]==========
--cost for a card tapping itself
--e.g. "Millstone Man" (Game Original)
function Auxiliary.SelfTapCost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsFaceupUntapped() end
	Duel.ChangePosition(c,POS_FACEUP_TAPPED)
end
Auxiliary.stapcost=Auxiliary.SelfTapCost

--==========[+Targets]==========
--target function for optional abilities that do not choose cards
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
--target function for abilities that choose cards
function Auxiliary.ChooseCardFunction(p,f,s,o,min,max,desc,ex,...)
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				local player=nil
				if p==PLAYER_PLAYER or p==tp then player=tp
				elseif p==PLAYER_OPPONENT or p==1-tp then player=1-tp end
				local max=max or min
				local desc=desc or DM_HINTMSG_CHOOSE
				local c=e:GetHandler()
				if c:IsSpell() and c:IsLocation(LOCATION_HAND) and (s==LOCATION_HAND or o==LOCATION_HAND) then ex=c end
				local location=s
				local controler=tp
				if s==0 and o~=0 then location=o end
				if location==o then controler=1-tp end
				if chkc then
					if s==o then
						return chkc:IsLocation(location) and f(chkc)
					elseif type(ex)=="Card" then
						return chkc:IsLocation(location) and chkc:IsControler(controler) and f(chkc) and chkc~=ex
					else
						return chkc:IsLocation(location) and chkc:IsControler(controler) and f(chkc)
					end
				end
				if chk==0 then
					if e:IsHasType(EFFECT_TYPE_TRIGGER_F) or e:IsHasType(EFFECT_TYPE_QUICK_F) or c:IsSpell() then
						return true
					elseif s==LOCATION_DECK or o==LOCATION_DECK then
						return Duel.GetFieldGroupCount(tp,s,o)>0
					else
						return Duel.IsExistingTarget(f,tp,s,o,1,ex,table.unpack(funs))
					end
				end
				if s==LOCATION_DECK or o==LOCATION_DECK then
					local g1=Duel.GetFieldGroup(player,s,o)
					Duel.ConfirmCards(player,g1)
					if Duel.IsExistingTarget(f,tp,s,o,1,ex,table.unpack(funs)) then
						Duel.Hint(HINT_SELECTMSG,player,desc)
						local g2=Duel.SelectTarget(player,f,tp,s,o,min,max,ex,table.unpack(funs))
						if g2:GetCount()==0 then return Duel.ShuffleDeck(player) end
					else
						Duel.Hint(HINT_MESSAGE,player,DM_HINTMSG_NOTARGETS)
						Duel.ShuffleDeck(player)
					end
				else
					Duel.Hint(HINT_SELECTMSG,player,desc)
					Duel.SelectTarget(player,f,tp,s,o,min,max,ex,table.unpack(funs))
				end
			end
end
Auxiliary.targtg=Auxiliary.ChooseCardFunction
--target function to check if a player has cards in their deck
function Auxiliary.CheckDeckFunction(p)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				local player=nil
				if p==PLAYER_PLAYER or p==tp then player=tp
				elseif p==PLAYER_OPPONENT or p==1-tp then player=1-tp end
				if chk==0 then return Duel.GetFieldGroupCount(player,LOCATION_DECK,0)>0 end
				Duel.Hint(HINT_OPSELECTED,1-player,e:GetDescription())
			end
end
Auxiliary.chkdtg=Auxiliary.CheckDeckFunction
--target function for Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
function Auxiliary.HintTarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if e:IsHasProperty(DM_EFFECT_FLAG_CARD_CHOOSE) then
		if chkc then return false end
	end
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
Auxiliary.hinttg=Auxiliary.HintTarget

--==========[+Filters]==========
--filter to get a card in the mana zone
function Auxiliary.ManaZoneFilter(f)
	--DM_LOCATION_MANA + f: function
	return	function(target,...)
				return (target:IsUntapped() or target:IsTapped()) and target:IsLocation(DM_LOCATION_MANA)
					and (not f or f(target,...))
			end
end
Auxiliary.mzfilter=Auxiliary.ManaZoneFilter
--filter to get a card in the graveyard
function Auxiliary.DMGraveFilter(f)
	--DM_LOCATION_GRAVE + f: function
	return	function(target,...)
				return target:IsFaceup() and (not f or f(target,...))
			end
end
Auxiliary.gyfilter=Auxiliary.DMGraveFilter
--filter to get a card in the shield zone
function Auxiliary.ShieldZoneFilter(f)
	--DM_LOCATION_SHIELD + f: function
	return	function(target,...)
				return target:IsShield() and (not f or f(target,...))
			end
end
Auxiliary.szfilter=Auxiliary.ShieldZoneFilter
return Auxiliary
