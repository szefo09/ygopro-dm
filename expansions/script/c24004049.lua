--Cannon Shell
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--power up
	dm.EnableUpdatePower(c,scard.powval)
end
scard.duel_masters_card=true
function scard.powval(e,c)
	return Duel.GetMatchingGroupCount(dm.ShieldZoneFilter(),c:GetControler(),DM_LOCATION_SHIELD,0,nil)*1000
end
