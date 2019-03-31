--Sol Galla, Halo Guardian
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--get ability
	dm.AddPlayerCastSpellEffect(c,0,nil,nil,nil,scard.abop)
end
scard.kaijudo_card=true
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	--powe up
	dm.RegisterEffectUpdatePower(c,c,1,3000)
end
