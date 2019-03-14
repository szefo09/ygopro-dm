--Smash Horn Q
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--survivor (power up)
	dm.EnableUpdatePower(c,1000)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(DM_EFFECT_UPDATE_POWER)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetValue(1000)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(DM_LOCATION_BATTLE)
	e2:SetTargetRange(LOCATION_ALL,0)
	e2:SetTarget(scard.powtg)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
scard.duel_masters_card=true
function scard.powtg(e,c)
	return c~=e:GetHandler() and c:DMIsRace(DM_RACE_SURVIVOR)
end
