--Boomerang Comet
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--return
	dm.AddSpellCastEffect(c,0,nil,scard.retop,DM_EFFECT_FLAG_CHARGE)
	dm.AddShieldTriggerCastEffect(c,0,nil,scard.retop,DM_EFFECT_FLAG_CHARGE)
end
scard.duel_masters_card=true
scard.retop=dm.SendtoHandOperation(PLAYER_PLAYER,dm.ManaZoneFilter(Card.IsAbleToHand),DM_LOCATION_MANA,0,1)
