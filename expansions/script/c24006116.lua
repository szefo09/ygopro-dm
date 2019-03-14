--Phantasmal Horror Gigazald
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_CHIMERA))
	--get ability (tap ability) (discard)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(sid,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetHintTiming(DM_TIMING_TAP_ABILITY,0)
	e1:SetCondition(dm.TapAbilityCondition)
	e1:SetCost(dm.SelfTapCost)
	e1:SetTarget(scard.dhtg)
	e1:SetOperation(dm.DiscardOperation(PLAYER_OPPONENT,aux.TRUE,0,LOCATION_HAND,1,1,true))
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(DM_LOCATION_BATTLE)
	e2:SetTargetRange(DM_LOCATION_BATTLE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsCivilization,DM_CIVILIZATION_DARKNESS))
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
scard.duel_masters_card=true
function scard.dhtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_HAND,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
