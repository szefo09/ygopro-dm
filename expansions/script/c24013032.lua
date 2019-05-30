--永刻のクイーン・メイデン
--Queen Maiden, the Eternal
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_SPIRIT_QUARTZ))
	--confirm (to hand or to mana)
	dm.AddSingleComeIntoPlayTriggerEffect(c,0,nil,nil,scard.thop)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_SPIRIT_QUARTZ}
function scard.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_NAME)
	local code=Duel.AnnounceCard(tp)
	Duel.ConfirmDecktop(tp,1)
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
	Duel.DisableShuffleCheck()
	if tc:IsCode(code) and tc:IsAbleToHand() then
		Duel.SendtoHand(tc,PLAYER_OWNER,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		Duel.ShuffleHand(tp)
	else
		Duel.SendtoMana(tc,POS_FACEUP_UNTAPPED,REASON_EFFECT)
	end
end
