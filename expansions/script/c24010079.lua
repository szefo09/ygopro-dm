--Adventure Boar
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--power attacker
	dm.EnablePowerAttacker(c,2000)
end
scard.duel_masters_card=true
