--Virtual Tripwire
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--tap
	dm.AddSpellCastEffect(c,0,scard.postg,scard.posop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.posfilter(c)
	return c:IsFaceup() and c:IsUntapped()
end
scard.postg=dm.TargetCardFunction(PLAYER_PLAYER,scard.posfilter,0,DM_LOCATION_BATTLE,1,1,DM_HINTMSG_TAP)
scard.posop=dm.TargetTapUntapOperation(POS_FACEUP_TAPPED)
