--Craze Valkyrie, the Drastic
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_INITIATE))
	--tap
	dm.AddSingleComeIntoPlayEffect(c,0,nil,scard.postg,scard.posop,EFFECT_FLAG_CARD_TARGET)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
function scard.posfilter(c)
	return c:IsFaceup() and c:IsUntapped()
end
scard.postg=dm.TargetCardFunction(PLAYER_SELF,scard.posfilter,0,DM_LOCATION_BATTLE,0,2,DM_HINTMSG_TAP)
scard.posop=dm.TargetTapOperation
