--Glory Snow
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--to mana
	dm.AddSpellCastEffect(c,0,nil,scard.tmop)
end
scard.duel_masters_card=true
function scard.tmop(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetMatchingGroupCount(dm.ManaZoneFilter(),tp,DM_LOCATION_MANA,0,nil)
	local ct2=Duel.GetMatchingGroupCount(dm.ManaZoneFilter(),tp,0,DM_LOCATION_MANA,nil)
	if ct1<ct2 then Duel.SendDecktoptoMana(tp,2,POS_FACEUP_UNTAPPED,REASON_EFFECT) end
end
