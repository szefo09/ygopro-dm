--Cocco Lupia
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--mana cost down
	dm.EnableUpdateManaCost(c,LOCATION_HAND,0,nil,scard.mctg,-2)
end
scard.duel_masters_card=true
function scard.mctg(e,c)
	return c:DMIsRace(DM_RACE_DRAGON) and c:IsManaCostAbove(4)
end
