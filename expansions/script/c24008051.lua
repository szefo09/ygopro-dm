--Quixotic Hero Swine Snout
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--get ability
	dm.AddComeIntoPlayTriggerEffect(c,0,nil,nil,scard.abop,nil,scard.abcon)
end
scard.duel_masters_card=true
function scard.abcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsFaceup,1,e:GetHandler())
end
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
	--power up
	dm.RegisterEffectUpdatePower(c,c,1,3000*eg:GetCount())
end
