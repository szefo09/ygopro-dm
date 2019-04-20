--Armored Decimator Valkaizer
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_HUMAN))
	--destroy
	dm.AddSingleComeIntoPlayEffect(c,0,true,scard.destg,scard.desop)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_HUMAN}
function scard.desfilter(c)
	return c:IsFaceup() and c:IsPowerBelow(4000)
end
scard.destg=dm.CheckCardFunction(scard.desfilter,0,DM_LOCATION_BATTLE)
scard.desop=dm.DestroyOperation(PLAYER_SELF,scard.desfilter,0,DM_LOCATION_BATTLE,1)
