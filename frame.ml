let fps = 50
let fps_dflt = 1000 / fps

let rec frame_wait _ticks =
    let ticks = Sdltimer.get_ticks () - _ticks in
    if ticks >= fps_dflt then
        Sdltimer.get_ticks ()
    else begin
        Sdltimer.delay 3;
        frame_wait _ticks
    end
