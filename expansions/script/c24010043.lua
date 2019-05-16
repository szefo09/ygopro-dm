--Transmogrify
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--destroy, confirm (to battle, to grave)
	dm.AddSpellCastEffect(c,0,nil,scard.desop)
end
scard.duel_masters_card=true
function scard.tbfilter(c,e,tp)
	return c:IsCreature() and not c:IsEvolution() and c:IsCanSendtoBattle(e,0,tp,false,false)
end
function scard.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_DESTROY)
	local g1=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,0,1,nil)
	if g1:GetCount()==0 then return end
	Duel.HintSelection(g1)
	if Duel.Destroy(g1,REASON_EFFECT)==0 then return end
	local p=g1:GetFirst():GetOwner()
	local g2=Duel.GetMatchingGroup(scard.tbfilter,p,LOCATION_DECK,0,nil,e,p)
	local dcount=Duel.GetFieldGroupCount(p,LOCATION_DECK,0)
	if dcount==0 then return end
	local seq=-1
	local tbcard=nil
	for tc in aux.Next(g2) do
		if tc:GetSequence()>seq then
			seq=tc:GetSequence()
			tbcard=tc
		end
	end
	if seq==-1 then
		Duel.ConfirmDecktop(p,dcount)
		Duel.DMSendDecktoptoGrave(p,dcount-seq,REASON_EFFECT)
		return
	end
	Duel.ConfirmDecktop(p,dcount-seq)
	if tbcard:IsCanSendtoBattle(e,0,p,false,false) then
		Duel.DisableShuffleCheck()
		if dcount-seq==1 then Duel.SendtoBattle(tbcard,0,p,p,false,false,POS_FACEUP_UNTAPPED)
		else
			Duel.SendtoBattleStep(tbcard,0,p,p,false,false,POS_FACEUP_UNTAPPED)
			Duel.DMSendDecktoptoGrave(p,dcount-seq-1,REASON_EFFECT)
			Duel.SendtoBattleComplete()
		end
	else Duel.DMSendDecktoptoGrave(p,dcount-seq,REASON_EFFECT) end
end
--[[
	References
		1. Monster Gate
		https://github.com/Fluorohydride/ygopro-scripts/blob/6418030/c43040603.lua#L26
]]
