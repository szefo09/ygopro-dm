--Alcadeias, Lord of Spirits
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsRace,DM_RACE_ANGEL_COMMAND))
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--cannot cast
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetTargetRange(1,1)
	e1:SetValue(scard.actval)
	c:RegisterEffect(e1)
end
scard.duel_masters_card=true
function scard.actval(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsSpell() and not rc:IsCivilization(DM_CIVILIZATION_LIGHT)
end
