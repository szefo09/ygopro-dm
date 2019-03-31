--Emperor Quazla
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_CYBER_LORD))
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetOperation(scard.chop1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(DM_LOCATION_BATTLE)
	e2:SetOperation(scard.chop2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(sid,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_CHAIN_END)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(DM_LOCATION_BATTLE)
	e3:SetCondition(scard.drcon)
	e3:SetOperation(dm.DrawUpToOperation(PLAYER_SELF,2))
	c:RegisterEffect(e3)
	e1:SetLabelObject(e3)
	e2:SetLabelObject(e3)
end
scard.duel_masters_card=true
function scard.chop1(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(0)
end
function scard.chop2(e,tp,eg,ep,ev,re,r,rp)
	if rp==1-tp and re:IsHasCategory(DM_CATEGORY_SHIELD_TRIGGER) and re:GetHandler():IsBrokenShield() then
		e:GetLabelObject():SetLabel(1)
	end
end
function scard.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()==1
end
