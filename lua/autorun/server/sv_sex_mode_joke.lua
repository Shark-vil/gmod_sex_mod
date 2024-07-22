util.AddNetworkString('start_sex_frames_client')
util.AddNetworkString('sex_mod_joke_explosion')

hook.Add('PlayerSay', 'StartSexMod', function(ply, text)
	if string.StartsWith(text, '/sex') then
		net.Start('start_sex_frames_client')
		net.Send(ply)
		return ''
	end
end)

net.Receive('sex_mod_joke_explosion', function(_, ply)
	local explode = ents.Create('env_explosion')
	explode:SetPos(ply:GetPos())
	explode:Spawn()
	explode:Fire('Explode', 0, 0)

	local shake = ents.Create('env_shake')
	shake:SetPos(ply:GetPos())
	shake:SetKeyValue('amplitude', '2000')
	shake:SetKeyValue('radius', '400')
	shake:SetKeyValue('duration', '2.5')
	shake:SetKeyValue('frequency', '255')
	shake:SetKeyValue('spawnflags', '4')
	shake:Spawn()
	shake:Activate()
	shake:Fire('StartShake', '', 0)

	local damage_info = DamageInfo()
	damage_info:SetDamage(100000)
	damage_info:SetAttacker(Entity(1))
	damage_info:SetDamageType(DMG_BLAST)

	ply:TakeDamageInfo(damage_info)
end)