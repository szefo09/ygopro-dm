--緑神龍ハルクーンベルガ
--Terradragon Hulcoon Berga
--Not fully implemented: DEF~=ATK and ATK/DEF randomly changes during a turn
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--get ability (power attacker)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(DM_EFFECT_UPDATE_POWER)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetCondition(dm.SelfAttackerCondition)
	e1:SetValue(4000)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(DM_LOCATION_BATTLE)
	e2:SetTargetRange(DM_LOCATION_BATTLE,0)
	e2:SetTarget(scard.abtg)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(DM_EFFECT_POWER_ATTACKER)
	e3:SetRange(DM_LOCATION_BATTLE)
	e3:SetTargetRange(DM_LOCATION_BATTLE,0)
	e3:SetTarget(scard.abtg)
	c:RegisterEffect(e3)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER,dm.SelfTappedCondition,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,0,scard.abtg)
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
	dm.GainEffectUpdatePower(c,c,1,scard.powval,0)
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
