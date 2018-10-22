--Ghastly Drain
--Not fully implemented (YGOPro allows players to view their face-down cards)
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--return
	dm.AddSpellCastEffect(c,0,scard.rettg,scard.retop,DM_EFFECT_FLAG_CARD_CHOOSE)
end
scard.duel_masters_card=true
function scard.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(DM_LOCATION_SHIELD) and chkc:IsControler(tp) end
	if chk==0 then return true end
	--Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOGRAVE)
	--local g=Duel.SelectTarget(tp,dm.ShieldZoneFilter(),tp,DM_LOCATION_SHIELD,0,1,1,nil)
	local g=Duel.GetMatchingGroup(dm.ShieldZoneFilter(Card.IsCanBeEffectTarget),tp,DM_LOCATION_SHIELD,0,nil,e)
	local ct=g:GetCount()
	if ct==0 or not Duel.SelectYesNo(tp,DM_QHINTMSG_SELECT) then return end
	repeat
		local sg=g:RandomSelect(tp,1) --changed to random because face-down cards can be viewed
		Duel.SetTargetCard(sg)
		g:Sub(sg)
		ct=ct-1
	until ct==0 or not Duel.SelectYesNo(tp,DM_QHINTMSG_SELECTEXTRA)
end
scard.retop=dm.ChooseSendtoHandOperation()
