--Jabaha's Automaton
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_XENOPARTS))
	--power attacker
	dm.EnablePowerAttacker(c,4000)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
