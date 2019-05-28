--Comet Eye, the Spectral Spud
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_WILD_VEGGIES,DM_RACE_RAINBOW_PHANTOM))
	--power up
	dm.EnableUpdatePower(c,2000,nil,DM_LOCATION_BZONE,0,scard.powtg)
	--untap
	dm.AddTurnEndTriggerEffect(c,0,PLAYER_SELF,true,scard.postg,scard.posop)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_WILD_VEGGIES,DM_RACE_RAINBOW_PHANTOM}
--power up
function scard.powtg(e,c)
	return c~=e:GetHandler() and c:DMIsRace(DM_RACE_WILD_VEGGIES,DM_RACE_RAINBOW_PHANTOM)
end
--untap
function scard.posfilter(c)
	return c:IsFaceup() and c:DMIsRace(DM_RACE_WILD_VEGGIES,DM_RACE_RAINBOW_PHANTOM) and c:IsAbleToUntap()
end
scard.postg=dm.CheckCardFunction(scard.posfilter,DM_LOCATION_BZONE,0)
function scard.posop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(scard.posfilter,tp,DM_LOCATION_BZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_UNTAP)
	local g=Duel.SelectMatchingCard(tp,scard.posfilter,tp,DM_LOCATION_BZONE,0,1,ct,nil)
	if g:GetCount()==0 then return end
	Duel.HintSelection(g)
	Duel.Untap(g,REASON_EFFECT)
end
