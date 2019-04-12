--Soulswap
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--to mana & to battle
	dm.AddSpellCastEffect(c,0,scard.tmtg,scard.tmop,EFFECT_FLAG_CARD_TARGET)
	dm.AddShieldTriggerCastEffect(c,0,scard.tmtg,scard.tmop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.tmfilter(c)
	return c:IsFaceup() and c:IsAbleToMana()
end
scard.tmtg=dm.TargetCardFunction(PLAYER_SELF,scard.tmfilter,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,0,1,DM_HINTMSG_TOMANA)
function scard.tbfilter(c,e,tp,cost)
	return c:IsCreature() and c:IsManaCostBelow(cost)
		and c:IsCanSendtoBattle(e,0,tp,false,false) and c:IsCanBeEffectTarget(e)
end
function scard.tmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	if Duel.SendtoMana(tc,POS_FACEUP_UNTAPPED,REASON_EFFECT)==0 then return end
	local p=tc:GetOwner()
	local cost=Duel.GetMatchingGroupCount(dm.ManaZoneFilter(),p,DM_LOCATION_MANA,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOBATTLE)
	local g2=Duel.SelectMatchingCard(tp,dm.ManaZoneFilter(scard.tbfilter),p,DM_LOCATION_MANA,0,1,1,nil,e,p,cost)
	if g2:GetCount()==0 then return end
	Duel.SetTargetCard(g2)
	Duel.SendtoBattle(g2,0,p,p,false,false,POS_FACEUP_UNTAPPED)
end
