--Bronze-Arm Tribe
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to mana zone
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,dm.DecktopSendtoMZoneOperation(PLAYER_SELF,1))
end
scard.duel_masters_card=true
