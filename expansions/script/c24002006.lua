--Logic Cube
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--search (to hand)
	dm.AddSpellCastEffect(c,0,nil,dm.SendtoHandOperation(PLAYER_PLAYER,scard.thfilter,LOCATION_DECK,0,0,1,true))
	dm.AddShieldTriggerCastEffect(c,0,nil,dm.SendtoHandOperation(PLAYER_PLAYER,scard.thfilter,LOCATION_DECK,0,0,1,true))
end
scard.duel_masters_card=true
function scard.thfilter(c)
	return c:IsSpell() and c:IsAbleToHand()
end
