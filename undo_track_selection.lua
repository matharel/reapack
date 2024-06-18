-- @description undo track selection
-- @author matharel
-- @version 1.1
-- @about

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

console = true

-- Display a message in the console for debugging
function Msg(value)
  if console then
    reaper.ShowConsoleMsg(tostring(value) .. "\n")
  end
end

function storeRedo(currentTrackNb)
  local lastRedo = reaper.GetExtState(0, 'redo_track_stack')
   local newRedo = tostring(currentTrackNb) .. ',' .. lastRedo
   reaper.SetExtState(0, "redo_track_stack", newRedo, false)
end

-- return a media track
function getpreviousTrack(undoStack)
  local previousTrackNb = string.match(undoStack, "([^,]+)")
  local previousTrack = reaper.GetTrack(0, previousTrackNb)
  reaper.SetOnlyTrackSelected(previousTrack)
end

function updateUndoStack(undoStack)
  -- je remplace tout ce qui se situe jusqu'à la première virgule incluse par une chaine vide
  local newUndoStack = string.gsub(undoStack, "^[^,]+,", "")
  reaper.SetExtState(0, "undo_track_stack", newUndoStack, false)
end

-- NOTE: Sélectionne la track précédente si existante
-- Met à jour les stacks undo et redo
function main()
  local undoStack = reaper.GetExtState(0, 'undo_track_stack')
  local currentTrack = reaper.GetSelectedTrack(0, 0)
  local currentTrackNb = reaper.GetMediaTrackInfo_Value(currentTrack, 'IP_TRACKNUMBER') - 1

  if string.len(undoStack) > 0 then

    -- store current track in redostack
    storeRedo(currentTrackNb)

    -- get previous track
    getpreviousTrack(undoStack)

    -- on met à jour l'undo_stack
    updateUndoStack(undoStack)

  else
    Msg('Le undoStack est vide!')
  end
end

-- INIT --
reaper.PreventUIRefresh(1)
reaper.Undo_BeginBlock()
main()
reaper.Undo_EndBlock("My action", -1)
reaper.UpdateArrange()
reaper.PreventUIRefresh(-1)
