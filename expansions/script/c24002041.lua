--Galsaur
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--get ability (power attacker)
	dm.EnablePowerAttacker(c,4000,scard.abcon)
	dm.AddEffectDescription(c,0,scard.abcon)
	--get ability (double breaker)
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER,scard.abcon)
	dm.AddEffectDescription(c,1,scard.abcon)
end
scard.duel_masters_card=true
function scard.abcon(e)
	return not Duel.IsExistingMatchingCard(nil,e:GetHandlerPlayer(),DM_LOCATION_BATTLE,0,1,e:GetHandler())
end
