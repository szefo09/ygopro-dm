--反撃妖精ポコペン
--Pocopen, Counterattacking Faerie
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to grave
	dm.AddSingleBeAttackedEffect(c,0,nil,scard.tgtg,scard.tgop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
scard.tgtg=dm.TargetCardFunction(PLAYER_OPPO,dm.ManaZoneFilter(Card.DMIsAbleToGrave),0,DM_LOCATION_MANA,1,1,DM_HINTMSG_TOGRAVE)
scard.tgop=dm.TargetSendtoGraveOperation