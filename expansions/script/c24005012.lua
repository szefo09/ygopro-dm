--Le Quist, the Oracle
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--tap
	dm.AddSingleAttackTriggerEffect(c,0,true,scard.postg,scard.posop,DM_EFFECT_FLAG_CARD_CHOOSE)
end
scard.duel_masters_card=true
function scard.posfilter(c)
	return c:IsFaceup() and c:IsUntapped() and c:IsCivilization(DM_CIVILIZATIONS_DF)
end
scard.postg=dm.ChooseCardFunction(PLAYER_PLAYER,scard.posfilter,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,1,1,DM_HINTMSG_TAP)
scard.posop=dm.ChooseTapUntapOperation(POS_FACEUP_TAPPED)
