--Natural Snare
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--to mana
	dm.AddSpellCastEffect(c,0,scard.tmtg,scard.tmop,DM_EFFECT_FLAG_CARD_CHOOSE)
	dm.AddShieldTriggerCastEffect(c,0,scard.tmtg,scard.tmop,DM_EFFECT_FLAG_CARD_CHOOSE)
end
scard.duel_masters_card=true
scard.tmtg=dm.ChooseCardFunction(PLAYER_PLAYER,nil,0,DM_LOCATION_BATTLE,1,1,DM_HINTMSG_TOMANA)
scard.tmop=dm.ChooseSendtoManaOperation
