--Niofa, Horned Protector
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.IsDMRace,DM_RACE_HORNED_BEAST))
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--search (to hand)
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,dm.SendtoHandOperation(PLAYER_PLAYER,scard.thfilter,LOCATION_DECK,0,0,1,true))
end
scard.duel_masters_card=true
function scard.thfilter(c)
	return c:IsCivilization(DM_CIVILIZATION_NATURE) and c:IsCreature()
end
