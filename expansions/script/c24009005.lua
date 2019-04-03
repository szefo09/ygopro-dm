--Vreemah, Freaky Mojo Totem
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--get ability
	dm.AddComeIntoPlayEffect(c,0,nil,nil,scard.abop,nil,scard.abcon)
end
scard.duel_masters_card=true
function scard.cfilter(c,tp)
	return c:IsFaceup() and c:GetSummonPlayer()==tp
end
function scard.abcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(scard.cfilter,1,e:GetHandler(),tp)
end
function scard.abfilter(c)
	return c:IsFaceup() and c:DMIsRace(DM_RACE_BEAST_FOLK)
end
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(scard.abfilter,tp,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,nil)
	if g:GetCount()==0 then return end
	for tc in aux.Next(g) do
		--power up
		dm.RegisterEffectUpdatePower(c,tc,1,2000)
		--double breaker
		dm.RegisterEffectBreaker(c,tc,2,DM_EFFECT_DOUBLE_BREAKER)
	end
end