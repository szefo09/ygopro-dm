--反撃妖精ポコペン
--Pocopen, Counterattacking Faerie
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to grave
	dm.AddSingleTriggerEffect(c,0,EVENT_BE_BATTLE_TARGET,nil,scard.tgtg,scard.tgop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
scard.tgtg=dm.TargetCardFunction(PLAYER_OPPO,dm.ManaZoneFilter(Card.DMIsAbleToGrave),0,DM_LOCATION_MZONE,1,1,DM_HINTMSG_TOGRAVE)
scard.tgop=dm.TargetCardsOperation(Duel.DMSendtoGrave,REASON_EFFECT)
