--Miraculous Snare
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--to shield
	dm.AddSpellCastEffect(c,0,scard.tstg,scard.tsop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.tsfilter(c)
	return c:IsFaceup() and not c:IsEvolution()
end
scard.tstg=dm.TargetCardFunction(PLAYER_SELF,scard.tsfilter,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,1,1,DM_HINTMSG_TOSHIELD)
scard.tsop=dm.TargetSendtoShieldOperation
