--Wingeye Moth
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--draw
	dm.AddEventDrawEffect(c,0,true,dm.DrawTarget(PLAYER_SELF),dm.DrawOperation(PLAYER_SELF,1),nil,scard.drcon)
end
scard.duel_masters_card=true
function scard.drcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,nil)
	if g:GetCount()==0 then return false end
	local tg=g:GetMaxGroup(Card.GetPower)
	return ep==tp and r==REASON_RULE and tg:IsExists(Card.IsControler,1,nil,tp)
end
--[[
	References
		1. Double Cipher
		https://github.com/Fluorohydride/ygopro-scripts/blob/51d2a9e/c63992027.lua#L17
]]
