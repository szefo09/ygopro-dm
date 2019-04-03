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
	return c:IsPreviousLocation(DM_LOCATION_BATTLE)
		and c:IsPreviousPosition(POS_FACEUP) and c:DMIsPreviousRace(DM_RACE_ARMORLOID)
end
function scard.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(scard.cfilter,1,nil)
end
scard.tgtg=dm.TargetCardFunction(PLAYER_OPPO,dm.ManaZoneFilter(Card.DMIsAbleToGrave),0,DM_LOCATION_MANA,1,1,DM_HINTMSG_TOGRAVE)
function scard.tgop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.DMSendtoGrave(tc,REASON_EFFECT)
	end
end
--[[
	References
		1. Performapal Sellshell Crab
		https://github.com/Fluorohydride/ygopro-scripts/blob/2c4f0cad97c65971f2a2a813f93b11db9e3ac88f/c23377694.lua#L68
]]
