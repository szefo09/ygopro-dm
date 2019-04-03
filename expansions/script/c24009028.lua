--Gabzagul, Warlord of Pain
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--attack if able
	dm.EnableEffectCustom(c,EFFECT_MUST_ATTACK,nil,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE)
end
scard.duel_masters_card=true
