--King Triumphant
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--get ability
	dm.AddPlayerSummonCreatureEffect(c,0,PLAYER_OPPONENT,nil,nil,scard.abop)
	dm.AddPlayerCastSpellEffect(c,0,PLAYER_OPPONENT,nil,nil,scard.abop)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	--blocker
	dm.GainEffectBlocker(c,c,1)
end