--Factory Shell Q
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--survivor (search) (to hand)
	dm.AddSingleComeIntoPlayEffect(c,0,nil,dm.HintTarget,scard.thop)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(sid,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(DM_EVENT_COME_INTO_PLAY_SUCCESS)
	e1:SetTarget(dm.HintTarget)
	e1:SetOperation(scard.thop)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(DM_LOCATION_BATTLE)
	e2:SetTargetRange(LOCATION_ALL,0)
	e2:SetTarget(scard.abtg)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
scard.duel_masters_card=true
function scard.thfilter(c)
	return c:DMIsRace(DM_RACE_SURVIVOR) and c:IsAbleToHand()
end
scard.thop=dm.SendtoHandOperation(PLAYER_PLAYER,scard.thfilter,LOCATION_DECK,0,0,1,true)
function scard.abtg(e,c)
	return c~=e:GetHandler() and c:DMIsRace(DM_RACE_SURVIVOR)
end
