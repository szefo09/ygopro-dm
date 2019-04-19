--ボルブレイズ・ドラゴン
--Bolblaze Dragon
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--speed attacker
	dm.EnableEffectCustom(c,DM_EFFECT_SPEED_ATTACKER)
	--to grave (mana)
	dm.AddSingleAttackTriggerEffect(c,0,true,scard.tgtg1,tgop1)
	--to grave (shield)
	dm.AddBreakShieldEffect(c,1,true,scard.tgtg2,scard.tgop2,nil,scard.tgcon)
	--attack untapped
	dm.EnableAttackUntapped(c)
end
scard.duel_masters_card=true
scard.tgtg1=dm.CheckCardFunction(dm.ManaZoneFilter(Card.DMIsAbleToGrave),0,DM_LOCATION_MANA)
scard.tgop1=dm.SendtoGraveOperation(PLAYER_SELF,dm.ManaZoneFilter(),0,DM_LOCATION_MANA,1)
function scard.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()==e:GetHandler() and eg:IsExists(Card.DMIsAbleToGrave,1,nil)
end
function scard.tgtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	for tc in aux.Next(eg) do
		--chain limit
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
	end
end
function scard.tgop2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	Duel.DMSendtoGrave(eg,REASON_EFFECT)
end
