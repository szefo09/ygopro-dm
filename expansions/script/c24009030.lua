--Ice Vapor, Shadow of Anguish
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--discard, to grave
	dm.AddPlayerCastSpellEffect(c,0,PLAYER_OPPO,nil,nil,nil,scard.dhop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.dhfilter(c,e)
	return c:IsCanBeEffectTarget(e)
end
function scard.tgfilter(c,e)
	return c:DMIsAbleToGrave() and c:IsCanBeEffectTarget(e)
end
function scard.dhop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,DM_HINTMSG_DISCARD)
	local g1=Duel.SelectMatchingCard(1-tp,scard.dhfilter,1-tp,LOCATION_HAND,0,1,1,nil,e)
	if g1:GetCount()>0 then
		Duel.SetTargetCard(g1)
		Duel.DMSendtoGrave(g1,REASON_EFFECT+REASON_DISCARD)
	end
	Duel.Hint(HINT_SELECTMSG,1-tp,DM_HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(1-tp,dm.ManaZoneFilter(scard.tgfilter),1-tp,DM_LOCATION_MANA,0,1,1,nil,e)
	if g2:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SetTargetCard(g2)
		Duel.DMSendtoGrave(g2,REASON_EFFECT)
	end
end
