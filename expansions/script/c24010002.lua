--Ryudmila, Channeler of Suns
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--power up
	dm.EnableUpdatePower(c,scard.powval)
	--destroy replace (to deck)
	dm.AddSingleDestroyReplaceEffect(c,0,scard.reptg,scard.repop)
end
scard.duel_masters_card=true
--power up
function scard.cfilter(c)
	return c:IsFaceup() and c:IsUntapped()
end
function scard.powval(e,c)
	return Duel.GetMatchingGroupCount(scard.cfilter,c:GetControler(),DM_LOCATION_BATTLE,0,c)*2000
end
--destroy replace (to deck)
scard.reptg=dm.SingleDestroyReplaceTarget(Card.IsAbleToDeck)
scard.repop=dm.SelftoDeckDestroyReplaceOperation(DECK_SEQUENCE_SHUFFLE)
