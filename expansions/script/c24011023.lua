--Warped Lunatron
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--cannot untap
	dm.EnableEffectCustom(c,DM_EFFECT_CANNOT_CHANGE_POS_ABILITY,scard.abcon,DM_LOCATION_BATTLE,0,scard.abtg)
	--tap & untap
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(sid,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHANGE_POS)
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetCondition(scard.poscon)
	e1:SetCost(scard.poscost)
	e1:SetTarget(scard.postg)
	e1:SetOperation(scard.posop)
	c:RegisterEffect(e1)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
--cannot untap
function scard.abcon(e)
	return Duel.CheckEvent(DM_EVENT_UNTAP_STEP) and e:GetHandler():GetFlagEffect(sid)==0
end
scard.abtg=aux.TargetBoolFunction(Card.IsTapped)
--tap & untap
function scard.cfilter(c,turnp)
	return c:IsControler(turnp) and not c:IsStatus(STATUS_CONTINUOUS_POS) and c:IsUntapped() and c:IsReason(REASON_RULE)
end
function scard.poscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(scard.cfilter,1,nil,Duel.GetTurnPlayer())
end
function scard.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	--register flag effect to allow untapping creatures with Warped Lunatron's other ability
	e:GetHandler():RegisterFlagEffect(sid,RESET_CHAIN,0,1)
end
function scard.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(dm.ManaZoneFilter(Card.IsUntapped),Duel.GetTurnPlayer(),DM_LOCATION_MANA,0,1,nil) end
end
function scard.posfilter(c)
	return c:IsFaceup() and c:IsTapped()
end
function scard.posop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	local turnp=Duel.GetTurnPlayer()
	local maxct=Duel.GetMatchingGroupCount(dm.ManaZoneFilter(Card.IsUntapped),turnp,DM_LOCATION_MANA,0,nil)
	Duel.Hint(HINT_SELECTMSG,turnp,DM_HINTMSG_TAP)
	local g1=Duel.SelectMatchingCard(turnp,dm.ManaZoneFilter(Card.IsUntapped),turnp,DM_LOCATION_MANA,0,1,maxct,nil)
	local posct=Duel.ChangePosition(g1,POS_FACEUP_TAPPED)
	if posct<2 then return end
	local ct=math.floor(posct/2)
	Duel.Hint(HINT_SELECTMSG,turnp,DM_HINTMSG_UNTAP)
	local g2=Duel.SelectMatchingCard(turnp,scard.posfilter,turnp,DM_LOCATION_BATTLE,0,ct,ct,nil)
	if g2:GetCount()==0 then return end
	Duel.HintSelection(g2)
	Duel.ChangePosition(g2,POS_FACEUP_UNTAPPED)
end
