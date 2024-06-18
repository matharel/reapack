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

-- TODO: Si la même piste est sélectionnée deux fois de suite:
--			ne pas la mettre dans l'undo stack

local console = false

-- Display a message in the console for debugging
function Msg(value)
	if console then
		reaper.ShowConsoleMsg(tostring(value) .. "\n")
	end
end

function popUndoStack(undoStack)
	return newUndoStack
end

function resetRedoStack()
	reaper.DeleteExtState(0, 'redo_track_stack', false)
end

function storeUndo(currentTrackNb)
	local undoStack = reaper.GetExtState(0, 'undo_track_stack')
	local newUndoStack = tostring(currentTrackNb) .. ',' .. undoStack

	if string.len(newUndoStack) > 192 then
		local pattern = "[^,]*,$" 
		newUndoStack = string.gsub(newUndoStack, pattern, '')
	end

	Msg('newUndoStack:'..newUndoStack)
	reaper.SetExtState(0, "undo_track_stack", newUndoStack, false)
end

function main()
	-- script à déclencher à chaque fois APRÈS qu'une piste soit sélectionnée
	-- AVANT plutôt, non?
	-- si besoin de resetter l'undo stack:
	-- reaper.SetExtState(0, "undo_track_stack", '', false)

	resetRedoStack()

	local currentTrack = reaper.GetSelectedTrack(0, 0)
	-- IP_TRACKNUMBER is 1 based, but track manipulations are 0
	local currentTrackNb = reaper.GetMediaTrackInfo_Value(currentTrack, 'IP_TRACKNUMBER') - 1

	-- store track number
	storeUndo(currentTrackNb)
	
end

-- INIT --------------------------------------------

reaper.PreventUIRefresh(1)
reaper.Undo_BeginBlock() -- Begining of the undo block. Leave it at the top of your main function.
main()
reaper.Undo_EndBlock("My action", -1) -- End of the undo block. Leave it at the bottom of your main function.
reaper.UpdateArrange()
reaper.PreventUIRefresh(-1)
