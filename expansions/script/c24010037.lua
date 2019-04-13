--Pinpoint Lunatron
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--return
	dm.EnableSilentSkill(c,0,scard.rettg,scard.retop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.retfilter1(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function scard.chkcfilter(c)
	return scard.retfilter1(c)
		or Duel.IsExistingTarget(dm.ManaZoneFilter(Card.IsAbleToHand),0,DM_LOCATION_MANA,DM_LOCATION_MANA,1,nil)
end
function scard.retfilter2(c,e)
	return scard.retfilter1(c) and c:IsCanBeEffectTarget(e)
end
function scard.retfilter3(c,e)
	return c:IsAbleToHand() and c:IsCanBeEffectTarget(e)
end
function scard.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(DM_LOCATION_BATTLE+DM_LOCATION_MANA) and scard.chkcfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(scard.retfilter1,tp,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,1,nil)
		or Duel.IsExistingTarget(dm.ManaZoneFilter(Card.IsAbleToHand),tp,DM_LOCATION_MANA,DM_LOCATION_MANA,1,nil) end
	local g1=Duel.GetMatchingGroup(scard.retfilter2,tp,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,nil,e)
	local g2=Duel.GetMatchingGroup(dm.ManaZoneFilter(scard.retfilter3),tp,DM_LOCATION_MANA,DM_LOCATION_MANA,nil,e)
	g1:Merge(g2)
	if g1:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_RTOHAND)
	local sg=g1:Select(tp,1,1,nil)
	Duel.SetTargetCard(sg)
end
scard.retop=dm.TargetSendtoHandOperation()
