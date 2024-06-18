-- toggle folder

function Msg(msg)
    reaper.ShowConsoleMsg(msg)
    reaper.ShowConsoleMsg("\n")
end

function CollapseFolder(selectedTrack)
    local isCollapsed = reaper.GetMediaTrackInfo_Value(selectedTrack, "I_FOLDERCOMPACT")

    if isCollapsed <= 0 then
        -- collapse the folder
        local id = reaper.NamedCommandLookup("_SWS_COLLAPSE")
        reaper.Main_OnCommandEx(id, 0, 0)
    else
        -- uncollapse the folder
        local id = reaper.NamedCommandLookup("_SWS_UNCOLLAPSE")
        reaper.Main_OnCommandEx(id, 0, 0)
    end
end

function Main()
    reaper.Undo_BeginBlock()

    local selectedTrack = reaper.GetSelectedTrack(0, 0)

    -- si un folder retourne 1.0, sinon retourne 0.0
    local isFolder = reaper.GetMediaTrackInfo_Value(selectedTrack, "I_FOLDERDEPTH") > 0
    local hasParent = reaper.GetParentTrack(selectedTrack)

    -- si c'est un folder
    if isFolder then
        CollapseFolder(selectedTrack)

    -- si ça a un parent
    elseif hasParent ~= nil then
        -- on remonte pour sélectionner le parent (qui est forcément un folder)
        local id = reaper.NamedCommandLookup("_SWS_SELPARENTS")
        reaper.Main_OnCommandEx(id, 0, 0)
        -- on remet à jour la variable de la piste sélectionnée
        local selectedFolder = reaper.GetSelectedTrack(0, 0)

        CollapseFolder(selectedFolder)
    else
        -- do nothing !
    end

    reaper.Undo_EndBlock("Toggle Collapse Folder", -1)

    -- Restaurer la piste sélectionnée
    if selectedTrack then
        reaper.SetOnlyTrackSelected(selectedTrack) -- Sélectionner uniquement la piste mémorisée
    else
        reaper.SelectAllTracks(false) -- Désélectionner toutes les pistes si aucune piste mémorisée n'est trouvée
    end
end

reaper.PreventUIRefresh(1)
reaper.Undo_BeginBlock() -- Begining of the undo block. Leave it at the top of your main function.
Main()
reaper.Undo_EndBlock("Toggle Folder", -1) -- End of the undo block. Leave it at the bottom of your main function.
reaper.UpdateArrange()
reaper.PreventUIRefresh(-1)
