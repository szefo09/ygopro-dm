--Missile Soldier Ultimo
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--turbo rush
	dm.EnableTurboRush(c,0,scard.abop)
end
scard.duel_masters_card=true
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	--attack untapped
	dm.RegisterEffectCustom(c,c,1,DM_EFFECT_ATTACK_UNTAPPED)
	--power attacker
	dm.RegisterEffectPowerAttacker(c,c,2,4000)
end
