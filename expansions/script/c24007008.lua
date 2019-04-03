--Justice Jamming
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--tap
	dm.AddSpellCastEffect(c,0,nil,scard.posop)
end
scard.duel_masters_card=true
function scard.posfilter(c,civ)
	return c:IsFaceup() and c:IsUntapped() and c:IsCivilization(civ)
end
function scard.posop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(scard.posfilter,tp,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,nil,DM_CIVILIZATION_DARKNESS)
	local g2=Duel.GetMatchingGroup(scard.posfilter,tp,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,nil,DM_CIVILIZATION_FIRE)
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
	local g=(opt==1 and g1) or (opt==2 and g2)
	Duel.ChangePosition(g,POS_FACEUP_TAPPED)
end
