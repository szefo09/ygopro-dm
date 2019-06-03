--Rollicking Totem
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--silent skill (to battle zone)
	dm.EnableSilentSkill(c,0,scard.tbtg,scard.tbop)
end
scard.duel_masters_card=true
function scard.tbfilter(c)
	return c:DMIsRace(DM_RACE_DRAGON)
end
scard.tbtg=dm.SendtoBZoneTarget(dm.ManaZoneFilter(scard.tbfilter),DM_LOCATION_MZONE,0)
scard.tbop=dm.SendtoBZoneOperation(PLAYER_SELF,dm.ManaZoneFilter(scard.tbfilter),DM_LOCATION_MZONE,0,1)
