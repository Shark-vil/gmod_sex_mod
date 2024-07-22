local _sound_track_path = 'sex_music_joke.wav'
local _textures_folder = 'sex_mod_frames'
local _animation_materials_list = {}
local _start_frame = 0
local _end_frame = 835
local _sound_track = Sound(_sound_track_path)
local _fps = 30
local _current_frame_index = 0
local _next_frame_time = nil
local _RealTime = RealTime

sound.Add({
	name = 'sex_music_joke',
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 140,
	pitch = 100,
	sound = _sound_track
})

for i = _start_frame, _end_frame do
	_animation_materials_list[i] = Material(string.format('%s/%s', _textures_folder, i))
end

local function update_frame()
	_current_frame_index = _current_frame_index + 1
	if _current_frame_index > _end_frame then _current_frame_index = _end_frame end
end

local function get_renderer_material()
	return _animation_materials_list[_current_frame_index]
end

local function destroy_renderer()
	hook.Remove('HUDPaint', 'SexModJoke.Renderer')
	timer.Remove('SexModJoke.Renderer.Update')
	timer.Remove('SexModJoke.Kill')
end

local function reset_audio()
	local ply = LocalPlayer()
	ply:StopSound('sex_music_joke')
	ply:EmitSound('sex_music_joke')
end

local function reset_variables()
	_current_frame_index = 0
	_next_frame_time = nil
end

net.Receive('start_sex_frames_client', function()
	destroy_renderer()
	reset_variables()
	reset_audio()

	render.UpdateScreenEffectTexture()

	hook.Add('HUDPaint', 'SexModJoke.Renderer', function()
		local material = get_renderer_material()
		if not material then return end
		render.SetMaterial(material)
		render.DrawScreenQuad()
	end)

	timer.Create('SexModJoke.Renderer.Update', 1 / _fps, _end_frame, update_frame)

	timer.Create('SexModJoke.Renderer.Remover', _end_frame / _fps, 1, destroy_renderer)

	timer.Create('SexModJoke.Kill', (_end_frame / _fps) - .5, 1, function()
		net.Start('sex_mod_joke_explosion')
		net.SendToServer()
	end)
end)