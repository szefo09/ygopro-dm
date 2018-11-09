--Dark Reversal
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--return
	dm.AddSpellCastEffect(c,0,nil,dm.SendtoHandOperation(PLAYER_PLAYER,dm.DMGraveFilter(scard.retfilter),DM_LOCATION_GRAVE,0,1))
	dm.AddShieldTriggerCastEffect(c,0,nil,dm.SendtoHandOperation(PLAYER_PLAYER,dm.DMGraveFilter(scard.retfilter),DM_LOCATION_GRAVE,0,1))
end
scard.duel_masters_card=true
function scard.retfilter(c)
	return c:IsCreature() and c:IsAbleToHand()
end
