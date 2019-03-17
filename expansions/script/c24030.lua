--緑神龍ハルクーンベルガ
--Terradragon Hulcoon Berga
--Not fully implemented: DEF~=ATK and ATK/DEF randomly changes during a turn
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--get ability (power attacker)
	dm.AddStaticEffectPowerAttacker(c,4000,DM_LOCATION_BATTLE,0,scard.abtg)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER,dm.SelfTappedCondition,DM_LOCATION_BATTLE,0,scard.abtg)
	--get ability
	dm.AddTurnEndEffect(c,1,nil,nil,nil,scard.powop,nil,dm.SelfTappedCondition,1)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER,scard.dbcon)
	dm.AddEffectDescription(c,2,scard.dbcon)
	--triple breaker
	dm.EnableBreaker(c,DM_EFFECT_TRIPLE_BREAKER,scard.tbcon)
	dm.AddEffectDescription(c,3,scard.tbcon)
end
scard.duel_masters_card=true
--get ability (power attacker) & double breaker
function scard.abtg(e,c)
	return c~=e:GetHandler()
end
--get ability
function scard.powop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	--power up
	dm.RegisterEffectUpdatePower(c,c,1,scard.powval,0)
end
function scard.powval(e,c)
	local t={1000,2000,3000,4000,5000}
	local val=math.randomchoice(t)
	if e:GetHandler():GetPower()+val>=MAX_NUMBER then
		return MAX_NUMBER
	else
		return val
	end
end
--double breaker
function scard.dbcon(e)
	local c=e:GetHandler()
	return c:IsPowerAbove(6000) and c:GetPower()<9000
end
--triple breaker
function scard.tbcon(e)
	return e:GetHandler():IsPowerAbove(9000)
end
