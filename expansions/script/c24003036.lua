--Blaze Cannon
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--get ability
	dm.AddSpellCastEffect(c,0,nil,scard.abop,nil,nil,dm.ManaExclusiveCondition(Card.IsCivilization,DM_CIVILIZATION_FIRE))
end
scard.duel_masters_card=true
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,DM_LOCATION_BATTLE,0,nil)
	if g:GetCount()==0 then return end
	for tc in aux.Next(g) do
		--power attacker
		dm.RegisterEffectPowerAttacker(e:GetHandler(),tc,1,4000)
		--double breaker
		dm.RegisterEffectBreaker(e:GetHandler(),tc,2,DM_EFFECT_DOUBLE_BREAKER)
	end
end
