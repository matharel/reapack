-- @description redo track selection
-- @author matharel
-- @version 1.1
-- @about
--

--[[
* ReaScript Name: 
* Description: 
* Instructions: Run
* Screenshot: 
* Author: 
* Author URI: 
* Repository: 
* Repository URI: 
* File URI: 
* Licence: GPL v3
* Forum Thread: 
* Forum Thread URI: 
* REAPER: 5.0
* Extensions: None
* Version: 1.0
--]]

--[[
* Changelog:
* v1.0 (2016-01-29)
+ Initial Release
--]]

-- TODO: Il faut scroller d'une manière ou d'une autre
--			pour que les tracks restent dans la vue
--
--			je me demande si il ne faudrait pas popper aussi
--			le undostack ici

console = false

function Msg(value)
	if console then
		reaper.ShowConsoleMsg(tostring(value) .. "\n")
	end
end

function getPreviousTrack(redoStack, previousTrackId)

	if redoStack == '' then
		Msg("Il n'y a plus de redostack")
	else

		reaper.SetOnlyTrackSelected(reaper.GetTrack(0, previousTrackId))
	end
end

function updateRedoStack(redoStack, previousTrackId)
	-- 2. pop previous track from the redo stack
	local newRedoStack = string.gsub(redoStack, previousTrackId .. ",", "", 1)
	reaper.SetExtState(0, "redo_track_stack", newRedoStack, false)
end

function updateUndoStack(currentTrackId)
	local lastUndo = reaper.GetExtState(0, 'undo_track_stack')

	-- we put the current track into the undo stack
	local newUndo = tostring(currentTrackId) .. ',' .. lastUndo
	reaper.SetExtState(0, "undo_track_stack", newUndo, false)
end

-- NOTE: Sélectionne la prochaine piste du redo
-- met à jour le redo et undo stack
function main()
	local redoStack = reaper.GetExtState(0, 'redo_track_stack')

	if string.len(redoStack) > 0 then
		local previousTrackId = string.match(redoStack, "([^,]+)")
		local currentTrack = reaper.GetSelectedTrack(0, 0)
		local currentTrackId = reaper.GetMediaTrackInfo_Value(currentTrack, 'IP_TRACKNUMBER') - 1

		Msg('redoStack:'..redoStack)
		Msg('currentTrackId:'..currentTrackId)
		Msg('previousTrackId:'..previousTrackId)

		getPreviousTrack(redoStack, previousTrackId)

		updateRedoStack(redoStack, previousTrackId)

		updateUndoStack(currentTrackId)
	else
		Msg("Le redo stack est vide!")
	end
end

reaper.PreventUIRefresh(1)
reaper.Undo_BeginBlock() -- Begining of the undo block. Leave it at the top of your main function.
main()
reaper.Undo_EndBlock("My action", -1) -- End of the undo block. Leave it at the bottom of your main function.
reaper.UpdateArrange()
reaper.PreventUIRefresh(-1)
