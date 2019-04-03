--Slash Charger
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--search (to grave)
	dm.AddSpellCastEffect(c,0,nil,scard.tgop)
	--charger
	dm.EnableEffectCustom(c,DM_EFFECT_CHARGER)
end
scard.duel_masters_card=true
function scard.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
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
	local p=(opt==1 and tp) or (opt==2 and 1-tp)
	if opt==1 then g=g1 elseif opt==2 then g=g2 end
	if opt==1 then p=tp elseif opt==2 then p=1-tp end
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOGRAVE)
	local sg=g:Select(tp,0,1,nil)
	if sg:GetCount()>0 then
		Duel.DMSendtoGrave(sg,REASON_EFFECT)
	else Duel.ShuffleDeck(p) end
end
--[[
	References
		1. Mooyan Curry
		https://github.com/Fluorohydride/ygopro-scripts/blob/master/c58074572.lua
]]
