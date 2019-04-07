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
scard.retop=dm.SendtoHandOperation(PLAYER_SELF,dm.ManaZoneFilter(Card.IsSpell),DM_LOCATION_MANA,0,1)
