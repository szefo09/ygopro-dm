--Windmill Mutant
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--discard
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,dm.DiscardOperation(PLAYER_OPPO,aux.TRUE,0,LOCATION_HAND,1,1,true))
end
scard.duel_masters_card=true
