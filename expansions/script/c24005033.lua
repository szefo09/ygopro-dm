--Slime Veil
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--get ability
	dm.AddSpellCastEffect(c,0,nil,scard.abop)
end
scard.duel_masters_card=true
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(sid,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_DRAW)
	e1:SetCountLimit(1)
	e1:SetCondition(dm.TurnPlayerCondition(PLAYER_OPPONENT))
	e1:SetOperation(scard.maop)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end
function scard.maop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,sid)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,DM_LOCATION_BATTLE,nil)
	if g:GetCount()==0 then return end
	for tc in aux.Next(g) do
		--attack if able
		dm.RegisterEffectCustom(e:GetHandler(),tc,2,EFFECT_MUST_ATTACK)
	end
end
