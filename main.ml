let font_filename = "font/hollow.ttf"

let img_filename = "img/7.jpg"

let rec wait_for_escape win img =
    Sdlvideo.fill_rect win (Sdlvideo.map_RGB win Sdlvideo.green);
    Sdlvideo.blit_surface img win ();
    Sdlvideo.flip win;
    match Sdlevent.wait_event () with
    | Sdlevent.KEYDOWN { Sdlevent.keysym = Sdlkey.KEY_ESCAPE }      -> print_endline "Bye"
    | event                                                         -> print_endline (Sdlevent.string_of_event event); wait_for_escape win img

let init () =
    Sdl.init [`EVERYTHING];
    at_exit Sdl.quit;
    Sdlttf.init ();
    at_exit Sdlttf.quit

let _ =
    init ();

    let win = Sdlvideo.set_video_mode 600 600 [`DOUBLEBUF] in
(*     let font = Sdlttf.open_font font_filename 24 in *)

    let img = Sdlloader.load_image img_filename in

    let txt_pos = Sdlvideo.rect 10 10 10 10 in

(*
    let text = Sdlttf.render_text_blended font "toto" ~fg:Sdlvideo.red in
    Sdlvideo.blit_surface ~dst_rect:txt_pos ~src:text ~dst:win ();
*)

    Sdlvideo.fill_rect win (Sdlvideo.map_RGB win Sdlvideo.green);
    Sdlvideo.blit_surface img win ();
    Sdlvideo.flip win;

    wait_for_escape win img
