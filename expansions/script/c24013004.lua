--霊樹海嶺ガウルザガンタ
--Gaulzaganta, Spirit of the Woodland Ridges
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--sympathy (gel fish, snow faerie)
	dm.EnableSympathy(c,DM_RACE_GEL_FISH,DM_RACE_SNOW_FAERIE)
	--tap
	dm.AddComeIntoPlayTriggerEffect(c,0,nil,nil,scard.posop,nil,scard.poscon)
end
scard.duel_masters_card=true
function scard.cfilter(c)
	return c:IsFaceup() and c:IsEvolution()
end
function scard.poscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(scard.cfilter,1,nil)
end
function scard.posfilter(c)
	return c:IsFaceup() and c:IsEvolution() and c:IsUntapped()
end
scard.posop=dm.TapOperation(nil,scard.posfilter,DM_LOCATION_BZONE,DM_LOCATION_BZONE)
