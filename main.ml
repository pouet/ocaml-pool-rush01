let rec wait_for_escape() =
    match Sdlevent.wait_event () with
    | Sdlevent.KEYDOWN { Sdlevent.keysym = Sdlkey.KEY_ESCAPE }      -> print_endline "Bye"
    | event                                                         -> print_endline (Sdlevent.string_of_event event); wait_for_escape ()

let main () =
        Sdl.init [`VIDEO];
        at_exit Sdl.quit;
        ignore(Sdlvideo.set_video_mode 600 600 []);
        wait_for_escape ()

let () = 
    main ()
