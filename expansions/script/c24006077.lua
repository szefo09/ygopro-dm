--Cocco Lupia
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--mana cost down
	dm.EnableUpdateManaCost(c,scard.mcval,LOCATION_HAND,0,aux.TargetBoolFunction(Card.DMIsRace(DM_RACE_DRAGON)))
end
scard.duel_masters_card=true
function scard.mcval(e,c)
	if c:GetManaCost()<=2 then return 0
	else return -2 end
end
