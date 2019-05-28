--Funky Wizard
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--draw
	dm.AddSingleComeIntoPlayTriggerEffect(c,0,nil,nil,scard.drop)
end
scard.duel_masters_card=true
function scard.drop(e,tp,eg,ep,ev,re,r,rp)
	scard.draw(tp)
	scard.draw(1-tp)
end
function scard.draw(tp)
	if Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,DM_QHINTMSG_DRAW) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
