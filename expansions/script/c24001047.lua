--Bone Assassin, the Ripper
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--slayer
	dm.EnableSlayer(c)
end
scard.duel_masters_card=true
