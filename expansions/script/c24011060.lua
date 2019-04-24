--Miraculous Rebirth
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--destroy & search (to battle)
	dm.AddSpellCastEffect(c,0,nil,scard.desop)
end
scard.duel_masters_card=true
function scard.desfilter(c)
	return c:IsFaceup() and c:IsPowerBelow(5000)
end
function scard.tbfilter(c,e,tp,cost)
	return c:IsCreature() and c:IsManaCost(cost) and c:IsCanSendtoBattle(e,0,tp,false,false)
end
function scard.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_DESTROY)
	local tc=Duel.SelectMatchingCard(tp,scard.desfilter,tp,0,DM_LOCATION_BATTLE,1,1,nil):GetFirst()
	if not tc then return end
	Duel.HintSelection(Group.FromCards(tc))
	if Duel.Destroy(tc,REASON_EFFECT)==0 then return end
	local cost=tc:GetManaCost()
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOBATTLE)
	local g=Duel.SelectMatchingCard(tp,scard.tbfilter,tp,LOCATION_DECK,0,0,1,nil,e,tp,cost)
	if g:GetCount()==0 then return end
	Duel.SendtoBattle(g,0,tp,tp,false,false,POS_FACEUP_UNTAPPED)
end