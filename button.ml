class button (_image : Sdlvideo.surface) (_x : int) (_y : int) =
    object (self)
        method img = _image
        method x = _x
        method y = _y
        method w = let w, _, _ = Sdlvideo.surface_dims _image in w
        method h = let _, h, _ = Sdlvideo.surface_dims _image in h
        method render =
            let win = Sdlvideo.get_video_surface () in
            let r = Sdlvideo.rect self#x self#y 0 0 in
            Sdlvideo.blit_surface ~dst_rect:r ~src:self#img ~dst:win ();
        method is_in x y =
            x >= self#x && x <= (self#x + self#w) &&
            y >= self#y && y <= (self#y + self#h)
    end
