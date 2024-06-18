-- @description utils
-- @author matharel
-- @version 1.1
-- @about

function selectedTrack()

    -- Récupérer la piste sélectionnée
    local selectedTrack = reaper.GetSelectedTrack(0, 0) -- 0 pour la première piste sélectionnée

    -- Vérifier si une piste a été sélectionnée
    if selectedTrack then
        -- Récupérer la position verticale de la piste sélectionnée
        local trackY = reaper.GetMediaTrackInfo_Value(selectedTrack, "I_TCPY")
        local trackNumber = reaper.GetMediaTrackInfo_Value(selectedTrack, "IP_TRACKNUMBER")

        -- Afficher la position verticale dans la console de Reaper
        reaper.ShowConsoleMsg("Position verticale de la piste " .. trackNumber .. " : " .. trackY .. "\n")
    else
        -- Si aucune piste n'a été sélectionnée, afficher un message dans la console
        reaper.ShowConsoleMsg("Aucune piste sélectionnée.\n")
    end
end

