--Stained Glass
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--return
	dm.AddSingleAttackTriggerEffect(c,0,true,scard.rettg,scard.retop,DM_EFFECT_FLAG_CARD_CHOOSE)
end
scard.duel_masters_card=true
function scard.retfilter(c)
	return c:IsCivilization(DM_CIVILIZATIONS_FN) and c:IsAbleToHand()
end
scard.rettg=dm.ChooseCardFunction(PLAYER_PLAYER,scard.retfilter,0,DM_LOCATION_BATTLE,1,1,DM_HINTMSG_RTOHAND)
scard.retop=dm.ChooseSendtoHandOperation()
