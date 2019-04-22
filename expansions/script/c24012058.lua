--Cruel Naga, Avatar of Fate
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--vortex evolution
	dm.EnableEffectCustom(c,DM_EFFECT_VORTEX_EVOLUTION)
	dm.AddEvolutionProcedure(c,scard.evofilter1,scard.evofilter2)
	--cannot be blocked
	dm.EnableCannotBeBlocked(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--destroy
	dm.AddSingleLeaveBattleEffect(c,0,nil,nil,dm.DestroyOperation(nil,Card.IsFaceup,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE))
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_MERFOLK,DM_RACE_CHIMERA}
scard.evofilter1=aux.FilterBoolFunction(Card.DMIsRace,DM_RACE_MERFOLK)
scard.evofilter2=aux.FilterBoolFunction(Card.DMIsRace,DM_RACE_CHIMERA)
