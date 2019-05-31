--Storm Shell
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to mana
	dm.AddSingleComeIntoPlayTriggerEffect(c,0,nil,scard.tmtg,scard.tmop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.tmfilter(c)
	return c:IsFaceup() and c:IsAbleToMana()
end
scard.tmtg=dm.TargetCardFunction(PLAYER_OPPO,scard.tmfilter,0,DM_LOCATION_BZONE,1,1,DM_HINTMSG_TOMZONE)
scard.tmop=dm.TargetSendtoManaOperation
