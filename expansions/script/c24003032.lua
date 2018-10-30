--Snake Attack
--Not fully implemented: YGOPro allows players to view their face-down cards
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--get ability & to grave
	dm.AddSpellCastEffect(c,0,nil,scard.abop,DM_EFFECT_FLAG_CARD_CHOOSE)
end
scard.duel_masters_card=true
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,DM_LOCATION_BATTLE,0,nil)
	if g1:GetCount()>0 then
		for tc in aux.Next(g1) do
			--double breaker
			dm.GainEffectBreaker(e:GetHandler(),tc,1,DM_EFFECT_DOUBLE_BREAKER)
		end
	end
	--Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOGRAVE)
	--local g2=Duel.SelectMatchingCard(tp,dm.ShieldZoneFilter(Card.IsCanBeEffectTarget),tp,DM_LOCATION_SHIELD,0,1,1,nil,e)
	--changed to random because face-down cards can be viewed
	local g2=Duel.GetMatchingGroup(dm.ShieldZoneFilter(Card.IsCanBeEffectTarget),tp,DM_LOCATION_SHIELD,0,nil,e):RandomSelect(tp,1)
	if g2:GetCount()==0 then return end
	Duel.SetTargetCard(g2)
	Duel.SendtoDMGrave(g2,REASON_EFFECT)
end
