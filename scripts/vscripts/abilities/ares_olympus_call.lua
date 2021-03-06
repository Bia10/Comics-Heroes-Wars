if not ares_olympus_call then ares_olympus_call = class({}) end
LinkLuaModifier( "modifier_ares_olympus_call", "abilities/ares_olympus_call.lua", LUA_MODIFIER_MOTION_NONE )

function ares_olympus_call:OnSpellStart()
	local radius = self:GetSpecialValueFor( "radius" )
	local duration = self:GetSpecialValueFor(  "duration" )

	local allies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	if #allies > 0 then
		for _,ally in pairs(allies) do
			ally:AddNewModifier( self:GetCaster(), self, "modifier_ares_olympus_call", { duration = duration } )
      local nFXIndex = ParticleManager:CreateParticle( "particles/hero_ares/ares_olympus_call.vpcf", PATTACH_ABSORIGIN_FOLLOW, ally )
      ParticleManager:SetParticleControlEnt( nFXIndex, 0, ally, PATTACH_POINT_FOLLOW, "attach_hitloc", ally:GetOrigin(), true )
      ParticleManager:SetParticleControlEnt( nFXIndex, 9, ally, PATTACH_POINT_FOLLOW, "attach_hitloc", ally:GetOrigin(), true )
    	ParticleManager:ReleaseParticleIndex( nFXIndex )

      EmitSoundOn( "Hero_ObsidianDestroyer.EssenceAura", ally )
		end
	end

  EmitSoundOn( "Hero_Sven.Layer.GodsStrength", self:GetCaster() )
  EmitSoundOn( "Hero_Sven.WarCry", self:GetCaster() )
  EmitSoundOn( "Hero_Sven.GodsStrength", self:GetCaster() )
	self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
end

if not modifier_ares_olympus_call then modifier_ares_olympus_call = class({}) end

function modifier_ares_olympus_call:IsPurgable()
	return false
end

function modifier_ares_olympus_call:GetStatusEffectName()
	return "particles/status_fx/status_effect_monkey_king_fur_army.vpcf"
end

function modifier_ares_olympus_call:StatusEffectPriority()
	return 1000
end

function modifier_ares_olympus_call:GetEffectName()
	return "particles/units/heroes/hero_arc_warden/arc_warden_tempest_buff.vpcf"
end

function modifier_ares_olympus_call:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_ares_olympus_call:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}

	return funcs
end

function modifier_ares_olympus_call:GetModifierBaseDamageOutgoing_Percentage()
	return self:GetAbility():GetSpecialValueFor("gods_strength_damage")
end
