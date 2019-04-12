--Carnival Totem
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--return & to mana
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,scard.retop)
end
scard.duel_masters_card=true
function scard.retop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(dm.ManaZoneFilter(Card.IsAbleToHand),tp,DM_LOCATION_MANA,0,nil)
	if g1:GetCount()==0 or Duel.SendtoHand(g1,PLAYER_OWNER,REASON_EFFECT)==0 then return end
	local g2=Duel.GetMatchingGroup(Card.IsAbleToMana,tp,LOCATION_HAND,0,nil)
	g2:Sub(Duel.GetOperatedGroup())
	if g2:GetCount()==0 then return end
	Duel.SendtoMana(g2,POS_FACEUP_TAPPED,REASON_EFFECT)
end
