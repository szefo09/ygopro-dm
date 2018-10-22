--Essence Elf
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--mana cost down
	dm.EnableUpdateManaCost(c,LOCATION_HAND,0,scard.mccon,scard.mctg,-1)
end
scard.duel_masters_card=true
scard.mctg=aux.TargetBoolFunction(Card.IsSpell)
function scard.mcfilter(c)
	return c:IsSpell() and c:IsManaCostAbove(2)
end
function scard.mccon(e)
	return Duel.IsExistingMatchingCard(scard.mcfilter,e:GetHandlerPlayer(),LOCATION_HAND,0,1,nil)
end
