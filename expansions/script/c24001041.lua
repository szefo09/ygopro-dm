--Teleportation
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--return
	dm.AddSpellCastEffect(c,0,scard.rettg,scard.retop,DM_EFFECT_FLAG_CARD_CHOOSE)
end
scard.duel_masters_card=true
scard.rettg=dm.ChooseCardFunction(PLAYER_PLAYER,nil,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,0,2,DM_HINTMSG_RTOHAND)
scard.retop=dm.ChooseSendtoHandOperation()
