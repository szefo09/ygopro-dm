--Fortress Shell
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to grave
	dm.AddSingleTriggerEffectCustom(c,0,DM_EVENT_COME_INTO_PLAY,nil,scard.tgtg,scard.tgop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
scard.tgtg=dm.TargetCardFunction(PLAYER_SELF,dm.ManaZoneFilter(Card.DMIsAbleToGrave),0,DM_LOCATION_MZONE,0,2,DM_HINTMSG_TOGRAVE)
scard.tgop=dm.TargetSendtoGraveOperation
