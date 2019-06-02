--放出のゲッチェル
--Getchell, the Emitter
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to shield or to mana
	dm.AddSingleTriggerEffectCustom(c,0,EVENT_ATTACK_ANNOUNCE,true,scard.tstg,scard.tsop)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
scard.tstg=dm.CheckCardFunction(aux.OR(Card.IsAbleToShield,Card.IsAbleToMana),LOCATION_HAND,0)
function scard.tsop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToShield,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToMana,tp,LOCATION_HAND,0,nil)
	if g1:GetCount()==0 and g2:GetCount()==0 then return end
	local ops={}
	local t={}
	if g1:GetCount()>0 then
		table.insert(ops,aux.Stringid(sid,1))
		table.insert(t,1)
	end
	if g2:GetCount()>0 then
		table.insert(ops,aux.Stringid(sid,2))
		table.insert(t,2)
	end
	local opt=t[Duel.SelectOption(tp,table.unpack(ops))+1]
	local desc=(opt==1 and DM_HINTMSG_TOSZONE) or (opt==2 and DM_HINTMSG_TOMZONE)
	local g=(opt==1 and g1) or (opt==2 and g2)
	Duel.Hint(HINT_SELECTMSG,tp,desc)
	local sg=g:Select(tp,1,1,nil)
	if opt==1 then
		Duel.SendtoShield(sg)
	elseif opt==2 then
		Duel.SendtoMana(sg,POS_FACEUP_UNTAPPED,REASON_EFFECT)
	end
end
