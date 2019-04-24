--予言者ポラリス
--Polaris, the Oracle
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--get ability
	dm.AddBeAttackedEffect(c,0,nil,nil,scard.abop,nil,scard.abcon)
end
scard.duel_masters_card=true
function scard.abcon(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	return d:IsFaceup() and d:IsControler(tp)
end
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.GetAttackTarget()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or not d:IsRelateToBattle() or d:IsFacedown() then return end
	--power up
	dm.RegisterEffectUpdatePower(c,d,1,2000,0,0)
end