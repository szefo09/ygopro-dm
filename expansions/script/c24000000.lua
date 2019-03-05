--Duel Masters Rules
--Not fully implemented: Monster must change to defense mode for attack cost
--Not fully implemented: "Destroy a monster by battle" does not apply if monster is destroyed by rule
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	--apply
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_NO_TURN_RESET)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATIONS_ALL)
	e1:SetCountLimit(1)
	e1:SetOperation(scard.operation)
	c:RegisterEffect(e1)
end
scard.duel_masters_card=true
--apply
function scard.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,sid)>0 or Duel.GetFlagEffect(1-tp,sid)>0 then return end
	Duel.RegisterFlagEffect(tp,sid,0,0,0)
	--apply rules for you
	local fc1=Duel.GetFieldCard(tp,DM_LOCATION_SHIELD,5)
	if fc1 then
		Duel.SendtoDeck(fc1,PLAYER_OWNER,DECK_SEQUENCE_UNEXIST,REASON_RULE)
		Duel.BreakEffect()
	end
	Duel.MoveToField(c,tp,tp,DM_LOCATION_SHIELD,POS_FACEUP,true)
	--apply rules for opponent
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATIONS_ALL,nil,sid)
	if g:GetCount()>0 then
		local fc2=Duel.GetFieldCard(1-tp,DM_LOCATION_SHIELD,5)
		if fc2 then
			Duel.SendtoDeck(fc2,PLAYER_OWNER,DECK_SEQUENCE_UNEXIST,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(g:GetFirst(),tp,1-tp,DM_LOCATION_SHIELD,POS_FACEUP,true)
	else
		local rule=Duel.CreateToken(1-tp,sid)
		Duel.MoveToField(rule,tp,1-tp,DM_LOCATION_SHIELD,POS_FACEUP,true)
	end
	--shuffle your deck
	local hg1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if hg1:GetCount()>0 then
		Duel.SendtoDeck(hg1,PLAYER_OWNER,DECK_SEQUENCE_SHUFFLE,REASON_RULE)
		Duel.ShuffleDeck(tp)
	end
	--shuffle opponent's deck
	local hg2=Duel.GetFieldGroup(1,LOCATION_HAND,0)
	if hg2:GetCount()>0 then
		Duel.SendtoDeck(hg2,PLAYER_OWNER,DECK_SEQUENCE_SHUFFLE,REASON_RULE)
		Duel.ShuffleDeck(1-tp)
	end
	--check deck size
	local b1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)~=40
	local b2=Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)~=40
	--check for non-duel masters cards
	local f=function(c)
		return not c.duel_masters_card
	end
	local b3=Duel.GetMatchingGroupCount(f,tp,LOCATIONS_ALL,0,nil)>0
	local b4=Duel.GetMatchingGroupCount(f,1-tp,LOCATIONS_ALL,0,nil)>0
	if b1 then Duel.Hint(HINT_MESSAGE,tp,DM_DECKERROR_DECKCOUNT) end
	if b2 then Duel.Hint(HINT_MESSAGE,1-tp,DM_DECKERROR_DECKCOUNT) end
	if b3 then Duel.Hint(HINT_MESSAGE,tp,DM_DECKERROR_NONDM) end
	if b4 then Duel.Hint(HINT_MESSAGE,1-tp,DM_DECKERROR_NONDM) end
	if (b1 and b2) or (b3 and b4) then
		Duel.Win(PLAYER_NONE,DM_WIN_REASON_INVALID)
		return
	elseif b1 or b3 then
		Duel.Win(1-tp,DM_WIN_REASON_INVALID)
		return
	elseif b2 or b4 then
		Duel.Win(tp,DM_WIN_REASON_INVALID)
		return
	end
	--set your life
	Duel.SetLP(tp,1)
	--set opponent's life
	Duel.SetLP(1-tp,1)
	--set your shields
	Duel.SendDecktoptoShield(tp,5)
	--set opponent's shields
	Duel.SendDecktoptoShield(1-tp,5)
	--draw your starting hand
	Duel.Draw(tp,5,REASON_RULE)
	--draw opponent's starting hand
	Duel.Draw(1-tp,5,REASON_RULE)
	--untap
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetDescription(aux.Stringid(sid,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetOperation(scard.posop1)
	Duel.RegisterEffect(e1,tp)
	--charge
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetDescription(aux.Stringid(sid,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetOperation(scard.tmop)
	Duel.RegisterEffect(e2,tp)
	--summoning sickness
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(scard.regcon1)
	e3:SetOperation(scard.regop1)
	Duel.RegisterEffect(e3,tp)
	--chain limit
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetOperation(scard.chop)
	Duel.RegisterEffect(e4,tp)
	--attack cost workaround
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_DAMAGE_STEP_END)
	e5:SetOperation(scard.posop2)
	Duel.RegisterEffect(e5,tp)
	--attack player
	local e6=Effect.CreateEffect(c)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_DIRECT_ATTACK)
	e6:SetTargetRange(DM_LOCATION_BATTLE,DM_LOCATION_BATTLE)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsCanAttackPlayer))
	Duel.RegisterEffect(e6,tp)
	--destroy 0 power
	local e7=Effect.CreateEffect(c)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_ADJUST)
	e7:SetCondition(scard.descon)
	e7:SetOperation(scard.desop1)
	Duel.RegisterEffect(e7,tp)
	--discard spell
	local e8=Effect.CreateEffect(c)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_CHAINING)
	e8:SetOperation(aux.chainreg)
	Duel.RegisterEffect(e8,tp)
	local e9=e8:Clone()
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_DELAY)
	e9:SetCode(EVENT_CHAIN_SOLVED)
	e9:SetOperation(scard.tgop1)
	Duel.RegisterEffect(e9,tp)
	--register broken shield
	local e10=Effect.CreateEffect(c)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_DELAY)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_TO_HAND)
	e10:SetCondition(scard.regcon2)
	e10:SetOperation(scard.regop2)
	Duel.RegisterEffect(e10,tp)
	--win game
	local e11=Effect.CreateEffect(c)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_ADJUST)
	e11:SetCondition(scard.wincon)
	e11:SetOperation(scard.winop)
	Duel.RegisterEffect(e11,tp)
	--can set in szone
	local e12=Effect.CreateEffect(c)
	e12:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_IGNORE_RANGE)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_MONSTER_SSET)
	e12:SetTargetRange(LOCATIONS_ALL,LOCATIONS_ALL)
	e12:SetTarget(aux.TargetBoolFunction(Card.IsCreature))
	e12:SetValue(TYPE_SPELL)
	Duel.RegisterEffect(e12,tp)
	local e13=Effect.CreateEffect(c)
	e13:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_PLAYER_TARGET)
	e13:SetType(EFFECT_TYPE_FIELD)
	e13:SetCode(EFFECT_CANNOT_SSET)
	e13:SetTargetRange(1,1)
	e13:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_HAND))
	Duel.RegisterEffect(e13,tp)
	--cannot trigger
	local e14=Effect.CreateEffect(c)
	e14:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e14:SetType(EFFECT_TYPE_FIELD)
	e14:SetCode(EFFECT_CANNOT_TRIGGER)
	e14:SetTargetRange(DM_LOCATION_SHIELD,DM_LOCATION_SHIELD)
	e14:SetTarget(aux.TargetBoolFunction(Card.IsFacedown))
	Duel.RegisterEffect(e14,tp)
	--no battle damage
	local e15=Effect.CreateEffect(c)
	e15:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e15:SetType(EFFECT_TYPE_FIELD)
	e15:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e15:SetTargetRange(DM_LOCATION_BATTLE,DM_LOCATION_BATTLE)
	e15:SetValue(1)
	Duel.RegisterEffect(e15,tp)
	--set def equal to atk
	local e16=Effect.CreateEffect(c)
	e16:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_DELAY)
	e16:SetType(EFFECT_TYPE_FIELD)
	e16:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e16:SetTargetRange(DM_LOCATION_BATTLE,DM_LOCATION_BATTLE)
	e16:SetValue(function(e,c)
		return c:GetPower()
	end)
	Duel.RegisterEffect(e16,tp)
	--destroy equal & lower def
	local e17=Effect.CreateEffect(c)
	e17:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e17:SetDescription(aux.Stringid(sid,2))
	e17:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e17:SetCode(EVENT_DAMAGE_STEP_END)
	e17:SetOperation(scard.desop2)
	Duel.RegisterEffect(e17,tp)
	--to grave redirect
	local e18=Effect.CreateEffect(c)
	e18:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e18:SetType(EFFECT_TYPE_FIELD)
	e18:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e18:SetTargetRange(LOCATIONS_ALL,LOCATIONS_ALL)
	e18:SetTarget(scard.tgtg)
	e18:SetValue(DM_LOCATION_GRAVE)
	Duel.RegisterEffect(e18,tp)
	local e19=Effect.CreateEffect(c)
	e19:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e19:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e19:SetCode(EVENT_LEAVE_FIELD)
	e19:SetCondition(scard.tgcon)
	e19:SetOperation(scard.tgop2)
	Duel.RegisterEffect(e19,tp)
	--attack first turn
	if EFFECT_BP_FIRST_TURN then
		local e20=Effect.CreateEffect(c)
		e20:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_PLAYER_TARGET)
		e20:SetType(EFFECT_TYPE_FIELD)
		e20:SetCode(EFFECT_BP_FIRST_TURN)
		e20:SetTargetRange(1,1)
		Duel.RegisterEffect(e20,tp)
	end
	--skip main phase 2
	local e21=Effect.CreateEffect(c)
	e21:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_PLAYER_TARGET)
	e21:SetType(EFFECT_TYPE_FIELD)
	e21:SetCode(EFFECT_SKIP_M2)
	e21:SetTargetRange(1,1)
	Duel.RegisterEffect(e21,tp)
	--infinite hand
	local e22=Effect.CreateEffect(c)
	e22:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_PLAYER_TARGET)
	e22:SetType(EFFECT_TYPE_FIELD)
	e22:SetCode(EFFECT_HAND_LIMIT)
	e22:SetTargetRange(1,1)
	e22:SetValue(MAX_NUMBER)
	Duel.RegisterEffect(e22,tp)
	--infinite attacks
	local e23=Effect.CreateEffect(c)
	e23:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e23:SetType(EFFECT_TYPE_FIELD)
	e23:SetCode(EFFECT_EXTRA_ATTACK)
	e23:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e23:SetValue(MAX_NUMBER)
	Duel.RegisterEffect(e23,tp)
	--cannot change position
	local e24=Effect.CreateEffect(c)
	e24:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e24:SetType(EFFECT_TYPE_FIELD)
	e24:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e24:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	Duel.RegisterEffect(e24,tp)
	--no effect damage
	local e25=Effect.CreateEffect(c)
	e25:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_PLAYER_TARGET)
	e25:SetType(EFFECT_TYPE_FIELD)
	e25:SetCode(EFFECT_CHANGE_DAMAGE)
	e25:SetTargetRange(1,1)
	e25:SetValue(function(e,re,val,r,rp,rc)
		if bit.band(r,REASON_EFFECT)~=0 then return 0
		else return val end
	end)
	Duel.RegisterEffect(e25,tp)
	local e26=Effect.CreateEffect(c)
	e26:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_PLAYER_TARGET)
	e26:SetType(EFFECT_TYPE_FIELD)
	e26:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e26:SetTargetRange(1,1)
	Duel.RegisterEffect(e26,tp)
	--cannot summon/mset
	local e27=Effect.CreateEffect(c)
	e27:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_PLAYER_TARGET)
	e27:SetType(EFFECT_TYPE_FIELD)
	e27:SetCode(EFFECT_CANNOT_SUMMON)
	e27:SetTargetRange(1,1)
	Duel.RegisterEffect(e27,tp)
	local e28=e27:Clone()
	e28:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e28,tp)
	--no replay
	local e29=Effect.CreateEffect(c)
	e29:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e29:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e29:SetCode(EVENT_LEAVE_FIELD)
	e29:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_ONFIELD) and Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE)
	end)
	e29:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local a=Duel.GetAttacker()
		local d=Duel.GetAttackTarget()
		--[[if not d or not d:IsOnField() then
			Duel.ChangePosition(a,POS_FACEUP_TAPPED)
			return
		end]]
		Duel.ChangeAttackTarget(d)
	end)
	Duel.RegisterEffect(e29,tp)
