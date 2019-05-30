--Telitol, the Explorer
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--confirm
	dm.AddSingleComeIntoPlayTriggerEffect(c,0,true,scard.conftg,scard.confop)
	--cannot attack player
	dm.EnableCannotAttackPlayer(c)
end
scard.duel_masters_card=true
scard.conftg=dm.CheckCardFunction(dm.ShieldZoneFilter(Card.IsFacedown),DM_LOCATION_SZONE,0)
scard.confop=dm.ConfirmOperation(PLAYER_SELF,dm.ShieldZoneFilter(Card.IsFacedown),DM_LOCATION_SZONE,0)
