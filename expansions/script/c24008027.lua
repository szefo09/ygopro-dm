--Cranium Clamp
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--discard
	dm.AddSpellCastEffect(c,0,scard.dhtg,scard.dhop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
scard.dhtg=dm.TargetCardFunction(PLAYER_OPPONENT,aux.TRUE,0,LOCATION_HAND,2,2,DM_HINTMSG_DISCARD)
scard.dhop=dm.TargetDiscardOperation
