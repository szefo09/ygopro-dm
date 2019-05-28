--Skysword, the Savage Vizier
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to mana, to shield
	dm.AddSingleComeIntoPlayTriggerEffect(c,0,nil,nil,scard.tmop)
end
scard.duel_masters_card=true
function scard.tmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendDecktoptoMana(tp,1,POS_FACEUP_UNTAPPED,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.SendDecktoptoShield(tp,1)
end
