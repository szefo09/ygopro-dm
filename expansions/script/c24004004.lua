--Doboulgyser, Giant Rock Beast
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_ROCK_BEAST))
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--destroy
	dm.AddSingleComeIntoPlayEffect(c,0,true,scard.destg,scard.desop)
end
scard.duel_masters_card=true
function scard.desfilter(c)
	return c:IsFaceup() and c:IsPowerBelow(3000)
end
scard.destg=dm.CheckCardFunction(scard.desfilter,0,DM_LOCATION_BATTLE)
scard.desop=dm.DestroyOperation(PLAYER_PLAYER,scard.desfilter,0,DM_LOCATION_BATTLE,1)
