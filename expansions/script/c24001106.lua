--Storm Shell
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to mana
	dm.AddSingleComeIntoPlayEffect(c,0,nil,scard.tmtg,scard.tmop,DM_EFFECT_FLAG_CARD_CHOOSE)
end
scard.duel_masters_card=true
scard.tmtg=dm.ChooseCardFunction(PLAYER_OPPONENT,nil,0,DM_LOCATION_BATTLE,1,1,DM_HINTMSG_TOMANA)
scard.tmop=dm.ChooseSendtoManaOperation
