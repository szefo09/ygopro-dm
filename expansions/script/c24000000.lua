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
	e1:SetRange(LOCATION_ALL)
	e1:SetCountLimit(1)
	e1:SetOperation(scard.operation)
	c:RegisterEffect(e1)
end
scard.duel_masters_card=true
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
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_ALL,nil,sid)
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
	local b1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<40
	local b2=Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)<40
	--check for non-duel masters cards
	local f=function(c)
		return not c.duel_masters_card
	end
	local b3=Duel.GetMatchingGroupCount(f,tp,LOCATION_ALL,0,nil)>0
	local b4=Duel.GetMatchingGroupCount(f,1-tp,LOCATION_ALL,0,nil)>0
	-- if b1 then Duel.Hint(HINT_MESSAGE,tp,DM_DECKERROR_DECKCOUNT) end
	-- if b2 then Duel.Hint(HINT_MESSAGE,1-tp,DM_DECKERROR_DECKCOUNT) end
	if b3 then Duel.Hint(HINT_MESSAGE,tp,DM_DECKERROR_NONDM) end
	if b4 then Duel.Hint(HINT_MESSAGE,1-tp,DM_DECKERROR_NONDM) end
	if (b3 and b4) then
		Duel.Win(PLAYER_NONE,DM_WIN_REASON_INVALID)
		return
	elseif b3 then
		Duel.Win(1-tp,DM_WIN_REASON_INVALID)
		return
	elseif b4 then
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
	local e1b=e1:Clone()
	e1b:SetCode(EVENT_ADJUST)
	e1b:SetCondition(scard.poscon)
	e1b:SetOperation(scard.posop2)
	Duel.RegisterEffect(e1b,tp)
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
	--attack cost workaround
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_DAMAGE_STEP_END)
	e4:SetOperation(scard.posop3)
	Duel.RegisterEffect(e4,tp)
	--attack player
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DIRECT_ATTACK)
	e5:SetTargetRange(DM_LOCATION_BATTLE,DM_LOCATION_BATTLE)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsCanAttackPlayer))
	Duel.RegisterEffect(e5,tp)
	--destroy 0 power
	local e6=Effect.CreateEffect(c)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_ADJUST)
	e6:SetCondition(scard.descon)
	e6:SetOperation(scard.desop1)
	Duel.RegisterEffect(e6,tp)
	--discard spell
	local e7=Effect.CreateEffect(c)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_CHAINING)
	e7:SetOperation(aux.chainreg)
	Duel.RegisterEffect(e7,tp)
	local e8=e7:Clone()
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_DELAY)
	e8:SetCode(EVENT_CHAIN_SOLVED)
	e8:SetOperation(scard.tgop1)
	Duel.RegisterEffect(e8,tp)
	--register broken shield
	local e9=Effect.CreateEffect(c)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_DELAY)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_TO_HAND)
	e9:SetCondition(scard.regcon2)
	e9:SetOperation(scard.regop2)
	Duel.RegisterEffect(e9,tp)
	--win game
	local e10=Effect.CreateEffect(c)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_ADJUST)
	e10:SetCondition(scard.wincon)
	e10:SetOperation(scard.winop)
	Duel.RegisterEffect(e10,tp)
	--ignore yugioh rules
	--attack first turn
	if EFFECT_BP_FIRST_TURN then
		local ye1=Effect.CreateEffect(c)
		ye1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_PLAYER_TARGET)
		ye1:SetType(EFFECT_TYPE_FIELD)
		ye1:SetCode(EFFECT_BP_FIRST_TURN)
		ye1:SetTargetRange(1,1)
		Duel.RegisterEffect(ye1,tp)
	end
	--skip main phase 2
	local ye2=Effect.CreateEffect(c)
	ye2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_PLAYER_TARGET)
	ye2:SetType(EFFECT_TYPE_FIELD)
	ye2:SetCode(EFFECT_SKIP_M2)
	ye2:SetTargetRange(1,1)
	Duel.RegisterEffect(ye2,tp)
	--infinite hand
	local ye3=Effect.CreateEffect(c)
	ye3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_PLAYER_TARGET)
	ye3:SetType(EFFECT_TYPE_FIELD)
	ye3:SetCode(EFFECT_HAND_LIMIT)
	ye3:SetTargetRange(1,1)
	ye3:SetValue(MAX_NUMBER)
	Duel.RegisterEffect(ye3,tp)
	--infinite attacks
	local ye4=Effect.CreateEffect(c)
	ye4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	ye4:SetType(EFFECT_TYPE_FIELD)
	ye4:SetCode(EFFECT_EXTRA_ATTACK)
	ye4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	ye4:SetValue(MAX_NUMBER)
	Duel.RegisterEffect(ye4,tp)
	--cannot change position
	local ye5=Effect.CreateEffect(c)
	ye5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	ye5:SetType(EFFECT_TYPE_FIELD)
	ye5:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	ye5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	Duel.RegisterEffect(ye5,tp)
	--no battle damage
	local ye6=Effect.CreateEffect(c)
	ye6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	ye6:SetType(EFFECT_TYPE_FIELD)
	ye6:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	ye6:SetTargetRange(DM_LOCATION_BATTLE,DM_LOCATION_BATTLE)
	ye6:SetValue(1)
	Duel.RegisterEffect(ye6,tp)
	--no effect damage
	local ye7=Effect.CreateEffect(c)
	ye7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_PLAYER_TARGET)
	ye7:SetType(EFFECT_TYPE_FIELD)
	ye7:SetCode(EFFECT_CHANGE_DAMAGE)
	ye7:SetTargetRange(1,1)
	ye7:SetValue(function(e,re,val,r,rp,rc)
		if bit.band(r,REASON_EFFECT)~=0 then return 0
		else return val end
	end)
	Duel.RegisterEffect(ye7,tp)
	local ye8=Effect.CreateEffect(c)
	ye8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_PLAYER_TARGET)
	ye8:SetType(EFFECT_TYPE_FIELD)
	ye8:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	ye8:SetTargetRange(1,1)
	Duel.RegisterEffect(ye8,tp)
	--set def equal to atk
	local ye9=Effect.CreateEffect(c)
	ye9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_DELAY)
	ye9:SetType(EFFECT_TYPE_FIELD)
	ye9:SetCode(EFFECT_SET_DEFENSE_FINAL)
	ye9:SetTargetRange(DM_LOCATION_BATTLE,DM_LOCATION_BATTLE)
	ye9:SetValue(function(e,c)
		return c:GetPower()
	end)
	Duel.RegisterEffect(ye9,tp)
	--destroy equal & lower def
	local ye10=Effect.CreateEffect(c)
	ye10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	ye10:SetDescription(aux.Stringid(sid,2))
	ye10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ye10:SetCode(EVENT_DAMAGE_STEP_END)
	ye10:SetOperation(scard.desop2)
	Duel.RegisterEffect(ye10,tp)
	--cannot summon/mset
	local ye11=Effect.CreateEffect(c)
	ye11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_PLAYER_TARGET)
	ye11:SetType(EFFECT_TYPE_FIELD)
	ye11:SetCode(EFFECT_CANNOT_SUMMON)
	ye11:SetTargetRange(1,1)
	Duel.RegisterEffect(ye11,tp)
	local ye12=ye11:Clone()
	ye12:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(ye12,tp)
	--can set in szone
	local ye13=Effect.CreateEffect(c)
	ye13:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_IGNORE_RANGE)
	ye13:SetType(EFFECT_TYPE_FIELD)
	ye13:SetCode(EFFECT_MONSTER_SSET)
	ye13:SetTargetRange(LOCATION_ALL,LOCATION_ALL)
	ye13:SetTarget(aux.TargetBoolFunction(Card.IsCreature))
	ye13:SetValue(TYPE_SPELL)
	Duel.RegisterEffect(ye13,tp)
	local ye14=Effect.CreateEffect(c)
	ye14:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_PLAYER_TARGET)
	ye14:SetType(EFFECT_TYPE_FIELD)
	ye14:SetCode(EFFECT_CANNOT_SSET)
	ye14:SetTargetRange(1,1)
	ye14:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_HAND))
	Duel.RegisterEffect(ye14,tp)
	--cannot trigger
	local ye15=Effect.CreateEffect(c)
	ye15:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	ye15:SetType(EFFECT_TYPE_FIELD)
	ye15:SetCode(EFFECT_CANNOT_TRIGGER)
	ye15:SetTargetRange(DM_LOCATION_SHIELD,DM_LOCATION_SHIELD)
	ye15:SetTarget(aux.TargetBoolFunction(Card.IsFacedown))
	Duel.RegisterEffect(ye15,tp)
	--to grave redirect
	local ye16=Effect.CreateEffect(c)
	ye16:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	ye16:SetType(EFFECT_TYPE_FIELD)
	ye16:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	ye16:SetTargetRange(LOCATION_ALL,LOCATION_ALL)
	ye16:SetTarget(scard.tgtg)
	ye16:SetValue(DM_LOCATION_GRAVE)
	Duel.RegisterEffect(ye16,tp)
	local ye17=Effect.CreateEffect(c)
	ye17:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	ye17:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ye17:SetCode(EVENT_LEAVE_FIELD)
	ye17:SetCondition(scard.tgcon)
	ye17:SetOperation(scard.tgop2)
	Duel.RegisterEffect(ye17,tp)
	--chain limit
	local ye18=Effect.CreateEffect(c)
	ye18:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	ye18:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ye18:SetCode(EVENT_CHAINING)
	ye18:SetOperation(scard.chop)
	Duel.RegisterEffect(ye18,tp)
	--no replay
	local ye19=Effect.CreateEffect(c)
	ye19:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	ye19:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ye19:SetCode(EVENT_LEAVE_FIELD)
	ye19:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_ONFIELD) and Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE)
	end)
	ye19:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local a=Duel.GetAttacker()
		local d=Duel.GetAttackTarget()
		--[[if not d or not d:IsOnField() then
			Duel.ChangePosition(a,POS_FACEUP_TAPPED)
			return
		end]]
		Duel.ChangeAttackTarget(d)
	end)
	Duel.RegisterEffect(ye19,tp)
