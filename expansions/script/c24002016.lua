--Hypersquid Walter
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--draw
	dm.AddSingleAttackTriggerEffect(c,0,true,scard.drtg,scard.drop)
end
scard.duel_masters_card=true
scard.drtg=dm.DrawTarget(PLAYER_PLAYER)
scard.drop=dm.DrawOperation(PLAYER_PLAYER,1)
