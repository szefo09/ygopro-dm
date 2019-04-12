--Uliya, the Entrancer
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to hand
	dm.AddSingleComeIntoPlayEffect(c,0,nil,scard.thtg,scard.thop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
scard.thtg=dm.TargetCardFunction(PLAYER_SELF,dm.ShieldZoneFilter(Card.IsAbleToHand),DM_LOCATION_SHIELD,0,1,1,DM_HINTMSG_ATOHAND)
scard.thop=dm.TargetSendtoHandOperation(nil,true)
