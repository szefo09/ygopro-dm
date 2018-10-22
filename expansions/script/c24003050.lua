--Pouch Shell
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to grave
	dm.AddSingleComeIntoPlayEffect(c,0,true,scard.tgtg,scard.tgop,DM_EFFECT_FLAG_CARD_CHOOSE)
end
scard.duel_masters_card=true
function scard.tgfilter(c)
	return c:IsFaceup() and c:IsEvolutionCreature() and c:GetStackCount()>0 and c:IsAbleToDMGrave()
end
scard.tgtg=dm.ChooseCardFunction(PLAYER_PLAYER,scard.tgfilter,0,DM_LOCATION_BATTLE,1,1,DM_HINTMSG_TOGRAVE)
function scard.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local mg=tc:GetStackGroup()
	local pos=tc:GetPosition()
	local seq=tc:GetSequence()
	if not tc:IsRelateToEffect(e) or mg:GetCount()==0 then return end
	local g=Group.CreateGroup()
	for mc in aux.Next(mg) do
		g:AddCard(mc)
	end
	Duel.SendtoDMGrave(tc,REASON_EFFECT)
	--keep stacked pile
	local sg=g:GetFirst()
	Duel.MoveToField(sg,tp,1-tp,DM_LOCATION_BATTLE,pos,true)
	g:RemoveCard(sg)
	Duel.MoveSequence(sg,seq)
	if g:GetCount()~=0 then
		Duel.PutOnTop(sg,g)
	end
end
