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

-- dofile(reaper.GetResourcePath() .. "/Scripts/seb/store_selected_track.lua")
-- reaper.SetOnlyTrackSelected(track)
-- reaper.Main_OnCommand(40914, 0) -- Track: Set first selected track as last touched track
-- reaper.Main_OnCommand(40285, 0)

-- select items under cursor
-- local action_id = reaper.NamedCommandLookup("_XENAKIOS_SELITEMSUNDEDCURSELTX")
-- reaper.Main_OnCommand(action_id, 0) -- Exécute l'action SWS

-- NOTE: Jusqu'ici j'ai reproduit le comportement
--			de ma custom action
--			Maintenant, je dois mettre en place la condition pour ne me déplacer que dans les tracks visibles
--			(et il faudra mettre en place la même condition concernant la `f` des tracks)

local console = true -- true/false: display debug messages in the console

function Msg(value)
	if console then
		reaper.ShowConsoleMsg(tostring(value) .. "\n")
	end
end

-- Fonction pour vérifier si une piste est un dossier et si elle est repliée
function isFolderTrack(track)
	if track then
		local folder_depth = reaper.GetMediaTrackInfo_Value(track, "I_FOLDERDEPTH")
		local is_collapsed = reaper.GetMediaTrackInfo_Value(track, "I_FOLDERCOMPACT")
		return folder_depth == 1, is_collapsed > 0
	end
	return false, false
end

-- Fonction pour sélectionner la prochaine piste non repliée
function selectNextUnfoldedTrack()
	local selected_track = reaper.GetSelectedTrack(0, 0) -- Obtenez la première piste sélectionnée

	if not selected_track then
		reaper.ShowMessageBox("Aucune piste sélectionnée.", "Erreur", 0)
		return
	end

	local is_folder, is_collapsed = isFolderTrack(selected_track)

	Msg(is_folder)
	Msg(is_collapsed)

	if is_collapsed then
		-- goto next folder
		-- if the next folder is in collapsed test,
		-- we go to the next one

		Msg('ici')

		local action_id = reaper.NamedCommandLookup("_SWS_SELNEARESTNEXTFOLDER")
		reaper.Main_OnCommand(action_id, 0) -- Exécute l'action SWS


	else
		-- reaper.SetOnlyTrackSelected(selected_track)
		-- go to next track
		-- reaper.Main_OnCommand(40914, 0) -- Track: Set first selected track as last touched track
		reaper.Main_OnCommand(40285, 0)
		return
	end

end

-- Lance la fonction
reaper.Undo_BeginBlock()
selectNextUnfoldedTrack()
reaper.Undo_EndBlock("Sélectionner la prochaine piste non repliée", -1)
