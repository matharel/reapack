--[[
 * ReaScript Name: Toggle action list
 * Description: 
 * Instructions: Run
 * Screenshot:
 * Author: unknown
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


-- je ne me rappelle plus où j'ai trouvé ce script
-- probablement sur le forum.
-- en tout cas, il fonctionne très bien
function Main()
  local found = false
  local arr = reaper.new_array({}, 100)
  local title = reaper.JS_Localize("Actions", "common")
  reaper.JS_Window_ArrayFind(title, true, arr)
  local adr = arr.table() 
  for j = 1, #adr do
    local hwnd = reaper.JS_Window_HandleFromAddress(adr[j])
    if reaper.JS_Window_FindChildByID(hwnd, 1323) then -- verify window, must also have control ID#.
      reaper.JS_Window_Destroy(hwnd) -- close action list
      found = true
      break
    end 
  end 
  if not found then reaper.ShowActionList() end -- show action list
end

if not reaper.APIExists('JS_Localize') then
  reaper.MB("js_ReaScriptAPI extension is required for this script.", "Missing API", 0)
else
  Main()
end
reaper.defer(function () end)
