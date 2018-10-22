--Darkpact
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--draw
	dm.AddSpellCastEffect(c,0,nil,scard.drop)
end
scard.duel_masters_card=true
function scard.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetMatchingGroupCount(dm.ManaZoneFilter(),tp,DM_LOCATION_MANA,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,dm.ManaZoneFilter(),tp,DM_LOCATION_MANA,0,0,ct1,nil)
	if g:GetCount()==0 then return end
	local ct2=Duel.SendtoDMGrave(g,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Draw(tp,ct2,REASON_EFFECT)
end
