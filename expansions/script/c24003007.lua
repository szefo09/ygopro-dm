--Raza Vega, Thunder Guardian
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--destroy replace (to shield)
	dm.AddReplaceEffectSingleDestroy(c,0,scard.reptg,scard.repop)
end
scard.duel_masters_card=true
scard.reptg=dm.SingleReplaceDestroyTarget(Card.IsAbleToShield)
scard.repop=dm.SingleReplaceDestroyOperation(Duel.SendtoShield)
