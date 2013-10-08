(* Dimensions d'une image *)
let get_dims img =
  (
  (Sdlvideo.surface_info img).Sdlvideo.w,
  (Sdlvideo.surface_info img).Sdlvideo.h
  )

(* init de SDL *)
let sdl_init () =
  begin
    Sdl.init [`EVERYTHING];
    Sdlevent.enable_events Sdlevent.all_events_mask;
  end

(* Load an image *)
let load_image = Sdlloader.load_image

(* Usual function to create a surface with SDL *)
let create_surface w h = Sdlvideo.create_RGB_surface [`SWSURFACE]
  ~w:w
  ~h:h
  ~bpp:32
  ~rmask:Int32.zero
  ~gmask:Int32.zero
  ~bmask:Int32.zero
  ~amask:Int32.zero

(* Obtain a display surface to draw it afterwards *)
let disp_surf w h = Sdlvideo.set_video_mode w h [`DOUBLEBUF]

(* attendre une touche ... *)
let rec wait_key () =
  let e = Sdlevent.wait_event () in
    match e with
    Sdlevent.KEYDOWN _ -> ()
      | _ -> wait_key ()
 
(*
  show img dst
  affiche la surface img sur la surface de destination dst (normalement l'écran)
*)
let show src dst =
  let d = Sdlvideo.display_format src in
    Sdlvideo.blit_surface d dst ();
    Sdlvideo.flip dst

(*
(* main *)
let main () =
  begin
    (* Nous voulons 1 argument *)
    if Array.length (Sys.argv) < 2 then
      failwith "Il manque le nom du fichier!";
    (* Initialisation de SDL *)
    sdl_init ();
    let img = Sdlloader.load_image Sys.argv.(1) in
    (* On récupère les dimensions *)
    let (w,h) = get_dims img in
    (* On crée la surface d'affichage en doublebuffering *)
    let display = Sdlvideo.set_video_mode w h [`DOUBLEBUF] in
      (* on affiche l'image *)
      show img display;
      (* on attend une touche *)
      wait_key ();
      (* on quitte *)
      exit 0
  end
 *)
