--Trench Scarab
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--cannot attack player
	dm.EnableCannotAttackPlayer(c)
	--power attacker
	dm.EnablePowerAttacker(c,4000)
end
scard.duel_masters_card=true
