type t =
    | Click
    | Quit
    | None

let get_event () =
    match Sdlevent.poll () with
    | None      -> (None, 0, 0)
    | Some ev   ->
        match ev with
        | Sdlevent.MOUSEBUTTONDOWN { Sdlevent.mbe_button = Sdlmouse.BUTTON_LEFT; Sdlevent.mbe_x = x; Sdlevent.mbe_y = y } -> (Click, x, y)
        | Sdlevent.QUIT | Sdlevent.KEYDOWN { Sdlevent.keysym = Sdlkey.KEY_ESCAPE }     -> (Quit, 0, 0)
        | _                                                                            -> (None, 0, 0)
 
let quit_requested ev = ev = Quit
