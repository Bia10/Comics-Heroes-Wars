slaanesh_lust = class ( {})

LinkLuaModifier ("modifier_slaanesh_lust", "abilities/slaanesh_lust.lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

function slaanesh_lust:CastFilterResultTarget (hTarget)
    if IsServer () then

        if hTarget ~= nil and hTarget:IsMagicImmune() then
            return UF_FAIL_MAGIC_IMMUNE_ENEMY
        end

        local nResult = UnitFilter (hTarget, self:GetAbilityTargetTeam (), self:GetAbilityTargetType (), self:GetAbilityTargetFlags (), self:GetCaster ():GetTeamNumber () )
        return nResult
    end

    return UF_SUCCESS
end


--function scarlet_witch_scarlet_magic:GetCooldown (nLevel)
    --if self:GetCaster ():HasScepter () then
        --return 40
    --end

    --return self.BaseClass.GetCooldown (self, nLevel)
--end
--------------------------------------------------------------------------------

--function scarlet_witch_scarlet_magic:GetCastRange (vLocation, hTarget)
    --if self:GetCaster ():HasScepter () then
        --return self:GetSpecialValueFor ("cast_range_scepter")
    --end

    --return self.BaseClass.GetCastRange (self, vLocation, hTarget)
--end

--------------------------------------------------------------------------------

function slaanesh_lust:OnSpellStart ()
    local hTarget = self:GetCursorTarget ()
    if hTarget ~= nil then
        if ( not hTarget:TriggerSpellAbsorb (self) ) then
            local info = {
                EffectName = "particles/units/heroes/hero_dark_willow/dark_willow_shadow_attack.vpcf",
                Ability = self,
                iMoveSpeed = 3700,
                Source = self:GetCaster (),
                Target = self:GetCursorTarget (),
                iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
            }

            ProjectileManager:CreateTrackingProjectile (info)
            --EmitSoundOn ("Hero_ArcWarden.Flux.Cast", self:GetCaster () )
        end
        EmitSoundOn ("Hero_VengefulSpirit.MagicMissile", self:GetCaster () )
    end
end
--particles/scarlet_witch_flux.vpcf
function slaanesh_lust:OnProjectileHit (hTarget, vLocation)
    if IsServer() then 
        EmitSoundOn ("Hero_Oracle.FortunesEnd.Target", hTarget)
        EmitSoundOn ("Hero_Necrolyte.SpiritForm.Cast", hTarget)
        
        local duration = self:GetSpecialValueFor ("duration")

        hTarget:AddNewModifier (self:GetCaster (), self, "modifier_slaanesh_lust", { duration = duration } )
    end 
end

modifier_slaanesh_lust = class ( {})

function modifier_slaanesh_lust:IsHidden()
    return false
end

function modifier_slaanesh_lust:IsBuff()
    return false
end

function modifier_slaanesh_lust:IsPurgable()
    return false
end

function modifier_slaanesh_lust:GetEffectName()
    return "particles/units/heroes/hero_dark_willow/dark_willow_bramble.vpcf"
end

function modifier_slaanesh_lust:StatusEffectPriority()
    return 1000
end

function modifier_slaanesh_lust:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_slaanesh_lust:OnCreated()
    if IsServer() then
        self:StartIntervalThink(0.5)
    end
end

function modifier_slaanesh_lust:OnIntervalThink()
    if IsServer() then
        local thinker = self:GetParent ()
        local hAbility = self:GetAbility ()

        local thinker_pos = thinker:GetAbsOrigin ()
        
        damage_pers = hAbility:GetSpecialValueFor ("damage")/100
        damage_base = hAbility:GetSpecialValueFor ("base_damage")
        
        local damage = (thinker:GetMaxHealth () * damage_pers) + damage_base

        ApplyDamage ( { attacker = self:GetCaster (), victim = thinker, ability = hAbility, damage = damage, damage_type = hAbility:GetAbilityDamageType()}) 
    end
end

function modifier_slaanesh_lust:CheckState()
	local state = {
        [MODIFIER_STATE_ROOTED] = true
	}

	return state
end

function slaanesh_lust:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end