--Aura Pegasus, Avatar of Life
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--vortex evolution
	dm.EnableEffectCustom(c,DM_EFFECT_VORTEX_EVOLUTION)
	dm.AddEvolutionProcedure(c,scard.evofilter1,scard.evofilter2)
	--to battle or to hand
	dm.AddSingleAttackTriggerEffect(c,0,nil,nil,scard.tbop)
	dm.AddSingleLeaveBattleEffect(c,0,nil,nil,scard.tbop)
	--triple breaker
	dm.EnableBreaker(c,DM_EFFECT_TRIPLE_BREAKER)
end
scard.duel_masters_card=true
--vortex evolution
scard.evofilter1=aux.FilterBoolFunction(Card.DMIsRace,DM_RACE_HORNED_BEAST)
scard.evofilter2=aux.FilterBoolFunction(Card.DMIsRace,DM_RACE_ANGEL_COMMAND)
--to battle or to hand
function scard.tbop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,1)
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
	Duel.DisableShuffleCheck()
	if tc:IsCreature() and not tc:IsEvolution() and tc:IsCanSendtoBattle(e,0,tp,false,false) then
		Duel.SendtoBattle(tc,0,tp,tp,false,false,POS_FACEUP_UNTAPPED)
	else
		Duel.SendtoHand(tc,PLAYER_OWNER,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
