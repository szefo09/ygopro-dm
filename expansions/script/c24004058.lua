--Ballom, Master of Death
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsRace,DM_RACE_DEMON_COMMAND))
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--destroy
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,dm.DestroyOperation(nil,scard.desfilter,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE))
end
scard.duel_masters_card=true
function scard.desfilter(c)
	return c:IsFaceup() and not c:IsCivilization(DM_CIVILIZATION_DARKNESS)
end
