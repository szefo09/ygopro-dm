--Aurora of Reversal
--Not fully implemented: YGOPro allows players to view their face-down cards
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--to mana
	dm.AddSpellCastEffect(c,0,nil,scard.tmop,DM_EFFECT_FLAG_CARD_CHOOSE)
end
scard.duel_masters_card=true
function scard.tmop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(dm.ShieldZoneFilter(),tp,DM_LOCATION_SHIELD,0,nil)
	--Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOMANA)
	--local g=Duel.SelectMatchingCard(tp,dm.ShieldZoneFilter(Card.IsCanBeEffectTarget),tp,DM_LOCATION_SHIELD,0,1,ct,nil,e)
	--if g:GetCount()==0 then return end
	--Duel.SetTargetCard(g)
	--Duel.SendtoMana(g,POS_FACEUP_UNTAPPED,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(dm.ShieldZoneFilter(Card.IsCanBeEffectTarget),tp,DM_LOCATION_SHIELD,0,nil,e)
	if ct==0 or not Duel.SelectYesNo(tp,DM_QHINTMSG_SELECT) then return end
	local mg=Group.CreateGroup()
	repeat
		local sg=g:RandomSelect(tp,1) --changed to random because face-down cards can be viewed
		Duel.SetTargetCard(sg)
		g:Sub(sg)
		mg:Merge(sg)
		ct=ct-1
	until ct==0 or not Duel.SelectYesNo(tp,DM_QHINTMSG_SELECTEXTRA)
	Duel.SendtoMana(mg,POS_FACEUP_UNTAPPED,REASON_EFFECT)
end
