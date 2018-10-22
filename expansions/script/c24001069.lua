--Bolshack Dragon
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--power up
	dm.EnableUpdatePower(c,scard.powval,dm.SelfAttackerCondition)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
function scard.powval(e,c)
	return Duel.GetMatchingGroupCount(dm.DMGraveFilter(Card.IsCivilization),c:GetControler(),DM_LOCATION_GRAVE,0,nil,DM_CIVILIZATION_FIRE)*1000
end
