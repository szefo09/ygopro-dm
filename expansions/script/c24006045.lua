--Shock Hurricane
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--return
	dm.AddSpellCastEffect(c,0,nil,scard.retop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.retfilter1(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function scard.retfilter2(c,e)
	return scard.retfilter1(c) and c:IsCanBeEffectTarget(e)
end
function scard.retop(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetMatchingGroupCount(scard.retfilter1,tp,DM_LOCATION_BATTLE,0,nil)
	local ct2=0
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_RTOHAND)
	local g1=Duel.SelectMatchingCard(tp,scard.retfilter1,tp,DM_LOCATION_BATTLE,0,0,ct1,nil)
	if g1:GetCount()>0 then
		Duel.HintSelection(g1)
		ct2=Duel.SendtoHand(g1,PLAYER_OWNER,REASON_EFFECT)
	end
	local g2=Duel.GetMatchingGroup(scard.retfilter2,tp,0,DM_LOCATION_BATTLE,nil,e)
	if ct2>g2:GetCount() or g2:GetCount()==0 or not Duel.SelectYesNo(tp,DM_QHINTMSG_RTOHAND) then return end
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_RTOHAND)
	local sg=g2:Select(tp,ct2,ct2,nil)
	if sg:GetCount()==0 then return end
	Duel.SetTargetCard(sg)
	Duel.SendtoHand(sg,PLAYER_OWNER,REASON_EFFECT)
end
