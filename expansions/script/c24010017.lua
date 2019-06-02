--Ikaz, the Spydroid
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--untap
	dm.AddSingleTriggerEffectCustom(c,0,DM_EVENT_BATTLE_END,nil,scard.postg,scard.posop,EFFECT_FLAG_CARD_TARGET,dm.SelfBlockCondition)
	--cannot attack player
	dm.EnableCannotAttackPlayer(c)
end
scard.duel_masters_card=true
function scard.posfilter(c)
	return c:IsFaceup() and c:IsAbleToUntap()
end
scard.postg=dm.TargetCardFunction(PLAYER_SELF,scard.posfilter,DM_LOCATION_BZONE,0,1,1,DM_HINTMSG_UNTAP)
scard.posop=dm.TargetUntapOperation
