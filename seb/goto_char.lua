--[[
 * ReaScript Name: Go to char
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

reaper.ShowConsoleMsg 'Hello , voyons voir, World!'
-- TODO:
-- quand on sélectionne une piste non visible, ça scroll, c'est bien
-- mais ça scroll aussi quand on sélectionne une piste visible
-- et c'est un peu déstabilisant (parce qu'on la regarde, on la vise, on ne s'attend pas
-- à ce que ça scrolle) -> à améliorer.



local console = false
local track_found = false

function Msg(value)
    if console then
        reaper.ShowConsoleMsg(tostring(value) .. "\n")
    end
end

function restoreSelectedTrack()
    -- Rétablit la sélection de la piste précédemment sélectionnée

    if selected_track then
        reaper.SetTrackSelected(selected_track, true)
    end
end

function findTrack(text)

    local count_tracks = reaper.CountTracks(0)
    for i = 0, count_tracks - 1 do
        local track = reaper.GetTrack( 0, i )
        if reaper.IsTrackVisible(track, 0) then
            Msg("visible")
            local r, track_name = reaper.GetTrackName( track )
            -- if track_name:lower() == str then
            if text ~="" and track_name:lower():match("^(" .. text .. ")") then
                Msg('Nom de la piste:' .. track_name)
                reaper.SetTrackSelected(track, true)
                -- c'est vraiment l'action suivante qui me permet de sélectionner complètement la piste dans le script
                reaper.Main_OnCommand(40914,0) -- Track: Set first selected track as last touched track
                reaper.Main_OnCommand(40913,0) -- Track: Vertical scroll selected tracks into view
                track_found = true
                break
            end
        end
    end
end


gfx.init("Ma fenêtre", 0, 0)

local text = "" -- Initialise le texte à vide
local startTime = reaper.time_precise() -- Initialise le temps de départ

function main()
    local currentTime = reaper.time_precise() -- Récupère le temps actuel
    char = gfx.getchar() -- Capture un caractère depuis le clavier

    if char ~= 0 then -- Vérifie si un caractère a été capturé
        -- Vérifie si le caractère capturé est une lettre
        if char >= 32 and char <= 126 then
            text = string.char(char) -- Ajoute la lettre au texte
            Msg("Lettre entrée : " .. text) -- Affiche la lettre dans la console
            -- return -- Sort de la fonction main une fois la lettre capturée
        end
    end

    findTrack(text)

    if track_found then
        Msg('piste trouvée, fin du script')
        return
    elseif currentTime - startTime > 1 then
        Msg("Aucune entrée détectée pendant 1 seconde. Fin du script.")
        restoreSelectedTrack()
        return -- Terminer le script
    end

    -- ok maintenant qu'on a la proof of concept,
    -- on passe au lourd !!
    -- NOTE: concernant `;` et `,` on fera ça dans un autre script
    -- dans celui-là, on se contentera de stocker la lettre recherchée
    -- dans une variable REAPER

    reaper.defer(main) -- Appelle la fonction main de manière différée
end

reaper.PreventUIRefresh(1)
reaper.Undo_BeginBlock() -- Begining of the undo block. Leave it at the top of your main function.
selected_track = reaper.GetSelectedTrack(0, 0)
reaper.Main_OnCommand(40297, 0) -- Unselect all tracks
main()-- Lance la boucle principale

reaper.Undo_EndBlock("Char forward", -1) -- End of the undo block. Leave it at the bottom of your main function.
reaper.UpdateArrange()
reaper.PreventUIRefresh(-1)
