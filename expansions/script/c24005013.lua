--Snork La, Shrine Guardian
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--cannot attack player
	dm.EnableCannotAttackPlayer(c)
	--return
	dm.AddEnterGraveEffect(c,0,PLAYER_PLAYER,true,nil,scard.retop,nil,scard.retcon)
end
scard.duel_masters_card=true
scard.retcon=dm.ReasonPlayerCondition(PLAYER_OPPONENT)
function scard.retop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsFaceup() then
		Duel.SendtoMana(eg,POS_FACEUP_UNTAPPED,REASON_EFFECT)
	end
end
