--Bone Piercer
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--return
	dm.AddSingleDestroyedEffect(c,0,true,scard.rettg,scard.retop)
end
scard.duel_masters_card=true
function scard.retfilter(c)
	return c:IsCreature() and c:IsAbleToHand()
end
scard.rettg=dm.CheckCardFunction(dm.ManaZoneFilter(scard.retfilter),DM_LOCATION_MANA,0)
scard.retop=dm.SendtoHandOperation(PLAYER_PLAYER,dm.ManaZoneFilter(scard.retfilter),DM_LOCATION_MANA,0,1)
