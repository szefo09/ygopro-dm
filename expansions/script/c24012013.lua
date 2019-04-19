--Mechadragon's Breath
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--destroy
	dm.AddSpellCastEffect(c,0,nil,scard.desop)
end
scard.duel_masters_card=true
function scard.cfilter(c)
	return c:IsFaceup() and c:IsPowerBelow(6000)
end
function scard.desfilter(c,pwr)
	return c:IsFaceup() and c:IsPower(pwr)
end
function scard.desop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(scard.cfilter,tp,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,nil)
	if g1:GetCount()==0 then return end
	local t={}
	for tc in aux.Next(g1) do
		if table.unpack(t)~=tc:GetPower() then table.insert(t,tc:GetPower()) end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NUMBER)
	local pwr=Duel.AnnounceNumber(tp,table.unpack(t))
	local g2=Duel.GetMatchingGroup(scard.desfilter,tp,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,nil,pwr)
	Duel.Destroy(g2,REASON_EFFECT)
end
