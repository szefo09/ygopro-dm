--Phantomach, the Gigatrooper
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_CHIMERA,DM_RACE_ARMORLOID))
	--power up
	dm.EnableUpdatePower(c,2000,nil,DM_LOCATION_BATTLE,0,scard.powtg)
	--get ability (double breaker)
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER,nil,DM_LOCATION_BATTLE,0,scard.dbtg)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_CHIMERA,DM_RACE_ARMORLOID}
--power up
function scard.powtg(e,c)
	return c~=e:GetHandler() and c:DMIsRace(DM_RACE_CHIMERA,DM_RACE_ARMORLOID)
end
--get ability (double breaker)
function scard.dbtg(e,c)
	return c:IsFaceup() and c:DMIsRace(DM_RACE_CHIMERA,DM_RACE_ARMORLOID)
end
