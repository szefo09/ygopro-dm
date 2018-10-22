--Hydro Hurricane
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--return
	dm.AddSpellCastEffect(c,0,nil,scard.retop,DM_EFFECT_FLAG_CARD_CHOOSE)
end
scard.duel_masters_card=true
function scard.cfilter(c,civ)
	return c:IsFaceup() and c:IsCivilization(civ)
end
function scard.retop(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetMatchingGroupCount(scard.cfilter,tp,DM_LOCATION_BATTLE,0,nil,DM_CIVILIZATION_LIGHT)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_RTOHAND)
	local g1=Duel.SelectMatchingCard(tp,dm.ManaZoneFilter(Card.IsCanBeEffectTarget),tp,0,DM_LOCATION_MANA,0,ct1,nil,e)
	if g1:GetCount()>0 then
		Duel.SetTargetCard(g1)
		Duel.SendtoHand(g1,PLAYER_OWNER,REASON_EFFECT)
		Duel.ConfirmCards(tp,g1)
	end
	local ct2=Duel.GetMatchingGroupCount(scard.cfilter,tp,DM_LOCATION_BATTLE,0,nil,DM_CIVILIZATION_DARKNESS)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_RTOHAND)
	local g2=Duel.SelectMatchingCard(tp,Card.IsCanBeEffectTarget,tp,0,DM_LOCATION_BATTLE,0,ct2,nil,e)
	if g2:GetCount()==0 then return end
	Duel.SetTargetCard(g2)
	Duel.SendtoHand(g2,PLAYER_OWNER,REASON_EFFECT)
end