end
--untap
function scard.posfilter1(c)
	return c:IsFaceup() and c:IsAbleToUntap()
end
function scard.ssfilter(c)
	return c:IsFaceup() and c:IsTapped() and c:IsHasEffect(DM_EFFECT_SILENT_SKILL)
end
function scard.posop1(e,tp,eg,ep,ev,re,r,rp)
	local turnp=Duel.GetTurnPlayer()
	local g1=Duel.GetMatchingGroup(scard.posfilter1,turnp,DM_LOCATION_BATTLE,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToUntap,turnp,DM_LOCATION_MANA,0,nil)
	g1:Merge(g2)
	local g3=Duel.GetMatchingGroup(scard.ssfilter,turnp,DM_LOCATION_BATTLE,0,nil)
	g1:Sub(g3)
	Duel.ChangePosition(g1,POS_FACEUP_UNTAPPED)
end
function scard.poscon(e)
	return Duel.GetCurrentPhase()==PHASE_DRAW
end
function scard.posfilter2(c)
	return scard.posfilter1(c) and c:GetFlagEffect(DM_EFFECT_SILENT_SKILL)==0
end
function scard.posop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(scard.posfilter2,Duel.GetTurnPlayer(),DM_LOCATION_BATTLE,0,nil)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEUP_UNTAPPED)
	end
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
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetLabelObject(e1)
		e2:SetCondition(scard.rscon)
		e2:SetOperation(scard.rsop)
		e2:SetReset(RESET_PHASE+PHASE_END)
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
function scard.posop3(e,tp,eg,ep,ev,re,r,rp)
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
	if Duel.IsPlayerAffectedByEffect(rp,DM_EFFECT_DONOT_DISCARD_SHIELD_TRIGGER) then return end
	if (re:IsHasProperty(DM_EFFECT_FLAG_CHARGE) or rc:IsHasEffect(DM_EFFECT_CHARGER)) and rc:IsAbleToMana() then
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
	Duel.Destroy(g,REASON_RULE)
	--raise event for "When this creature wins a battle"
	Duel.RaiseSingleEvent(d,EVENT_CUSTOM+DM_EVENT_WIN_BATTLE,e,0,0,0,0)
	--raise event for "Whenever one of your creatures wins a battle"
	Duel.RaiseEvent(d,EVENT_CUSTOM+DM_EVENT_WIN_BATTLE,e,0,0,0,0)
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
