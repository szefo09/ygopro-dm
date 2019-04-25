--Rapid Reincarnation
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--destroy & to battle
	dm.AddSpellCastEffect(c,0,nil,scard.desop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.tbfilter(c,e,tp,cost)
	return c:IsCreature() and c:IsManaCostBelow(cost)
		and c:IsCanSendtoBattle(e,0,tp,false,false) and c:IsCanBeEffectTarget(e)
end
function scard.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_DESTROY)
	local g1=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,DM_LOCATION_BATTLE,0,0,1,nil)
	if g1:GetCount()==0 then return end
	Duel.HintSelection(g1)
	if Duel.Destroy(g1,REASON_EFFECT)==0 then return end
	local cost=Duel.GetManaCount(tp)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOBATTLE)
	local g2=Duel.SelectMatchingCard(tp,scard.tbfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,cost)
	if g2:GetCount()==0 then return end
	Duel.SetTargetCard(g2)
	Duel.SendtoBattle(g2,0,tp,tp,false,false,POS_FACEUP_UNTAPPED)
end
