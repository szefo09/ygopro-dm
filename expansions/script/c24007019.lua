--Cetibols
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--draw
	dm.AddSingleTriggerEffect(c,0,EVENT_DESTROYED,true,dm.DrawTarget(PLAYER_SELF),dm.DrawOperation(PLAYER_SELF,1))
end
scard.duel_masters_card=true
