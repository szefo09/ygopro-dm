--Urth, Purifying Elemental
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--untap
	dm.EnableTurnEndSelfUntap(c)
end
scard.duel_masters_card=true
