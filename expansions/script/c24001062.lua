--Swamp Worm
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--destroy
	dm.AddSingleComeIntoPlayEffect(c,0,nil,scard.destg,scard.desop,DM_EFFECT_FLAG_CARD_CHOOSE)
end
scard.duel_masters_card=true
scard.destg=dm.ChooseCardFunction(PLAYER_OPPONENT,nil,0,DM_LOCATION_BATTLE,1,1,DM_HINTMSG_DESTROY)
scard.desop=dm.ChooseDestroyOperation
