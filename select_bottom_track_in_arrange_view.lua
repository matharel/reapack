--[[
La valeur du bas du viewport est plus importante que ce que je vois sur mon écran.
Quand j'aligne le bas d'une piste avec le bas de l'écran, j'obtiens la valeur 664. Par contre `arrangeBottom` me donne 764.
Il y a donc 100px de différences (sur mon ordi).
Il me semble que ça correspond à l'espace qui reste sous les pistes quand on scroll le plus bas possible.

J'intègre donc cette donnée incertaine dans ma fonction.
I_TCPH : int * : current TCP window height in pixels not including envelopes (read-only)
I_TCPY : int * : current TCP window Y-position in pixels relative to top of arrange view (read-only)
]]--

function Msg(msg)
    reaper.ShowConsoleMsg(msg)
    reaper.ShowConsoleMsg("\n")
end

function Main()
    -- correction empirique remarquée lors de mes essais-erreurs
    local extraHeight = 100

    local _, arrangeTop, _, arrangeBottom = reaper.my_getViewport(0, 0, 0, 0, 0, 0, 0, 0, true )

    local bottomTrack = nil
    local realArrangeBottom = arrangeBottom - extraHeight

    -- visiblement GetTrack compte à partir de zéro,
    -- alors if faut décaler de 1 et finir à zéro
    for i = reaper.CountTracks(0)-1, 0, - 1 do

        local track = reaper.GetTrack(0, i)
        local trackTop = reaper.GetMediaTrackInfo_Value(track, "I_TCPY")
        local trackHeight = reaper.GetMediaTrackInfo_Value(track, "I_TCPH")
        local trackBottom = trackTop+trackHeight

        if trackBottom < realArrangeBottom then
                bottomTrack = track
                break
        end
    end
    reaper.SetOnlyTrackSelected(bottomTrack)
end

reaper.ShowConsoleMsg('')
Main()
