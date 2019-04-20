--Death Phoenix, Avatar of Doom
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--vortex evolution
	dm.EnableEffectCustom(c,DM_EFFECT_VORTEX_EVOLUTION)
	dm.AddEvolutionProcedure(c,scard.evofilter1,scard.evofilter2)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--break replace (to grave)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(DM_EFFECT_BREAK_SHIELD_REPLACE)
	e1:SetValue(DM_LOCATION_GRAVE)
	c:RegisterEffect(e1)
	--discard
	dm.AddSingleLeaveBattleEffect(c,0,nil,nil,dm.DiscardOperation(nil,aux.TRUE,0,LOCATION_HAND))
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_ZOMBIE_DRAGON,DM_RACE_DRAGON,DM_RACE_FIRE_BIRD}
scard.evofilter1=aux.FilterBoolFunction(Card.DMIsRace,DM_RACE_ZOMBIE_DRAGON)
scard.evofilter2=aux.FilterBoolFunction(Card.DMIsRace,DM_RACE_FIRE_BIRD)
