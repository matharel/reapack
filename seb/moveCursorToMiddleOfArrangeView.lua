--[[
 * ReaScript Name: Move Cursor to Middle of Arrange View
 * Description: 
 * Instructions: Run
 * Screenshot:
 * Author: matharel
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



-- Fonction pour déplacer le curseur d'édition au milieu de la vue d'arrangement
function moveCursorToMiddleOfArrangeView()
    local arrangeStart, arrangeEnd = reaper.GetSet_ArrangeView2(0, false, 0, 0)
    local arrangeLength = arrangeEnd - arrangeStart
    local cursorPosition = reaper.GetCursorPosition()
    local cursorOffset = arrangeStart + (arrangeLength / 2) - cursorPosition
    reaper.MoveEditCursor(cursorOffset, false)
end

-- Appel de la fonction
moveCursorToMiddleOfArrangeView()
