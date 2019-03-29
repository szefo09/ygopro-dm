--Emeral
--Not fully implemented: YGOPro allows players to view their face-down cards
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to shield & to hand
	dm.AddSingleComeIntoPlayEffect(c,0,true,scard.tstg,scard.tsop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
scard.tstg=dm.CheckCardFunction(Card.IsAbleToShield,LOCATION_HAND,0)
function scard.thfilter(c,e)
	return c:IsAbleToHand() and c:IsCanBeEffectTarget(e)
end
function scard.tsop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOSHIELD)
	local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToShield,tp,LOCATION_HAND,0,1,1,nil)
	if g1:GetCount()==0 or not Duel.SendtoShield(g1,tp) then return end
	--Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_ATOHAND)
	--local g2=Duel.SelectMatchingCard(tp,dm.ShieldZoneFilter(scard.thfilter),tp,DM_LOCATION_SHIELD,0,1,1,nil,e)
	--if g2:GetCount()==0 then return end
	--Duel.SetTargetCard(g2)
	--changed to random because face-down cards can be viewed
	local g2=Duel.GetMatchingGroup(dm.ShieldZoneFilter(scard.thfilter),tp,DM_LOCATION_SHIELD,0,nil,e):RandomSelect(tp,1)
	if g2:GetCount()==0 then return end
	Duel.SetTargetCard(g2)
	Duel.SendtoHand(g2,PLAYER_OWNER,REASON_EFFECT)
end
