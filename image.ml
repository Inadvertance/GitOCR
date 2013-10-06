let sdl_init () =
  begin
    Sdl.init [`EVERYTHING];
    Sdlttf.init ();
    Sdlevent.enable_events Sdlevent.all_events_mask;
  end
  
let load = Sdlloader.load_image
