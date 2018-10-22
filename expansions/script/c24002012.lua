--Aqua Bouncer
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--return
	dm.AddSingleComeIntoPlayEffect(c,0,true,scard.rettg,scard.retop,DM_EFFECT_FLAG_CARD_CHOOSE)
end
scard.duel_masters_card=true
scard.rettg=dm.ChooseCardFunction(PLAYER_PLAYER,Card.IsAbleToHand,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,1,1,DM_HINTMSG_RTOHAND)
scard.retop=dm.ChooseSendtoHandOperation()
