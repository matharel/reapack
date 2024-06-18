
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

console = true

function Msg(value)
  if console then
    reaper.ShowConsoleMsg(tostring(value) .. "\n")
  end
end

function main()
end

-- INIT --
reaper.PreventUIRefresh(1)
reaper.Undo_BeginBlock()
main()
reaper.Undo_EndBlock("My action", -1)
reaper.UpdateArrange()
reaper.PreventUIRefresh(-1)
