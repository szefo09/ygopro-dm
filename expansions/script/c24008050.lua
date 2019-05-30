--Muscle Charger
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--get ability
	dm.AddSpellCastEffect(c,0,nil,scard.abop)
	--charger
	dm.EnableEffectCustom(c,DM_EFFECT_CHARGER)
end
scard.duel_masters_card=true
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,DM_LOCATION_BZONE,0,nil)
	if g:GetCount()==0 then return end
	for tc in aux.Next(g) do
		--power up
		dm.RegisterEffectUpdatePower(e:GetHandler(),tc,1,3000)
	end
end
