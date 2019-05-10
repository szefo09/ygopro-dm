--Trixo, Wicked Doll
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--destroy
	dm.AddSingleUnblockedAttackEffect(c,0,nil,scard.destg,scard.desop,EFFECT_FLAG_CARD_TARGET,scard.descon)
end
scard.duel_masters_card=true
scard.descon=dm.AttackPlayerCondition
scard.destg=dm.TargetCardFunction(PLAYER_OPPO,Card.IsFaceup,0,DM_LOCATION_BATTLE,1,1,DM_HINTMSG_DESTROY)
scard.desop=dm.TargetDestroyOperation
