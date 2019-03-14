--Lu Gila, Silver Rift Guardian
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--enter tapped
	dm.EnableEffectCustom(c,DM_EFFECT_ENTER_TAPPED,nil,DM_LOCATION_BATTLE,LOCATION_ALL,LOCATION_ALL,scard.abtg)
	--cannot attack player
	dm.EnableCannotAttackPlayer(c)
end
scard.duel_masters_card=true
scard.abtg=aux.TargetBoolFunction(Card.IsEvolution)
