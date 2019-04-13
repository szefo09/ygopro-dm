--Ikaz, the Spydroid
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--untap
	dm.AddSingleBlockEffect(c,0,nil,scard.postg,scard.posop,EFFECT_FLAG_CARD_TARGET)
	--cannot attack player
	dm.EnableCannotAttackPlayer(c)
end
scard.duel_masters_card=true
function scard.posfilter(c)
	return c:IsFaceup() and c:IsTapped()
end
scard.postg=dm.TargetCardFunction(PLAYER_SELF,scard.posfilter,DM_LOCATION_BATTLE,0,1,1,DM_HINTMSG_UNTAP)
scard.posop=dm.TargetTapUntapOperation(POS_FACEUP_UNTAPPED)