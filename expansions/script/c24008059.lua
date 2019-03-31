--Überdragon Bajula
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_DRAGON))
	--to grave
	dm.AddSingleAttackTriggerEffect(c,0,nil,scard.tgtg,scard.tgop,EFFECT_FLAG_CARD_TARGET)
	--triple breaker
	dm.EnableBreaker(c,DM_EFFECT_TRIPLE_BREAKER)
end
scard.duel_masters_card=true
scard.tgtg=dm.TargetCardFunction(PLAYER_SELF,dm.ManaZoneFilter(Card.DMIsAbleToGrave),0,DM_LOCATION_MANA,0,2,DM_HINTMSG_TOGRAVE)
scard.tgop=dm.TargetSendtoGraveOperation
