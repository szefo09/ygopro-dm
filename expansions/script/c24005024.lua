--Split-Head Hydroturtle Q
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--survivor (draw)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(sid,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetProperty(DM_EFFECT_FLAG_ATTACK_TRIGGER)
	e1:SetTarget(scard.drtg)
	e1:SetOperation(dm.DrawOperation(PLAYER_PLAYER,1))
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(DM_LOCATION_BATTLE)
	e2:SetTargetRange(LOCATIONS_ALL,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsDMRace,DM_RACE_SURVIVOR))
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
scard.duel_masters_card=true
function scard.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end