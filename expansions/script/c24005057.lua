--King Tsunami
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--return
	dm.AddSingleComeIntoPlayTriggerEffect(c,0,nil,nil,dm.SendtoHandOperation(nil,Card.IsFaceup,DM_LOCATION_BZONE,DM_LOCATION_BZONE,nil,nil,nil,c))
	--triple breaker
	dm.EnableBreaker(c,DM_EFFECT_TRIPLE_BREAKER)
end
scard.duel_masters_card=true
