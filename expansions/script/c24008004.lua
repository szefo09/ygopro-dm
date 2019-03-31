--Magmadragon Jagalzor
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--turbo rush (get ability)
	dm.EnableTurboRush(c,0,scard.abop)
end
scard.kaijudo_card=true
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,DM_LOCATION_BATTLE,0,nil)
	if g:GetCount()==0 then return end
	for tc in aux.Next(g) do
		--speed attacker
		dm.RegisterEffectCustom(e:GetHandler(),tc,1,DM_EFFECT_SPEED_ATTACKER)
	end
end
