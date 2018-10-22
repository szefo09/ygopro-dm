--Shtra
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--return
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,scard.retop,DM_EFFECT_FLAG_CARD_CHOOSE)
end
scard.duel_masters_card=true
function scard.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_RTOHAND)
	local g1=Duel.SelectMatchingCard(tp,dm.ManaZoneFilter(),tp,DM_LOCATION_MANA,0,1,1,nil)
	if g1:GetCount()>0 then
		Duel.SendtoHand(g1,PLAYER_OWNER,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,1-tp,DM_HINTMSG_RTOHAND)
	local g2=Duel.SelectMatchingCard(1-tp,dm.ManaZoneFilter(Card.IsCanBeEffectTarget),1-tp,DM_LOCATION_MANA,0,1,1,nil,e)
	if g2:GetCount()==0 then return end
	Duel.SetTargetCard(g2)
	Duel.SendtoHand(g2,PLAYER_OWNER,REASON_EFFECT)
	Duel.ConfirmCards(tp,g2)
end
