--Solid Horn
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--destroy replace (to mana)
	dm.AddSingleDestroyReplaceEffect(c,0,scard.reptg,scard.repop)
end
scard.duel_masters_card=true
scard.reptg=dm.SingleDestroyReplaceTarget(Card.IsAbleToMana)
scard.repop=dm.SelftoManaDestroyReplaceOperation
