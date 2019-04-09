--Pangaea's Will
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--to grave
	dm.AddSpellCastEffect(c,0,scard.tgtg,scard.tgop,EFFECT_FLAG_CARD_TARGET)
	dm.AddShieldTriggerCastEffect(c,0,scard.tgtg,scard.tgop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.tgfilter(c)
	return c:IsFaceup() and c:IsEvolution() and c:GetStackCount()>0 and c:DMIsAbleToGrave()
end
scard.tgtg=dm.TargetCardFunction(PLAYER_SELF,scard.tgfilter,0,DM_LOCATION_BATTLE,1,1,DM_HINTMSG_TOGRAVE)
function scard.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFirstTarget()
	local mg=tc1:GetStackGroup()
	local pos=tc1:GetPosition()
	local seq=tc1:GetSequence()
	if not tc1:IsRelateToEffect(e) or mg:GetCount()==0 then return end
	local g=Group.CreateGroup()
	for mc in aux.Next(mg) do
		g:AddCard(mc)
	end
	Duel.DMSendtoGrave(tc1,REASON_EFFECT)
	--workaround to keep stacked pile
	local tc2=g:GetFirst()
	Duel.MoveToField(tc2,tp,1-tp,DM_LOCATION_BATTLE,pos,true)
	g:RemoveCard(tc2)
	Duel.MoveSequence(tc2,seq)
	if g:GetCount()>0 then
		Duel.PutOnTop(tc2,g)
	end
end
