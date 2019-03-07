--Dava Torey, Seeker of Clouds
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--discard replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(DM_EFFECT_DISCARD_REPLACE)
	e1:SetValue(DM_LOCATION_BATTLE)
	c:RegisterEffect(e1)
end
scard.duel_masters_card=true
