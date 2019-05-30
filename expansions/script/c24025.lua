--爛漫妖精フリップル
--Flipull, Full Bloom Faerie
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to mana
	dm.AddTurnEndTriggerEffect(c,0,PLAYER_SELF,nil,nil,scard.tmop)
end
scard.duel_masters_card=true
function scard.tmfilter(c)
	return c:IsFaceup() and c:IsAbleToMana()
end
function scard.tmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(scard.tmfilter,tp,DM_LOCATION_BZONE,DM_LOCATION_BZONE,nil):RandomSelect(tp,1)
	Duel.HintSelection(g)
	Duel.SendtoMana(g,POS_FACEUP_UNTAPPED,REASON_EFFECT)
end
