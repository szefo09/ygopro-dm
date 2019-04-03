--Vine Charger
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--to mana
	dm.AddSpellCastEffect(c,0,scard.tmtg,scard.tmop,EFFECT_FLAG_CARD_TARGET)
	--charger
	dm.EnableEffectCustom(c,DM_EFFECT_CHARGER)
end
scard.duel_masters_card=true
function scard.tmfilter(c)
	return c:IsFaceup() and c:IsAbleToMana()
end
scard.tmtg=dm.TargetCardFunction(PLAYER_OPPO,scard.tmfilter,0,DM_LOCATION_BATTLE,1,1,DM_HINTMSG_TOMANA)
scard.tmop=dm.TargetSendtoManaOperation