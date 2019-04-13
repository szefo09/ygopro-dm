--Spinal Parasite
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--get ability
	dm.AddTurnStartEffect(c,0,PLAYER_OPPO,nil,scard.abtg,scard.abop,nil,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.abfilter(c)
	return c:IsFaceup() and c:IsCanAttack()
end
scard.abtg=dm.TargetCardFunction(PLAYER_OPPO,scard.abfilter,0,DM_LOCATION_BATTLE,1,1,DM_HINTMSG_TARGET)
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	--attack if able
	dm.RegisterEffectCustom(c,tc,1,EFFECT_MUST_ATTACK)
end
