--King Neptas
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--return
	dm.AddSingleAttackTriggerEffect(c,0,true,scard.rettg,scard.retop,DM_EFFECT_FLAG_CARD_CHOOSE)
end
scard.duel_masters_card=true
function scard.retfilter(c)
	return c:IsFaceup() and c:IsPowerBelow(2000) and c:IsAbleToHand()
end
scard.rettg=dm.ChooseCardFunction(PLAYER_PLAYER,scard.retfilter,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,1,1,DM_HINTMSG_RTOHAND)
scard.retop=dm.ChooseSendtoHandOperation()
