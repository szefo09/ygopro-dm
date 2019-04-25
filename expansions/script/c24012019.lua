--Nemonex, Bajula's Robomantis
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,scard.evofilter)
	--power up
	dm.EnableUpdatePower(c,2000,nil,DM_LOCATION_BATTLE,0,scard.powtg)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(sid,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_CONFIRM)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(DM_LOCATION_BATTLE)
	e1:SetCondition(scard.tgcon)
	e1:SetTarget(scard.tgtg)
	e1:SetOperation(scard.tgop)
	c:RegisterEffect(e1)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_XENOPARTS,DM_RACE_GIANT_INSECT,DM_RACE_GIANT}
--evolution
function scard.evofilter(c)
	return c:DMIsEvolutionRace(DM_RACE_XENOPARTS) or c:DMIsEvolutionRace(DM_RACE_GIANT_INSECT)
end
--power up
function scard.powtg(e,c)
	return c~=e:GetHandler() and c:IsFaceup() and (c:DMIsRace(DM_RACE_XENOPARTS) or c:DMIsRace(DM_RACE_GIANT_INSECT))
end
--to grave
function scard.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	return a:IsControler(tp) and (a:DMIsRace(DM_RACE_XENOPARTS) or a:DMIsRace(DM_RACE_GIANT_INSECT))
		and not a:IsBlocked() and Duel.GetAttackTarget()==nil
end
scard.tgtg=dm.TargetCardFunction(PLAYER_OPPO,dm.ManaZoneFilter(Card.DMIsAbleToGrave),0,DM_LOCATION_MANA,1,1,DM_HINTMSG_TOGRAVE)
scard.tgop=dm.TargetSendtoGraveOperation
