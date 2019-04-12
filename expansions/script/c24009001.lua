--Glena Vuele, the Hypnotic
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_GUARDIAN))
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--to shield
	dm.AddPlayerUseShieldTriggerEffect(c,0,PLAYER_OPPO,true,scard.tstg,scard.tsop)
end
scard.duel_masters_card=true
scard.tstg=dm.CheckDeckFunction(PLAYER_SELF)
function scard.tsop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	Duel.SendDecktoptoShield(tp,1)
end
