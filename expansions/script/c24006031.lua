--Aqua Rider
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--get ability
	dm.AddPlayerSummonCreatureEffect(c,0,PLAYER_OPPONENT,nil,nil,scard.abop)
	dm.AddPlayerCastSpellEffect(c,0,PLAYER_OPPONENT,nil,nil,scard.abop)
end
scard.duel_masters_card=true
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	--blocker
	dm.RegisterEffectBlocker(c,c,1)
end
