--一徹のジャスパー
--Jasper, the Stubborn
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--attack if able
	dm.EnableEffectCustom(c,EFFECT_MUST_ATTACK)
	--destroy replace (return)
	dm.AddSingleDestroyReplaceEffect(c,0,scard.reptg,scard.repop)
end
scard.duel_masters_card=true
scard.reptg=dm.SingleDestroyReplaceTarget(Card.IsAbleToHand)
scard.repop=dm.SingleDestroyReplaceOperation(Duel.SendtoHand,PLAYER_OWNER,REASON_EFFECT+REASON_REPLACE)