--Ballas, Vizier of Electrons
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
end
scard.duel_masters_card=true
