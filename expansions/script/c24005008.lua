--Gallia Zohl, Iron Guardian Q
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--survivor (blocker)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(DM_DESC_BLOCKER)
	e1:SetCategory(DM_CATEGORY_BLOCKER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetCondition(dm.BlockerCondition)
	e1:SetTarget(dm.BlockerTarget)
	e1:SetOperation(dm.BlockerOperation)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(DM_LOCATION_BATTLE)
	e2:SetTargetRange(LOCATIONS_ALL,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.DMIsRace,DM_RACE_SURVIVOR))
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(DM_EFFECT_BLOCKER)
	e3:SetRange(DM_LOCATION_BATTLE)
	e3:SetTargetRange(LOCATIONS_ALL,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.DMIsRace,DM_RACE_SURVIVOR))
	c:RegisterEffect(e3)
end
scard.duel_masters_card=true
