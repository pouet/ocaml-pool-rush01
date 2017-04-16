type images = {
    back : Sdlvideo.surface;
    pika : Sdlvideo.surface;
    frame : Sdlvideo.surface;
    bar : Sdlvideo.surface;
}

type musics = {
    happy : Sdlmixer.chunk;
    scream : Sdlmixer.chunk;
    thunder : Sdlmixer.chunk;
    tired : Sdlmixer.chunk;
    pikaaa : Sdlmixer.chunk;
    snd_effect : Sdlmixer.chunk;
    pikachu : Sdlmixer.chunk;
}

type params = {
    win : Sdlvideo.surface;
    font12 : Sdlttf.font;
    font25 : Sdlttf.font;
    font50 : Sdlttf.font;
    img : images;
    snd : musics;
    mutable ticks : int;
    btns : Button.button list;
}

let new_image_frame s =
    let font = Sdlttf.open_font "font/pokemon.ttf" 25 in
    let img = Sdlloader.load_image "gfx/frame.png" in
    let img_w, img_h, _ = Sdlvideo.surface_dims img in

    let txt = Sdlttf.render_text_blended font s ~fg:Sdlvideo.black in
    let w, h, _ = Sdlvideo.surface_dims txt in

    let r = Sdlvideo.rect ((img_w / 2) - (w / 2)) ((img_h / 2) - (h / 2)) 0 0 in
    Sdlvideo.blit_surface ~dst_rect:r ~src:txt ~dst:img ();

    img

let render_bar glbl x y offx s pct =
    let r = Sdlvideo.rect x y 0 0 in
    Sdlvideo.blit_surface ~dst_rect:r ~src:glbl.img.bar ~dst:glbl.win ();

    let r = Sdlvideo.rect (x + 2) (y + 2) pct (4) in
    Sdlvideo.fill_rect ~rect:r glbl.win (Sdlvideo.map_RGB glbl.win Sdlvideo.red);

    let txt = Sdlttf.render_text_blended glbl.font12 s ~fg:Sdlvideo.black in
    let r = Sdlvideo.rect (x + offx) (y - 16) 0 0 in
    Sdlvideo.blit_surface ~dst_rect:r ~src:txt ~dst:glbl.win ()

let render_frame glbl x y offx offy s =
    let r = Sdlvideo.rect x y 0 0 in
    Sdlvideo.blit_surface ~dst_rect:r ~src:glbl.img.frame ~dst:glbl.win ();

    let txt = Sdlttf.render_text_blended glbl.font25 s ~fg:Sdlvideo.black in
    let r = Sdlvideo.rect (x + offx) (y + offy) 0 0 in
    Sdlvideo.blit_surface ~dst_rect:r ~src:txt ~dst:glbl.win ()

let render_all glbl (tama : Tama.tama) =

    Sdlvideo.blit_surface glbl.img.back glbl.win ();

    if tama#is_alive then begin
        let r = Sdlvideo.rect 200 50 0 0 in
        Sdlvideo.blit_surface ~dst_rect:r ~src:glbl.img.pika ~dst:glbl.win ();

        let x, y = 250, 30 in
        render_bar glbl x y 15 "health" tama#get_health;
        render_bar glbl (x + 130) y 15 "energy" tama#get_energy;
        render_bar glbl (x + 2 * 130) y 15 "hygiene" tama#get_hygiene;
        render_bar glbl (x + 3 * 130) y 15 "happy" tama#get_happyness;

        List.iter (fun x -> x#render) glbl.btns;
    end
    else begin
        let txt = Sdlttf.render_text_blended glbl.font50 "game over" ~fg:Sdlvideo.black in
        let r = Sdlvideo.rect 300 300 0 0 in
        Sdlvideo.blit_surface ~dst_rect:r ~src:txt ~dst:glbl.win ()
    end;

    Sdlvideo.flip glbl.win

let rec main_loop glbl (tama : Tama.tama) time =
    let ev, x, y = Event.get_event () in

    let fct i el =
        if el#is_in x y then begin
            match i with
            | 0 -> tama#eat; Sdlmixer.play_sound glbl.snd.happy
            | 1 -> tama#thunder; Sdlmixer.play_sound glbl.snd.thunder
            | 2 -> tama#bath; Sdlmixer.play_sound glbl.snd.pikachu
            | 3 -> tama#kill; Sdlmixer.play_sound glbl.snd.pikaaa
            | _ -> ()
        end
    in

    if tama#is_alive then
        List.iteri fct glbl.btns
    else if tama#die_sound_played = false then begin
        tama#update_die_snd_played;
        Sdlmixer.play_sound glbl.snd.scream
    end;

    render_all glbl tama;
    glbl.ticks <- Frame.frame_wait glbl.ticks;

    if Event.quit_requested ev = false then begin
        if time > Frame.fps then begin
            tama#sethealth (-1);
            main_loop glbl tama 0
        end
        else
            main_loop glbl tama (time + 1)
    end
    else begin
        tama#save
    end

let init () =
    Sdl.init [`EVERYTHING];
    at_exit Sdl.quit;
    Sdlttf.init ();
    at_exit Sdlttf.quit;
    Sdlmixer.open_audio ();
    at_exit Sdlmixer.close_audio

let load_images () =
    {
        back = Sdlloader.load_image "gfx/back.png";
        pika = Sdlloader.load_image "gfx/pikachu.png";
        frame = Sdlloader.load_image "gfx/frame.png";
        bar = Sdlloader.load_image "gfx/bar.png";
    }

let load_sounds () =
    {
        happy = Sdlmixer.loadWAV "sfx/pika_happy.wav";
        scream = Sdlmixer.loadWAV "sfx/pika_scream.wav";
        thunder = Sdlmixer.loadWAV "sfx/pika_thunder.wav";
        tired = Sdlmixer.loadWAV "sfx/pika_tired.wav";
        pikaaa = Sdlmixer.loadWAV "sfx/pikaaaa.wav";
        snd_effect = Sdlmixer.loadWAV "sfx/pikachu_snd_effect.wav";
        pikachu = Sdlmixer.loadWAV "sfx/pikachu.wav";
    }

let _ =
    try
        init ();

        let x, y = 60, 660 in

        let glbl = {
            win = Sdlvideo.set_video_mode 1024 768 [`DOUBLEBUF];
            font12 = Sdlttf.open_font "font/pokemon.ttf" 12;
            font25 = Sdlttf.open_font "font/pokemon.ttf" 25;
            font50 = Sdlttf.open_font "font/pokemon.ttf" 50;
            img = load_images ();
            snd = load_sounds ();
            ticks = Sdltimer.get_ticks ();
            btns = [
                new Button.button (new_image_frame "eat") x y;
                new Button.button (new_image_frame "thunder") (x + 1 * 230) y;
                new Button.button (new_image_frame "bath") (x + 2 * 230) y;
                new Button.button (new_image_frame "kill") (x + 3 * 230) y;
            ];
        } in

        main_loop glbl (new Tama.tama) 0

    with
    | _     -> print_endline "Ups... something went wrong !"
