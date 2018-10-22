--King Mazelan
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--return
	dm.AddSingleComeIntoPlayEffect(c,0,true,scard.rettg,scard.retop,DM_EFFECT_FLAG_CARD_CHOOSE)
end
scard.duel_masters_card=true
scard.rettg=dm.ChooseCardFunction(PLAYER_PLAYER,Card.IsAbleToHand,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,1,1,DM_HINTMSG_RTOHAND)
scard.retop=dm.ChooseSendtoHandOperation()
