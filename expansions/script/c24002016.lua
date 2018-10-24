--Hypersquid Walter
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--draw
	dm.AddSingleAttackTriggerEffect(c,0,true,dm.DrawTarget(PLAYER_PLAYER),dm.DrawOperation(PLAYER_PLAYER,1))
end
scard.duel_masters_card=true
