--General Dark Fiend
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to grave
	dm.AddSingleTriggerEffect(c,0,EVENT_ATTACK_ANNOUNCE,nil,scard.tgtg,scard.tgop,EFFECT_FLAG_CARD_TARGET)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
scard.tgtg=dm.TargetCardFunction(PLAYER_SELF,dm.ShieldZoneFilter(Card.DMIsAbleToGrave),DM_LOCATION_SZONE,0,1,1,DM_HINTMSG_TOGRAVE)
scard.tgop=dm.TargetSendtoGraveOperation
