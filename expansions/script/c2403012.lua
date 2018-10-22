--爛漫妖精フリップル
--Flipull, Full Bloom Faerie
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to mana
	dm.AddTurnEndEffect(c,0,nil,nil,scard.tmop,nil,dm.TurnPlayerCondition(PLAYER_PLAYER),1)
end
scard.duel_masters_card=true
function scard.tmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(nil,tp,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,nil):RandomSelect(tp,1)
	Duel.HintSelection(g)
	Duel.SendtoMana(g,POS_FACEUP_UNTAPPED,REASON_EFFECT)
end
