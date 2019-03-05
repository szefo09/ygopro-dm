--Gor, Primal Hunter
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to grave
	dm.AddSingleComeIntoPlayEffect(c,0,nil,scard.tgtg,scard.tgop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.tgfilter(c)
	return c:IsTapped() and c:DMIsAbleToGrave()
end
scard.tgtg=dm.TargetCardFunction(PLAYER_OPPONENT,dm.ManaZoneFilter(scard.tgfilter),0,DM_LOCATION_MANA,2,2,DM_HINTMSG_TOGRAVE)
scard.tgop=dm.TargetSendtoGraveOperation
