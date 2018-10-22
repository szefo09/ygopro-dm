--Smile Angler
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--return
	dm.AddSingleAttackTriggerEffect(c,0,true,scard.rettg,scard.retop,DM_EFFECT_FLAG_CARD_CHOOSE)
end
scard.duel_masters_card=true
scard.rettg=dm.ChooseCardFunction(PLAYER_PLAYER,dm.ManaZoneFilter(Card.IsAbleToHand),0,DM_LOCATION_MANA,1,1,DM_HINTMSG_RTOHAND)
scard.retop=dm.ChooseSendtoHandOperation()
