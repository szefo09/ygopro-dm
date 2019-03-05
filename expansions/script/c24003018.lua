--Legendary Bynor
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsRace,DM_RACE_LEVIATHAN))
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--get ability (cannot be blocked)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetTargetRange(1,1)
	e1:SetCondition(dm.SelfAttackerCondition)
	e1:SetValue(dm.CannotBeBlockedValue())
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(DM_LOCATION_BATTLE)
	e2:SetTargetRange(DM_LOCATION_BATTLE,0)
	e2:SetTarget(scard.acttg)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(DM_EFFECT_UNBLOCKABLE)
	e3:SetRange(DM_LOCATION_BATTLE)
	e3:SetTargetRange(DM_LOCATION_BATTLE,0)
	e3:SetTarget(scard.acttg)
	c:RegisterEffect(e3)
end
scard.duel_masters_card=true
function scard.acttg(e,c)
	return c~=e:GetHandler() and c:IsCivilization(DM_CIVILIZATION_WATER)
end
