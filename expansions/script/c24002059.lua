--Armored Blaster Valdios
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_HUMAN))
	--power up
	dm.EnableUpdatePower(c,1000,nil,DM_LOCATION_BZONE,0,scard.powtg)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_HUMAN}
function scard.powtg(e,c)
	return c~=e:GetHandler() and c:DMIsRace(DM_RACE_HUMAN)
end
