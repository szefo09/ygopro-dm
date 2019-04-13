--Funky Wizard
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--draw
	dm.AddSingleComeIntoPlayEffect(c,0,nil,nil,scard.drop)
end
scard.duel_masters_card=true
function scard.draw(player)
	if Duel.IsPlayerCanDraw(player,1) and Duel.SelectYesNo(player,DM_QHINTMSG_DRAW) then
		Duel.Draw(player,1,REASON_EFFECT)
	end
end
function scard.drop(e,tp,eg,ep,ev,re,r,rp)
	scard.draw(tp)
	scard.draw(1-tp)
end
