--Mana Bonanza
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--to mana
	dm.AddSpellCastEffect(c,0,nil,scard.tmop)
end
scard.duel_masters_card=true
function scard.tmop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetManaCount(tp)
	Duel.SendDecktoptoMZone(tp,ct,POS_FACEUP_TAPPED,REASON_EFFECT)
end
