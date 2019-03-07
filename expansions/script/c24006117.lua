--Bolmeteus Steel Dragon
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--break replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(DM_EFFECT_BREAK_SHIELD_REPLACE)
	e1:SetValue(DM_LOCATION_GRAVE)
	c:RegisterEffect(e1)
end
scard.duel_masters_card=true
