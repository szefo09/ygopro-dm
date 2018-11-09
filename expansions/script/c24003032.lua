--Snake Attack
--Not fully implemented: YGOPro allows players to view their face-down cards
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--get ability & to grave
	dm.AddSpellCastEffect(c,0,nil,scard.abop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.tgfilter(c,e)
	return c:IsAbleToDMGrave() and c:IsCanBeEffectTarget(e)
end
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,DM_LOCATION_BATTLE,0,nil)
	if g1:GetCount()>0 then
		for tc in aux.Next(g1) do
			--double breaker
			dm.GainEffectBreaker(e:GetHandler(),tc,1,DM_EFFECT_DOUBLE_BREAKER)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingShieldCard(tp,scard.tgfilter,tp,1,1,nil,e)
	if g2:GetCount()==0 then return end
	Duel.SetTargetCard(g2)
	Duel.SendtoDMGrave(g2,REASON_EFFECT)
end
