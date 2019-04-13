--Mechadragon's Breath
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--destroy
	dm.AddSpellCastEffect(c,0,nil,scard.desop)
end
scard.duel_masters_card=true
function scard.desfilter(c,pwr)
	return c:IsFaceup() and c:IsPower(pwr)
end
function scard.desop(e,tp,eg,ep,ev,re,r,rp)
	local t={}
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,nil)
	for tc in aux.Next(g1) do
		table.insert(t,tc:GetPower())
	end
	if #t==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_NUMBER)
	local pwr=Duel.AnnounceNumber(tp,table.unpack(t))
	local g2=Duel.GetMatchingGroup(scard.desfilter,tp,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,nil,pwr)
	Duel.Destroy(g2,REASON_EFFECT)
end
