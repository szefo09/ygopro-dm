--Tropic Crawler
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--return
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_BATTLE_END,nil,scard.rettg,scard.retop,EFFECT_FLAG_CARD_TARGET,dm.SelfBlockCondition)
	--cannot attack
	dm.EnableCannotAttack(c)
end
scard.duel_masters_card=true
function scard.retfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
scard.rettg=dm.TargetCardFunction(PLAYER_OPPO,scard.retfilter,0,DM_LOCATION_BZONE,1,1,DM_HINTMSG_RTOHAND)
scard.retop=dm.TargetSendtoHandOperation()
