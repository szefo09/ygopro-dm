--Thrash Crawler
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--return
	dm.AddSingleComeIntoPlayTriggerEffect(c,0,nil,nil,dm.SendtoHandOperation(PLAYER_SELF,dm.ManaZoneFilter(),DM_LOCATION_MZONE,0,1))
	--cannot attack
	dm.EnableCannotAttack(c)
end
scard.duel_masters_card=true
