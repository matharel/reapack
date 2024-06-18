
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
