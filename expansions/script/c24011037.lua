--Hysteria Lizard
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--attack if able
	dm.EnableAttackIfAble(c)
	--power attacker
	dm.EnablePowerAttacker(c,3000)
end
scard.duel_masters_card=true
