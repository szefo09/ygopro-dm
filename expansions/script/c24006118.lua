--Lava Walker Executo
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_DRAGO_NOID))
	--get ability (tap ability) (get ability)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(sid,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetHintTiming(DM_TIMING_TAP_ABILITY,0)
	e1:SetCondition(dm.TapAbilityCondition)
	e1:SetCost(dm.SelfTapCost)
	e1:SetTarget(scard.abtg)
	e1:SetOperation(scard.abop)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(DM_LOCATION_BATTLE)
	e2:SetTargetRange(DM_LOCATION_BATTLE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsCivilization,DM_CIVILIZATION_FIRE))
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
scard.duel_masters_card=true
function scard.abfilter(c)
	return c:IsFaceup() and c:IsCivilization(DM_CIVILIZATION_FIRE)
end
function scard.abtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(scard.abfilter,tp,DM_LOCATION_BATTLE,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_CREATURE)
	local g=Duel.SelectMatchingCard(tp,scard.abfilter,tp,DM_LOCATION_BATTLE,0,1,1,nil)
	if g:GetCount()==0 then return end
	Duel.HintSelection(g)
	--power up
	dm.RegisterEffectUpdatePower(e:GetHandler(),g:GetFirst(),1,3000)
end
