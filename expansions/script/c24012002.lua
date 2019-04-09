--Extreme Crawler
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--return
	local op_func=dm.SendtoHandOperation(nil,Card.IsFaceup,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,nil,nil,nil,c)
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,op_func)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
