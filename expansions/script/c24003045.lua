--Aurora of Reversal
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--to mana
	dm.AddSpellCastEffect(c,0,nil,scard.tmop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.tmfilter(c,e)
	return c:IsAbleToMana() and c:IsCanBeEffectTarget(e)
end
function scard.tmop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(dm.ShieldZoneFilter(scard.tmfilter),tp,DM_LOCATION_SHIELD,0,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOMANA)
	local g=Duel.SelectMatchingCard(tp,dm.ShieldZoneFilter(scard.tmfilter),tp,DM_LOCATION_SHIELD,0,0,ct,nil,e)
	if g:GetCount()==0 then return end
	Duel.SetTargetCard(g)
	Duel.SendtoMana(g,POS_FACEUP_UNTAPPED,REASON_EFFECT)
end
