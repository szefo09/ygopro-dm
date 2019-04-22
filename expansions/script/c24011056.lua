--Warlord Ailzonius
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_GLADIATOR))
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--cannot be targeted
	dm.EnableCannotBeTargeted(c)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_GLADIATOR}
