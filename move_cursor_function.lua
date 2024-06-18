-- Fonction principale pour déplacer le curseur d'édition à un pourcentage spécifié de la vue d'arrangement
function moveCursorToPercentageOfArrangeView(percentage)
    local arrangeStart, arrangeEnd = reaper.GetSet_ArrangeView2(0, false, 0, 0)
    local arrangeLength = arrangeEnd - arrangeStart
    local targetPosition = arrangeStart + (arrangeLength * percentage / 100)
    local cursorPosition = reaper.GetCursorPosition()
    local cursorOffset = targetPosition - cursorPosition
    reaper.MoveEditCursor(cursorOffset, false)
end