end
--untap
function scard.posfilter(c)
	return c:IsFaceup() and c:IsCreature() and c:IsAbleToUntap()
end
function scard.posop1(e,tp,eg,ep,ev,re,r,rp)
	local turnp=Duel.GetTurnPlayer()
	local g1=Duel.GetMatchingGroup(scard.posfilter,turnp,DM_LOCATION_BATTLE,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToUntap,turnp,DM_LOCATION_MANA,0,nil)
	g1:Merge(g2)
	Duel.ChangePosition(g1,POS_FACEUP_UNTAPPED)
end
--charge
function scard.tmop(e,tp,eg,ep,ev,re,r,rp)
	local turnp=Duel.GetTurnPlayer()
	Duel.Hint(HINT_SELECTMSG,turnp,DM_HINTMSG_TOMANA)
	local g=Duel.SelectMatchingCard(turnp,Card.IsAbleToMana,turnp,LOCATION_HAND,0,0,1,nil)
	Duel.SendtoMana(g,POS_FACEUP_UNTAPPED,REASON_RULE)
end
--summoning sickness
function scard.cfilter1(c,tp)
	return not c:IsCanAttackTurn() and c:IsControler(tp)
end
function scard.regcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(scard.cfilter1,1,nil,Duel.GetTurnPlayer())
end
function scard.regop1(e,tp,eg,ep,ev,re,r,rp)
	for ec in aux.Next(eg) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(DM_DESC_SUMMONSICKNESS)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetLabelObject(ec)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		ec:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_ADJUST)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetLabelObject(e1)
		e2:SetCondition(scard.rscon)
		e2:SetOperation(scard.rsop)
		e2:SetReset(RESET_EVENT+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function scard.rscon(e)
	return e:GetLabelObject() and e:GetLabelObject():GetLabelObject() and e:GetLabelObject():GetLabelObject():IsCanAttackTurn()
end
function scard.rsop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	te:Reset()
end
--chain limit
function scard.chop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasProperty(DM_EFFECT_FLAG_CHAIN_LIMIT) then
		Duel.SetChainLimit(scard.chlimit)
	end
end
function scard.chlimit(e,rp,tp)
	return not e:IsHasProperty(DM_EFFECT_FLAG_CHAIN_LIMIT)
end
--attack cost workaround
function scard.posop2(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if a:IsRelateToBattle() then
		Duel.ChangePosition(a,POS_FACEUP_TAPPED)
	end
end
--destroy 0 power
function scard.desfilter(c)
	return c:IsFaceup() and c:GetPower()<=0 and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function scard.descon(e)
	return Duel.IsExistingMatchingCard(scard.desfilter,0,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,1,nil)
end
function scard.desop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(scard.desfilter,0,DM_LOCATION_BATTLE,DM_LOCATION_BATTLE,nil)
	Duel.Destroy(g,REASON_RULE)
end
--discard spell
function scard.tgop1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not rc:IsSpell() or not rc:IsLocation(LOCATION_HAND) or e:GetHandler():GetFlagEffect(1)==0 then return end
	if re:IsHasProperty(DM_EFFECT_FLAG_CHARGE) and rc:IsAbleToMana() then
		Duel.SendtoMana(rc,POS_FACEUP_UNTAPPED,REASON_RULE)
	else
		Duel.DMSendtoGrave(rc,REASON_RULE+REASON_DISCARD)
	end
end
--register broken shield
function scard.cfilter2(c)
	return c:IsPreviousLocation(DM_LOCATION_SHIELD) and c:GetPreviousSequence()<5 and c:IsReason(DM_REASON_BREAK)
end
function scard.regcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(scard.cfilter2,1,nil)
end
function scard.regop2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	for ec in aux.Next(eg) do
		if not ec:IsHasEffect(DM_EFFECT_SHIELD_TRIGGER) then Duel.Hint(HINT_MESSAGE,ec:GetControler(),DM_HINTMSG_NOSTRIGGER) end
		--register broken shield for Card.IsBrokenShield
		ec:RegisterFlagEffect(DM_EFFECT_BROKEN_SHIELD,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,DM_DESC_BROKEN)
		--register broken shield for Card.GetShieldBreakCount
		rc:RegisterFlagEffect(DM_EFFECT_BREAK_SHIELD,RESET_PHASE+PHASE_END,0,1)
		--register broken shield for Duel.GetShieldBreakCount
		Duel.RegisterFlagEffect(rc:GetControler(),DM_EFFECT_BREAK_SHIELD,RESET_PHASE+PHASE_END,0,1)
	end
end
--win game
function scard.wincon(e)
	return Duel.GetFieldGroupCount(0,LOCATION_DECK,0)==0 or Duel.GetFieldGroupCount(1,LOCATION_DECK,0)==0
end
function scard.winop(e,tp,eg,ep,ev,re,r,rp)
	local win={}
	win[0]=Duel.GetFieldGroupCount(0,LOCATION_DECK,0)==0
	win[1]=Duel.GetFieldGroupCount(1,LOCATION_DECK,0)==0
	if win[0] and win[1] then
		Duel.Win(PLAYER_NONE,DM_WIN_REASON_DECKOUT)
	elseif win[0] then
		Duel.Win(1,DM_WIN_REASON_DECKOUT)
	elseif win[1] then
		Duel.Win(0,DM_WIN_REASON_DECKOUT)
	end
end
--destroy equal & lower def
function scard.desop2(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a or not a:IsOnField() or not d or not d:IsOnField() or not d:IsDefensePos() then return end
	local ab1=a:IsHasEffect(EFFECT_INDESTRUCTIBLE) and a:IsHasEffect(EFFECT_INDESTRUCTIBLE_BATTLE)
	local ab2=d:IsHasEffect(EFFECT_INDESTRUCTIBLE) and d:IsHasEffect(EFFECT_INDESTRUCTIBLE_BATTLE)
	local g=Group.CreateGroup()
	if a:GetAttack()<d:GetDefense() then
		if not ab1 and a:IsRelateToBattle() then g:AddCard(a) end
	elseif a:GetAttack()==d:GetDefense() then
		if not ab1 and a:IsRelateToBattle() then g:AddCard(a) end
		if not ab2 and d:IsRelateToBattle() then g:AddCard(d) end
	end
	Duel.Destroy(g,REASON_RULE--[[+REASON_BATTLE]])
end
--to grave redirect
function scard.tgtg(e,c)
	return (c:IsReason(REASON_DESTROY) or c:IsReason(REASON_BATTLE)) and not c:IsHasEffect(DM_EFFECT_TO_GRAVE_REDIRECT)
end
function scard.cfilter3(c)
	return c:GetStackCount()>0
end
function scard.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(scard.cfilter3,1,nil)
end
function scard.tgop2(e,tp,eg,ep,ev,re,r,rp)
	for ec in aux.Next(eg) do
		local g=ec:GetStackGroup()
		g=g:Filter(Card.DMIsAbleToGrave,nil)
		for c in aux.Next(g) do
			Duel.DMSendtoGrave(c,REASON_RULE)
		end
	end
end
