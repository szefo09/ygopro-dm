--Marinomancer
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--confirm (to hand)
	dm.AddSingleComeIntoPlayEffect(c,0,true,dm.CheckDeckFunction(PLAYER_SELF),scard.thop)
end
scard.duel_masters_card=true
function scard.thfilter(c)
	return c:IsCivilization(DM_CIVILIZATIONS_LD) and c:IsAbleToHand()
end
function scard.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
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
