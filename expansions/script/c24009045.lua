--Steam Rumbler Kain
--Not fully implemented: YGOPro allows players to view their face-down cards
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to grave
	dm.AddSingleAttackTriggerEffect(c,0,nil,scard.tgtg,scard.tgop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
--scard.tgtg=dm.TargetCardFunction(PLAYER_SELF,dm.ShieldZoneFilter(Card.DMIsAbleToGrave),DM_LOCATION_SHIELD,0,1,1,DM_HINTMSG_TOGRAVE)
scard.tgtg=dm.TargetShieldFunction(PLAYER_SELF,dm.ShieldZoneFilter(Card.DMIsAbleToGrave),DM_LOCATION_SHIELD,0,1,1,DM_HINTMSG_TOGRAVE)
scard.tgop=dm.TargetSendtoGraveOperation
