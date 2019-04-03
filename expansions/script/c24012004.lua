--Punch Trooper Bronks
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--destroy
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,scard.desop)
end
scard.duel_masters_card=true
function scard.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,nil)
	if g:GetCount()==0 then return end
	local tg=g:GetMinGroup(Card.GetPower)
	if tg:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_DESTROY)
		local sg=tg:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	else Duel.Destroy(tg,REASON_EFFECT) end
end
