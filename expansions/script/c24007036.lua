--Apocalypse Vise
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--destroy
	dm.AddSpellCastEffect(c,0,nil,scard.desop)
end
scard.duel_masters_card=true
function scard.desfilter(c,pwr)
	return c:IsFaceup() and c:IsPowerAbove(0) and c:IsPowerBelow(pwr)
end
function scard.desop(e,tp,eg,ep,ev,re,r,rp)
	local pwr=8000
	local g=Duel.GetMatchingGroup(scard.desfilter,tp,0,DM_LOCATION_BATTLE,nil,pwr)
	local dg=Group.CreateGroup()
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_DESTROY)
		local tc=g:Select(tp,0,1,nil):GetFirst()
		if not tc then break end
		Duel.HintSelection(Group.FromCards(tc))
		dg:AddCard(tc)
		g:RemoveCard(tc)
		pwr=pwr-tc:GetPower()
		g=g:Filter(scard.desfilter,nil,pwr)
	until pwr<=0 or g:GetCount()==0
	Duel.Destroy(dg,REASON_EFFECT)
end
--[[
	References
		1. Ninjitsu Art of Duplication
		https://github.com/Fluorohydride/ygopro-scripts/blob/db63e8c7f254c0d7e528f3a3a47203973ece3a57/c50766506.lua#L41
]]
