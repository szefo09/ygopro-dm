--Freezing Icehammer
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--destroy
	dm.AddSpellCastEffect(c,0,scard.tmtg,scard.tmop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.tmfilter(c)
	return c:IsFaceup() and c:IsCivilization(DM_CIVILIZATIONS_WD) and c:IsAbleToMana()
end
scard.tmtg=dm.TargetCardFunction(PLAYER_OPPONENT,scard.tmfilter,0,DM_LOCATION_BATTLE,1,1,DM_HINTMSG_TOMANA)
scard.tmop=dm.TargetSendtoManaOperation