--Stinger Worm
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--destroy
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,dm.DestroyOperation(PLAYER_SELF,Card.IsFaceup,DM_LOCATION_BZONE,0,1))
end
scard.duel_masters_card=true
