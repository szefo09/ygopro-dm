--ストリーミング・シェイパー
--Streaming Shaper
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--to hand
	dm.AddSpellCastEffect(c,0,nil,scard.thop)
end
scard.duel_masters_card=true
function scard.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,4)
	local g=Duel.GetDecktopGroup(tp,4)
	local sg=g:Filter(Card.IsCivilization,nil,DM_CIVILIZATION_WATER)
	Duel.DisableShuffleCheck()
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,PLAYER_OWNER,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
		g:Sub(sg)
	end
	Duel.SendtoDMGrave(g,REASON_EFFECT)
end
