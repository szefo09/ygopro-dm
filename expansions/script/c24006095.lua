--Clobber Totem
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--power attacker
	dm.EnablePowerAttacker(c,2000)
	--cannot be blocked
	dm.EnableCannotBeBlocked(c,dm.CannotBeBlockedBoolFunction(Card.IsPowerBelow,5000))
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
