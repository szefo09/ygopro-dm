--Syforce, Aurora Elemental
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--return
	dm.AddSingleComeIntoPlayEffect(c,0,true,scard.rettg,scard.retop)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
function scard.thfilter(c)
	return c:IsSpell() and c:IsAbleToHand()
end
scard.rettg=dm.CheckCardFunction(dm.ManaZoneFilter(scard.thfilter),DM_LOCATION_MANA,0)
scard.retop=dm.SendtoHandOperation(PLAYER_PLAYER,dm.ManaZoneFilter(Card.IsSpell),DM_LOCATION_MANA,0,1)
