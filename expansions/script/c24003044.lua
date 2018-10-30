--Volcanic Arrows
--Not fully implemented: YGOPro allows players to view their face-down cards
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--destroy & to grave
	dm.AddSpellCastEffect(c,0,nil,scard.desop,DM_EFFECT_FLAG_CARD_CHOOSE)
	dm.AddShieldTriggerCastEffect(c,0,nil,scard.desop,DM_EFFECT_FLAG_CARD_CHOOSE)
end
scard.duel_masters_card=true
function scard.desfilter(c)
	return c:IsFaceup() and c:IsPowerBelow(6000)
end
function scard.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_DESTROY)
	local g1=Duel.SelectMatchingCard(tp,scard.desfilter,tp,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,1,1,nil)
	if g1:GetCount()>0 then
		Duel.HintSelection(g1)
		Duel.Destroy(g1,REASON_EFFECT)
	end
	--Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOGRAVE)
	--local g2=Duel.SelectMatchingCard(tp,dm.ShieldZoneFilter(Card.IsCanBeEffectTarget),tp,DM_LOCATION_SHIELD,0,1,1,nil,e)
	--changed to random because face-down cards can be viewed
	local g2=Duel.GetMatchingGroup(dm.ShieldZoneFilter(Card.IsCanBeEffectTarget),tp,DM_LOCATION_SHIELD,0,nil,e):RandomSelect(tp,1)
	if g2:GetCount()==0 then return end
	Duel.SetTargetCard(g2)
	Duel.SendtoDMGrave(g2,REASON_EFFECT)
end
