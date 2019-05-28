--Punch Trooper Bronks
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--destroy
	dm.AddSingleComeIntoPlayTriggerEffect(c,0,nil,nil,scard.desop)
end
scard.duel_masters_card=true
function scard.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,DM_LOCATION_BZONE,DM_LOCATION_BZONE,nil)
	if g:GetCount()==0 then return end
	local dg=g:GetMinGroup(Card.GetPower)
	if dg:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_DESTROY)
		local sg=dg:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	else
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
