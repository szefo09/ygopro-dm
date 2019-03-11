--Armored Raider Gandaval
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_HUMAN))
	--power up
	dm.EnableUpdatePower(c,scard.powval,dm.SelfAttackerCondition)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
function scard.cfilter(c)
	return c:IsFaceup() and c:IsTapped()
end
function scard.powval(e,c)
	return Duel.GetMatchingGroupCount(scard.cfilter,c:GetControler(),DM_LOCATION_BATTLE,0,c)*2000
end
