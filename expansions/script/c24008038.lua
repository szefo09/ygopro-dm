--Kyrstron, Lair Delver
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to battle
	dm.AddSingleDestroyedTriggerEffect(c,0,true,scard.tbtg,scard.tbop)
end
scard.duel_masters_card=true
function scard.tbfilter(c)
	return c:DMIsRace(DM_RACE_DRAGON)
end
scard.tbtg=dm.SendtoBattleTarget(scard.tbfilter,LOCATION_HAND,0)
scard.tbop=dm.SendtoBattleOperation(PLAYER_SELF,scard.tbfilter,LOCATION_HAND,0,1)
