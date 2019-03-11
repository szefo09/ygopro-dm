--Hearty Cap'n Polligon
local kj=require "expansions.utility_ktcg"
local scard,sid=kj.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--return
	dm.EnableTurnEndSelfReturn(c,0,scard.retcon)
end
scard.kaijudo_card=true
function scard.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBrokenShieldCount()>0 and Duel.GetTurnPlayer()==tp
end
