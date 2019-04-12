--Techno Totem
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--get ability (power attacker)
	dm.AddStaticEffectPowerAttacker(c,1500,DM_LOCATION_BATTLE,0,scard.abtg,dm.SelfTappedCondition)
	--tap ability (tap)
	dm.EnableTapAbility(c,0,scard.postg,scard.posop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
--get ability (power attacker)
function scard.abtg(e,c)
	return c~=e:GetHandler()
end
--tap ability (tap)
function scard.posfilter(c)
	return c:IsFaceup() and c:IsUntapped()
end
scard.postg=dm.TargetCardFunction(PLAYER_SELF,scard.posfilter,0,DM_LOCATION_BATTLE,1,1,DM_HINTMSG_TAP)
scard.posop=dm.TargetTapUntapOperation(POS_FACEUP_TAPPED)
