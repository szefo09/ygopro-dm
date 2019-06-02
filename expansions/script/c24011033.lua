--Bonfire Lizard
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--wave striker (destroy)
	dm.EnableWaveStriker(c)
	dm.AddEffectDescription(c,1,dm.WaveStrikerCondition)
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,scard.desop,nil,dm.WaveStrikerCondition)
end
scard.duel_masters_card=true
function scard.desfilter(c)
	return c:IsFaceup() and c:IsHasEffect(DM_EFFECT_BLOCKER)
end
scard.desop=dm.DestroyOperation(PLAYER_SELF,scard.desfilter,0,DM_LOCATION_BZONE,0,2)
