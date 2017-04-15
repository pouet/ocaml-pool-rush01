(*     img * x * y * string * offx * offy *)

type images = {
    pika : Sdlvideo.surface;
    frame : Sdlvideo.surface;
    bar : Sdlvideo.surface
}

type params = {
    win : Sdlvideo.surface;
    font16 : Sdlttf.font;
    font25 : Sdlttf.font;
    img : images;
}


let render_bar glbl x y offx s pct =
    let r = Sdlvideo.rect x y 0 0 in
    Sdlvideo.blit_surface ~dst_rect:r ~src:glbl.img.bar ~dst:glbl.win ();

    let r = Sdlvideo.rect (x + 2) (y + 2) pct (4) in
    Sdlvideo.fill_rect ~rect:r glbl.win (Sdlvideo.map_RGB glbl.win Sdlvideo.red);

    let txt = Sdlttf.render_text_blended glbl.font16 s ~fg:Sdlvideo.black in
    let r = Sdlvideo.rect (x + offx) (y - 16) 0 0 in
    Sdlvideo.blit_surface ~dst_rect:r ~src:txt ~dst:glbl.win ()

let render_frame glbl x y offx offy s =
    let r = Sdlvideo.rect x y 0 0 in
    Sdlvideo.blit_surface ~dst_rect:r ~src:glbl.img.frame ~dst:glbl.win ();

    let txt = Sdlttf.render_text_blended glbl.font25 s ~fg:Sdlvideo.black in
    let r = Sdlvideo.rect (x + offx) (y + offy) 0 0 in
    Sdlvideo.blit_surface ~dst_rect:r ~src:txt ~dst:glbl.win ()

let render_all glbl =
    let r = Sdlvideo.rect 200 50 0 0 in

    Sdlvideo.fill_rect glbl.win (Sdlvideo.map_RGB glbl.win Sdlvideo.green);

    Sdlvideo.blit_surface ~dst_rect:r ~src:glbl.img.pika ~dst:glbl.win ();

    let x, y = 250, 30 in

    render_bar glbl x y 15 "health" 50;
    render_bar glbl (x + 130) y 15 "energy" 23;
    render_bar glbl (x + 2 * 130) y 15 "energy" 100;
    render_bar glbl (x + 3 * 130) y 15 "energy" 0;

    let x, y = 60, 660 in

    render_frame glbl x y 62 32 "eat";
    render_frame glbl (x + 230) y 15 32 "thunder";
    render_frame glbl (x + 2 * 230) y 51 32 "bath";
    render_frame glbl (x + 3 * 230) y 53 32 "kill";

    Sdlvideo.flip glbl.win


type event =
    | Click
    | Quit
    | None

let get_event () =
    if Sdlevent.has_event () = false then (None, 0, 0)
    else begin
        match Sdlevent.wait_event () with
        | Sdlevent.MOUSEBUTTONDOWN m -> (Click, m.mbe_x, m.mbe_y)
(*         | Sdlevent.MOUSEBUTTONDOWN { mbe_x; mbe_y; mbe_button = Sdlmouse.BUTTON_LEFT } -> (Click, mbe_x, mbe_y) *)
        | Sdlevent.QUIT | Sdlevent.KEYDOWN { Sdlevent.keysym = Sdlkey.KEY_ESCAPE }     -> (Quit, 0, 0)
        | Sdlevent.KEYDOWN { Sdlevent.keysym } -> print_endline "ok"; (Click, 0, 0)
        | _                                                                            -> (None, 0, 0)
    end

let rec main_loop glbl =
    let ev, x, y = get_event () in

    render_all glbl;

    if ev <> Quit then
        main_loop glbl

let init () =
    Sdl.init [`EVERYTHING];
    at_exit Sdl.quit;
    Sdlttf.init ();
    at_exit Sdlttf.quit

let load_images () =
    {
        pika = Sdlloader.load_image "gfx/pikachu.png";
        frame = Sdlloader.load_image "gfx/frame.png";
        bar = Sdlloader.load_image "gfx/bar.png";
    }

let _ =
    init ();

    let glbl = {
        win = Sdlvideo.set_video_mode 1024 768 [`DOUBLEBUF];
        font16 = Sdlttf.open_font "font/pokemon.ttf" 12;
        font25 = Sdlttf.open_font "font/pokemon.ttf" 25;
        img = load_images ();
    } in

    main_loop glbl
