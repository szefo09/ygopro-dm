--Simian Warrior Grash
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to grave
	dm.AddDestroyedEffect(c,0,nil,scard.tgtg,scard.tgop,EFFECT_FLAG_CARD_TARGET,scard.tgcon)
end
scard.duel_masters_card=true
function scard.cfilter(c)
	return c:IsPreviousLocation(DM_LOCATION_BATTLE) and c:IsPreviousPosition(POS_FACEUP) and c:DMIsPreviousRace(DM_RACE_ARMORLOID)
end
function scard.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(scard.cfilter,1,nil)
end
scard.tgtg=dm.TargetCardFunction(PLAYER_OPPO,dm.ManaZoneFilter(Card.DMIsAbleToGrave),0,DM_LOCATION_MANA,1,1,DM_HINTMSG_TOGRAVE)
function scard.tgop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	Duel.DMSendtoGrave(tc,REASON_EFFECT)
end
--[[
	References
		1. Performapal Sellshell Crab
		https://github.com/Fluorohydride/ygopro-scripts/blob/2c4f0ca/c23377694.lua#L68
]]
