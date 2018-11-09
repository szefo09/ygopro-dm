--King Mazelan
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--return
	dm.AddSingleComeIntoPlayEffect(c,0,true,scard.rettg,scard.retop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.retfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
scard.rettg=dm.TargetCardFunction(PLAYER_PLAYER,scard.retfilter,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,1,1,DM_HINTMSG_RTOHAND)
scard.retop=dm.TargetSendtoHandOperation()
