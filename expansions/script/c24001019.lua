--Solar Ray
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--tap
	dm.AddSpellCastEffect(c,0,scard.postg,scard.posop,DM_EFFECT_FLAG_CARD_CHOOSE)
	dm.AddShieldTriggerCastEffect(c,0,scard.postg,scard.posop,DM_EFFECT_FLAG_CARD_CHOOSE)
end
scard.duel_masters_card=true
scard.postg=dm.ChooseCardFunction(PLAYER_PLAYER,Card.IsUntapped,0,DM_LOCATION_BATTLE,1,1,DM_HINTMSG_TAP)
scard.posop=dm.ChooseTapUntapOperation(POS_FACEUP_TAPPED)
