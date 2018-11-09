--Rothus, the Traveler
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--destroy
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,scard.desop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.desfilter(c,e)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function scard.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_DESTROY)
	local g1=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,DM_LOCATION_BATTLE,0,1,1,nil)
	if g1:GetCount()>0 then
		Duel.HintSelection(g1)
		Duel.Destroy(g1,REASON_EFFECT)
	end
	Duel.Hint(HINT_SELECTMSG,1-tp,DM_HINTMSG_DESTROY)
	local g2=Duel.SelectMatchingCard(1-tp,scard.desfilter,1-tp,DM_LOCATION_BATTLE,0,1,1,nil,e)
	if g2:GetCount()==0 then return end
	Duel.SetTargetCard(g2)
	Duel.Destroy(g2,REASON_EFFECT)
end
