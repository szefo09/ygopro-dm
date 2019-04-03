--Ice Vapor, Shadow of Anguish
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--discard & to grave
	dm.AddPlayerCastSpellEffect(c,0,PLAYER_OPPO,nil,nil,scard.dhop,nil,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.dhop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,DM_HINTMSG_DISCARD)
	local g1=Duel.SelectMatchingCard(1-tp,Card.IsCanBeEffectTarget,1-tp,LOCATION_HAND,0,1,1,nil,e)
	if g1:GetCount()>0 then
		Duel.DMSendtoGrave(g1,REASON_EFFECT+REASON_DISCARD)
	end
	Duel.Hint(HINT_SELECTMSG,1-tp,DM_HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(1-tp,dm.ManaZoneFilter(Card.IsCanBeEffectTarget),1-tp,LOCATION_MANA,0,1,1,nil,e)
	if g2:GetCount()>0 then
		Duel.DMSendtoGrave(g2,REASON_EFFECT)
	end
end
