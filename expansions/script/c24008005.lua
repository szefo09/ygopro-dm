--Kachua, Keeper of the Icegate
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--tap ability (search) (to battle)
	dm.EnableTapAbility(c,0,scard.tbtg,scard.tbop)
end
scard.duel_masters_card=true
scard.tbtg=dm.CheckDeckFunction(PLAYER_SELF)
function scard.tbfilter(c,e,tp)
	return c:DMIsRace(DM_RACE_DRAGON) and c:IsCanSendtoBattle(e,0,tp,false,false)
end
function scard.tbop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOBATTLE)
	local tc=Duel.SelectMatchingCard(tp,scard.tbfilter,tp,LOCATION_DECK,0,0,1,nil,e,tp):GetFirst()
	if not tc or not Duel.SendtoBattleStep(tc,0,tp,tp,false,false,POS_FACEUP_UNTAPPED) then return end
	local c=e:GetHandler()
	--speed attacker
	dm.RegisterEffectCustom(c,tc,2,DM_EFFECT_SPEED_ATTACKER)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(sid,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetCountLimit(1)
	e1:SetOperation(scard.desop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	Duel.SendtoBattleComplete()
end
function scard.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,sid)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
