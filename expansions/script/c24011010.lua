--Lamiel, Destiny Enforcer
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--wave striker (draw)
	dm.EnableWaveStriker(c)
	dm.AddEffectDescription(c,1,dm.WaveStrikerCondition)
	dm.AddDestroyedEffect(c,0,true,dm.DrawTarget(PLAYER_SELF),scard.drop,nil,scard.drcon)
end
scard.duel_masters_card=true
function scard.cfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(DM_LOCATION_BATTLE)
end
function scard.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(scard.cfilter,1,nil,tp) and dm.WaveStrikerCondition(e) and Duel.GetTurnPlayer()~=tp
end
function scard.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	Duel.Draw(tp,eg:GetCount(),REASON_EFFECT)
end