--Marinomancer
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to hand
	dm.AddSingleComeIntoPlayEffect(c,0,true,dm.CheckDeckFunction(PLAYER_PLAYER),scard.thop)
end
scard.duel_masters_card=true
function scard.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	local sg=g:Filter(Card.IsCivilization,nil,DM_CIVILIZATIONS_LD)
	Duel.DisableShuffleCheck()
	if sg:GetCount()>0 then
		if Duel.SendtoHand(sg,PLAYER_OWNER,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
			g:Sub(sg)
		end
	end
	Duel.SendtoDMGrave(g,REASON_EFFECT)
end
