--Hawkeye Lunatron
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--search (to hand)
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,dm.SendtoHandOperation(PLAYER_SELF,nil,LOCATION_DECK,0,0,1))
end
scard.duel_masters_card=true
