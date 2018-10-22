--Überdragon Jabaha
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.IsDMRace,DM_RACE_ARMORED_DRAGON))
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--get ability (power attacker)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(DM_EFFECT_UPDATE_POWER)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetCondition(dm.SelfAttackerCondition)
	e1:SetValue(2000)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(DM_LOCATION_BATTLE)
	e2:SetTargetRange(DM_LOCATION_BATTLE,0)
	e2:SetTarget(scard.patg)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(DM_EFFECT_POWER_ATTACKER)
	e3:SetRange(DM_LOCATION_BATTLE)
	e3:SetTargetRange(DM_LOCATION_BATTLE,0)
	e3:SetTarget(scard.patg)
	c:RegisterEffect(e3)
end
scard.duel_masters_card=true
function scard.patg(e,c)
	return c~=e:GetHandler()
end
