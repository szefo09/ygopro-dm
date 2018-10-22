--黒神龍ガルバロス
--Necrodragon Galbalos
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--choose one
	dm.AddSingleAttackTriggerEffect(c,0,true,scard.abtg,scard.abop)
	dm.AddSingleDestroyedEffect(c,0,true,scard.abtg,scard.abop)
end
scard.duel_masters_card=true
function scard.abtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(dm.ShieldZoneFilter(Card.IsAbleToDMGrave),tp,0,DM_LOCATION_SHIELD,1,nil)
	local b2=Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_HAND,1,nil)
	local b3=Duel.IsExistingMatchingCard(nil,tp,0,DM_LOCATION_BATTLE,1,nil)
	if chk==0 then return b1 or b2 or b3 end
	local ops={}
	local opval={}
	local off=1
	if b1 then
		ops[off]=aux.Stringid(sid,1)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(sid,2)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(sid,3)
		opval[off-1]=3
		off=off+1
	end
	local opt=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[opt]
	e:SetLabel(sel)
end
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,dm.ShieldZoneFilter(),tp,0,DM_LOCATION_SHIELD,1,1,nil)
		if g:GetCount()==0 then return end
		Duel.HintSelection(g)
		Duel.SendtoDMGrave(g,REASON_EFFECT)
	elseif sel==2 then
		Duel.DiscardHand(1-tp,nil,1,1,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,0,DM_LOCATION_BATTLE,1,1,nil)
		if g:GetCount()==0 then return end
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
