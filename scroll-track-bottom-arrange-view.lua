-- @description scroll track bottom of arrangement
-- @author matharel
-- @version 1.1
-- @about

-- https://forum.cockos.com/showpost.php?p=2330342&postcount=5
-- clear console
reaper.ShowConsoleMsg("")

-- create simpler console messager
function Msg(param)
	reaper.ShowConsoleMsg(param .. "\n")
end

function bool2string(b)
	return b and "true" or "false"
end

--debug  = true  -- disable main messages
--debug  = false  -- disable main messages

local floor = math.floor

function scroll_to_track(track_id, relative_y_pos, include_envelopes)
	relative_y_pos = relative_y_pos or 0 -- default position is "top"
	local p = "I_WNDH" -- Exclude envelope lane heights
	if not include_envelopes then -- Include envelope lane heights
		p = "I_TCPH"
	end
	-- Ignore hidden tracks
	if not reaper.IsTrackVisible(track_id, true) then
		return false
	end
	local tcp_y = reaper.GetMediaTrackInfo_Value(track_id, "I_TCPY")
	local tcp_h = reaper.GetMediaTrackInfo_Value(track_id, p)
	local arrange_id = reaper.JS_Window_FindChildByID(reaper.GetMainHwnd(), 0x3E8)
	local ok, ar_vsb_position, ar_vsb_page, ar_vsb_min, ar_vsb_max, ar_vsb_trackPos =
		reaper.JS_Window_GetScrollInfo(arrange_id, "v")
	if ok then
		ok = reaper.JS_Window_SetScrollPos(
			arrange_id,
			"v",
			tcp_y + ar_vsb_position - floor(relative_y_pos * (ar_vsb_page - tcp_h))
		)
	end
	return ok
end

selected_trk = reaper.GetSelectedTrack(0, 0)
tracknumber = reaper.GetMediaTrackInfo_Value(selected_trk, "IP_TRACKNUMBER")

-- Example: scroll to selected track
local tr = reaper.GetTrack(0, tracknumber - 1) -- Get track
if tr then
	-- Desc: scroll_to_track(track_id, relative_y_pos, include_envelopes)
	scroll_to_track(tr, 1)
	--scroll_to_track(tr, 0.5, false)
	--scroll_to_track(tr, 1, false)
	--scroll_to_track(tr, 1, true)
end
