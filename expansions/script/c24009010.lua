--Kalute, Vizier of Eternity
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--destroy replace (return)
	dm.AddSingleDestroyReplaceEffect(c,0,scard.reptg,scard.repop,scard.repcon)
end
scard.duel_masters_card=true
function scard.cfilter(c)
	return c:IsFaceup() and c:IsCode(CARD_KALUTE_VIZIER_OF_ETERNITY)
end
function scard.repcon(e)
	return Duel.IsExistingMatchingCard(scard.cfilter,e:GetHandlerPlayer(),DM_LOCATION_BATTLE,0,1,nil)
end
scard.reptg=dm.SingleDestroyReplaceTarget(Card.IsAbleToHand)
scard.repop=dm.SingleDestroyReplaceOperation(Duel.SendtoHand,PLAYER_OWNER,REASON_EFFECT+REASON_REPLACE)
