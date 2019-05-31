--電磁霊樹アカシック・セカンド
--Akashic Second, Electro-Spirit
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--draw
	dm.AddSingleTriggerEffectCustom(c,0,DM_EVENT_COME_INTO_PLAY,true,dm.DrawTarget(PLAYER_SELF),dm.DrawOperation(PLAYER_SELF,1))
	--destroy replace (to mana)
	dm.AddSingleDestroyReplaceEffect(c,1,scard.reptg,scard.repop)
end
scard.duel_masters_card=true
scard.reptg=dm.SingleDestroyReplaceTarget(Card.IsAbleToMana)
scard.repop=dm.SingleDestroyReplaceOperation(Duel.SendtoMana,POS_FACEUP_UNTAPPED,REASON_EFFECT+REASON_REPLACE)
