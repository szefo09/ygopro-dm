--Mega Detonator
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--get ability
	dm.AddSpellCastEffect(c,0,nil,scard.abop)
end
scard.duel_masters_card=true
function scard.abfilter(c,e)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	g1:RemoveCard(e:GetHandler())
	local ct=Duel.DiscardHand(tp,nil,0,g1:GetCount(),REASON_EFFECT,e:GetHandler())
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_CHOOSE)
	local g2=Duel.SelectMatchingCard(tp,scard.abfilter,tp,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,ct,ct,nil,e)
	if g2:GetCount()==0 then return end
	Duel.SetTargetCard(g2)
	for tc in aux.Next(g2) do
		--double breaker
		dm.GainEffectBreaker(e:GetHandler(),tc,1,DM_EFFECT_DOUBLE_BREAKER)
	end
end
