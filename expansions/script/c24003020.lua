--Psychic Shaper
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--to hand
	dm.AddSpellCastEffect(c,0,nil,scard.thop)
end
scard.duel_masters_card=true
function scard.thfilter(c)
	return c:IsCivilization(DM_CIVILIZATION_WATER) and c:IsAbleToHand()
end
function scard.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,4)
	local g=Duel.GetDecktopGroup(tp,4)
	local sg=g:Filter(scard.thfilter,nil)
	Duel.DisableShuffleCheck()
	if sg:GetCount()>0 then
		if Duel.SendtoHand(sg,PLAYER_OWNER,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
			g:Sub(sg)
		end
	end
	Duel.DMSendtoGrave(g,REASON_EFFECT)
end
--[[
	References
		1. Ma'at
		https://github.com/Fluorohydride/ygopro-scripts/blob/2c4f0ca/c18631392.lua#L71
		2. Spellbook Library of the Heliosphere
		https://github.com/Fluorohydride/ygopro-scripts/blob/6324c1c/c20822520.lua#L65
]]
