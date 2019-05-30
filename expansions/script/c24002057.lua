--Crystal Paladin
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_LIQUID_PEOPLE))
	--return
	dm.AddSingleComeIntoPlayTriggerEffect(c,0,nil,nil,dm.SendtoHandOperation(nil,scard.retfilter,DM_LOCATION_BZONE,DM_LOCATION_BZONE))
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_LIQUID_PEOPLE}
function scard.retfilter(c)
	return c:IsFaceup() and c:IsHasEffect(DM_EFFECT_BLOCKER)
end
