--Poisonous Mushroom
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to mana
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,true,scard.tmtg,scard.tmop)
end
scard.duel_masters_card=true
scard.tmtg=dm.CheckCardFunction(Card.IsAbleToMZone,LOCATION_HAND,0)
scard.tmop=dm.SendtoMZoneOperation(PLAYER_SELF,nil,LOCATION_HAND,0,1)
