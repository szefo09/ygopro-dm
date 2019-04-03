--Zero Nemesis, Shadow of Panic
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_GHOST))
	--discard
	dm.AddAttackTriggerEffect(c,0,nil,nil,scard.dhop,nil,scard.dhcon)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
function scard.dhcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(tp)
end
scard.dhop=dm.DiscardOperation(PLAYER_OPPO,aux.TRUE,0,LOCATION_HAND,1,1,true)
