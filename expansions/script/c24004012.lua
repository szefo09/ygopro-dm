--Milieus, the Daystretcher
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--mana cost up
	dm.EnableUpdateManaCost(c,LOCATION_HAND,LOCATION_HAND,scard.mccon1,scard.mctg1,2,scard.mccon2,scard.mctg2)
end
scard.duel_masters_card=true
function scard.mcfilter1(c)
	return c:IsCreature() and c:IsCivilization(DM_CIVILIZATION_DARKNESS)
end
function scard.mccon1(e)
	return Duel.IsExistingMatchingCard(scard.mcfilter1,e:GetHandlerPlayer(),LOCATION_HAND,LOCATION_HAND,1,nil)
end
function scard.mctg1(e,c)
	return c:IsType(DM_TYPE_CREATURE) and c:IsCivilization(DM_CIVILIZATION_DARKNESS)
end
function scard.mcfilter2(c)
	return c:IsSpell() and c:IsCivilization(DM_CIVILIZATION_DARKNESS)
end
function scard.mccon2(e)
	return Duel.IsExistingMatchingCard(scard.mcfilter2,e:GetHandlerPlayer(),LOCATION_HAND,LOCATION_HAND,1,nil)
end
function scard.mctg2(e,c)
	return c:IsType(TYPE_SPELL) and c:IsCivilization(DM_CIVILIZATION_DARKNESS)
end
