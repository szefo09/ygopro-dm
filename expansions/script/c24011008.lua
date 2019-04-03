--Belix, the Explorer
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--return
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,scard.retop)
	--cannot attack player
	dm.EnableCannotAttackPlayer(c)
end
scard.duel_masters_card=true
function scard.retfilter(c)
	return c:IsSpell() and c:IsAbleToHand()
end
scard.retop=dm.SendtoHandOperation(PLAYER_SELF,dm.ManaZoneFilter(scard.retfilter),DM_LOCATION_MANA,0,1)
