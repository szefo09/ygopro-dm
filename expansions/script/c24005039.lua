--Cannoneer Bargon
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--cannot attack player
	dm.EnableCannotAttackPlayer(c)
end
scard.duel_masters_card=true
