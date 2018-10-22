--Bombat, General of Speed
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--speed attacker
	dm.EnableSpeedAttacker(c)
end
scard.duel_masters_card=true
