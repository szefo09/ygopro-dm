--Crystal Jouster
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_LIQUID_PEOPLE))
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--destroy replace (return)
	dm.AddSingleReplaceEffectDestroy(c,0,scard.reptg,scard.repop)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_LIQUID_PEOPLE}
scard.reptg=dm.SingleReplaceDestroyTarget(Card.IsAbleToHand)
scard.repop=dm.SingleReplaceDestroyOperation(Duel.SendtoHand,PLAYER_OWNER,REASON_EFFECT+REASON_REPLACE)
