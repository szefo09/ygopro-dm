--Thought Probe
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--draw
	dm.AddSpellCastEffect(c,0,nil,scard.drop)
	dm.AddShieldTriggerCastEffect(c,0,nil,scard.drop)
end
scard.duel_masters_card=true
function scard.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,0,DM_LOCATION_BATTLE,nil)>=3 then
		Duel.Draw(tp,3,REASON_EFFECT)
	end
end
