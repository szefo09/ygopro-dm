--エンペラー・アロエラ
--Emperor Aloera
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.IsDMRace,DM_RACE_CYBER_LORD))
	--to shield & return
	dm.AddSingleComeIntoPlayEffect(c,0,nil,scard.tstg,scard.tsop)
end
scard.duel_masters_card=true
function scard.tstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,DM_LOCATION_SHIELD)>0
		and Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,1,nil) end
end
function scard.tsop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetLocationCount(tp,DM_LOCATION_SHIELD)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOSHIELD)
	local sg1=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND,0,0,ct,nil)
	if sg1:GetCount()==0 then return end
	Duel.SendtoShield(sg1,tp)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_RTOHAND)
	local sg2=Duel.SelectMatchingCard(tp,dm.ShieldZoneFilter(),tp,DM_LOCATION_SHIELD,0,ct,ct,nil)
	Duel.HintSelection(sg2)
	Duel.SendtoHand(sg2,PLAYER_OWNER,REASON_EFFECT)
end
