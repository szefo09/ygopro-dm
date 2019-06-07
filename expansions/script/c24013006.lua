--宣凶師ドロシア
--Dorothea, the Explorer
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--draw
	dm.AddTriggerEffect(c,0,EVENT_DISCARD,nil,nil,scard.drop,nil,scard.drcon)
end
scard.duel_masters_card=true
scard.drcon=aux.AND(dm.EventPlayerCondition(PLAYER_SELF),dm.TurnPlayerCondition(PLAYER_OPPO))
function scard.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,eg:GetCount(),REASON_EFFECT)
end
