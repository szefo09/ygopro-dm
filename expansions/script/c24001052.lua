--Dark Reversal
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--return
	dm.AddSpellCastEffect(c,0,nil,scard.retop)
	dm.AddShieldTriggerCastEffect(c,0,nil,scard.retop)
end
scard.duel_masters_card=true
scard.retop=dm.SendtoHandOperation(PLAYER_PLAYER,dm.DMGraveFilter(Card.IsCreature),DM_LOCATION_GRAVE,0,1)
