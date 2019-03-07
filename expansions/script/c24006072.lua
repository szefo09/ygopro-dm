--Armored Scout Gestuchar
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--power attacker
	dm.EnablePowerAttacker(c,3000,scard.abcon)
	dm.AddEffectDescription(c,0,scard.abcon)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER,scard.abcon)
	dm.AddEffectDescription(c,1,scard.abcon)
end
scard.duel_masters_card=true
function scard.cfilter(c)
	return c:IsFaceup() and c:IsCivilization(DM_CIVILIZATION_FIRE)
end
function scard.abcon(e)
	return not Duel.IsExistingMatchingCard(scard.cfilter,e:GetHandlerPlayer(),DM_LOCATION_BATTLE,0,1,e:GetHandler())
end
