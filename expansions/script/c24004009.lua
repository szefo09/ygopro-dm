--Full Defensor
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--get ability
	dm.AddSpellCastEffect(c,0,nil,scard.abop)
	dm.AddShieldTriggerCastEffect(c,0,nil,scard.abop)
end
scard.duel_masters_card=true
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,DM_LOCATION_BATTLE,0,nil)
	if g:GetCount()==0 then return end
	local reset_count=1
	if Duel.GetTurnPlayer()==tp then reset_count=2 end
	for tc in aux.Next(g) do
		--blocker
		dm.GainEffectBlocker(e:GetHandler(),tc,1,RESET_PHASE+PHASE_DRAW,reset_count)
	end
end
