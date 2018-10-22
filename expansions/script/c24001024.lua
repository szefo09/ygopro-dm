--Aqua Knight
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--destroy replace (return)
	dm.AddSingleDestroyReplaceEffect(c,0,scard.reptg,scard.repop)
end
scard.duel_masters_card=true
scard.reptg=dm.SingleDestroyReplaceTarget(Card.IsAbleToHand)
scard.repop=dm.SelftoHandDestroyReplaceOperation
