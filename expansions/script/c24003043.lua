--Überdragon Jabaha
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_ARMORED_DRAGON))
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--get ability (power attacker)
	dm.AddStaticEffectPowerAttacker(c,2000,DM_LOCATION_BATTLE,0,scard.patg)
end
scard.duel_masters_card=true
function scard.patg(e,c)
	return c~=e:GetHandler()
end
