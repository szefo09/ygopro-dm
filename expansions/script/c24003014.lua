--Emeral
--Not fully implemented (YGOPro allows players to view their face-down cards)
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to shield & to hand
	dm.AddSingleComeIntoPlayEffect(c,0,true,scard.tstg,scard.tsop,DM_EFFECT_FLAG_CARD_CHOOSE)
end
scard.duel_masters_card=true
function scard.tstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,1,nil) end
end
function scard.tsop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOSHIELD)
	local g1=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND,0,1,1,nil)
	if g1:GetCount()==0 then return end
	if not Duel.SendtoShield(g1,tp) then return end
	--Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_RTOHAND)
	--local g2=Duel.SelectMatchingCard(tp,dm.ShieldZoneFilter(Card.IsCanBeEffectTarget),tp,DM_LOCATION_SHIELD,0,1,1,nil,e)
	--if g2:GetCount()==0 then return end
	--Duel.SetTargetCard(g2)
	--changed to random because face-down cards can be viewed
	local g2=Duel.GetMatchingGroup(dm.ShieldZoneFilter(Card.IsCanBeEffectTarget),tp,DM_LOCATION_SHIELD,0,nil,e):RandomSelect(tp,1)
	if g2:GetCount()==0 then return end
	Duel.SetTargetCard(g2)
	Duel.SendtoHand(g2,PLAYER_OWNER,REASON_EFFECT)
end
