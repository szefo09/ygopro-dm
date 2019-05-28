--Dyno Mantis, the Mightspinner
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_GIANT_INSECT))
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--get ability (break extra shield)
	dm.EnableEffectCustom(c,DM_EFFECT_BREAK_EXTRA_SHIELD,nil,DM_LOCATION_BZONE,0,scard.abtg)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_GIANT_INSECT,DM_RACE_GIANT}
function scard.abtg(e,c)
	return c~=e:GetHandler() and c:IsPowerAbove(5000)
end
