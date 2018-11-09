--Roar of the Earth
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--return
	dm.AddSpellCastEffect(c,0,nil,dm.SendtoHandOperation(PLAYER_PLAYER,dm.ManaZoneFilter(scard.retfilter),DM_LOCATION_MANA,0,1))
	dm.AddShieldTriggerCastEffect(c,0,nil,dm.SendtoHandOperation(PLAYER_PLAYER,dm.ManaZoneFilter(scard.retfilter),DM_LOCATION_MANA,0,1))
end
scard.duel_masters_card=true
function scard.retfilter(c)
	return c:IsCreature() and c:IsManaCostAbove(6) and c:IsAbleToHand()
end
