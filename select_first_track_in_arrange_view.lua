function Msg(msg)
    reaper.ShowConsoleMsg(msg)
    reaper.ShowConsoleMsg("\n")
end

function Main(msg)

    -- local _, arrangeTop, _, arrangeBottom = reaper.my_getViewport(0, 0, 0, 0, 0, 0, 0, 0, true )

    topTrack = nil

    for i = 0, reaper.CountTracks(0) - 1 do 
        local track = reaper.GetTrack(0, i)
        local trackY = reaper.GetMediaTrackInfo_Value(track, "I_TCPY")
        if trackY >= 0 then
            topTrack = track
            break
        end
    end
    reaper.SetOnlyTrackSelected(topTrack)
end

Main()
