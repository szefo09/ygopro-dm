--Glais Mejicula, the Extreme
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_INITIATE))
	--shield saver
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(sid,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetTarget(scard.reptg)
	e1:SetValue(scard.repval)
	e1:SetOperation(scard.repop)
	c:RegisterEffect(e1)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_INITIATE}
function scard.repfilter(c,tp)
	return c:IsLocation(DM_LOCATION_SHIELD) and c:IsControler(tp)
		and c:GetDestination()~=DM_LOCATION_SHIELD and not c:IsReason(REASON_REPLACE)
end
function scard.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:FilterCount(scard.repfilter,nil,tp)==1 and bit.band(r,DM_REASON_BREAK)~=0
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,2,nil) end
	return Duel.SelectYesNo(tp,aux.Stringid(sid,1))
end
function scard.repval(e,c)
	return scard.repfilter(c,e:GetHandlerPlayer())
end
function scard.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,sid)
	Duel.DiscardHand(tp,aux.TRUE,2,2,REASON_EFFECT+REASON_REPLACE)
end
