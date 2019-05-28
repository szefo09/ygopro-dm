--Royal Durian
--Not fully implemented: YGOPro makes all cards under an evolution creature leave the battle zone
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--to mana
	dm.AddSingleComeIntoPlayTriggerEffect(c,0,nil,nil,scard.tmop)
end
scard.duel_masters_card=true
function scard.tmfilter(c)
	return c:IsFaceup() and c:IsEvolution() and c:IsHasSource() and c:IsAbleToMana()
end
function scard.tmop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(scard.tmfilter,tp,DM_LOCATION_BZONE,DM_LOCATION_BZONE,nil)
	if g1:GetCount()==0 then return end
	for tc1 in aux.Next(g1) do
		local mg=tc1:GetSourceGroup()
		local pos=tc1:GetPosition()
		local seq=tc1:GetSequence()
		local g2=Group.CreateGroup()
		for mc in aux.Next(mg) do
			g2:AddCard(mc)
		end
		Duel.SendtoMana(tc1,POS_FACEUP_UNTAPPED,REASON_EFFECT)
		--workaround to keep stacked pile
		local tc2=g2:GetFirst()
		Duel.MoveToField(tc2,tp,tc1:GetControler(),DM_LOCATION_BZONE,pos,true)
		g2:RemoveCard(tc2)
		Duel.MoveSequence(tc2,seq)
		if g2:GetCount()>0 then
			Duel.PutOnTop(tc2,g2)
		end
	end
end
