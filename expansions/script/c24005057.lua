--King Tsunami
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--return
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,dm.SendtoHandOperation(nil,nil,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,nil,nil,c))
	--triple breaker
	dm.EnableBreaker(c,DM_EFFECT_TRIPLE_BREAKER)
end
scard.duel_masters_card=true
