--聖神龍アルティメス
--Altimeth, Holy Divine Dragon
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--get ability
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(sid,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_DRAW)
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetCountLimit(1)
	e1:SetOperation(scard.abop)
	c:RegisterEffect(e1)
	--to shield
	dm.AddSingleLeavePlayEffect(c,1,nil,nil,dm.DecktopSendtoShieldOperation(PLAYER_PLAYER,PLAYER_PLAYER,1))
	--tap
	dm.AddSingleComeIntoPlayEffect(c,2,true,scard.postg,scard.posop)
end
scard.duel_masters_card=true
--get ability
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,DM_LOCATION_BATTLE,0,nil)
	if g:GetCount()==0 then return end
	for tc in aux.Next(g) do
		--blocker
		dm.GainEffectBlocker(c,tc,3,RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	end
end
--tap
scard.postg=dm.CheckCardFunction(Card.IsUntapped,0,DM_LOCATION_BATTLE)
scard.posop=dm.TapUntapOperation(nil,Card.IsUntapped,0,DM_LOCATION_BATTLE,nil,nil,POS_FACEUP_TAPPED)
