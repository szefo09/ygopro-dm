--Grave Worm Q
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--survivor (return)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(sid,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(DM_EVENT_COME_INTO_PLAY_SUCCESS)
	e1:SetTarget(scard.rettg)
	e1:SetOperation(dm.SendtoHandOperation(PLAYER_PLAYER,dm.DMGraveFilter(scard.retfilter),DM_LOCATION_GRAVE,0,1))
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(DM_LOCATION_BATTLE)
	e2:SetTargetRange(LOCATIONS_ALL,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.DMIsRace,DM_RACE_SURVIVOR))
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
scard.duel_masters_card=true
function scard.retfilter(c)
	return c:DMIsRace(DM_RACE_SURVIVOR) and c:IsAbleToHand()
end
function scard.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(dm.DMGraveFilter(scard.retfilter),tp,DM_LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
