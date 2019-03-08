--Volcano Smog, Deceptive Shade
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--mana cost up
	dm.EnableUpdateManaCost(c,2,LOCATION_HAND,0,scard.mctg1)
	dm.EnableUpdateManaCost(c,2,LOCATION_HAND,0,scard.mctg2)
end
scard.duel_masters_card=true
function scard.mctg1(e,c)
	return c:IsCreature() and c:IsCivilization(DM_CIVILIZATION_LIGHT)
end
function scard.mctg2(e,c)
	return c:IsSpell() and c:IsCivilization(DM_CIVILIZATION_LIGHT)
end
