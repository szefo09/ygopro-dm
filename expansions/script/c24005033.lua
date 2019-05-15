--Slime Veil
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--get ability
	dm.AddSpellCastEffect(c,0,nil,scard.regop)
end
scard.duel_masters_card=true
function scard.regop(e,tp,eg,ep,ev,re,r,rp)
	--get ability
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(sid,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_DRAW)
	e1:SetCountLimit(1)
	e1:SetCondition(dm.TurnPlayerCondition(PLAYER_OPPO))
	e1:SetOperation(scard.abop)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,DM_LOCATION_BATTLE,nil)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_CARD,0,sid)
	for tc in aux.Next(g) do
		--must attack
		dm.RegisterEffectCustom(e:GetHandler(),tc,1,EFFECT_MUST_ATTACK)
	end
end
