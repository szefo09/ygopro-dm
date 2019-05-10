--Aqua Master
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--confirm
	dm.AddSingleUnblockedAttackEffect(c,0,nil,scard.conftg,scard.confop,EFFECT_FLAG_CARD_TARGET,scard.confcon)
end
scard.duel_masters_card=true
scard.confcon=dm.AttackPlayerCondition
scard.conftg=dm.TargetCardFunction(PLAYER_SELF,dm.ShieldZoneFilter(Card.IsFacedown),0,DM_LOCATION_SHIELD,1)
scard.confop=dm.TargetConfirmOperation(true)
