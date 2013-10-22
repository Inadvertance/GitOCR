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

(* Usual function to create a surface with SDL *)
let create_surface w h = Sdlvideo.create_RGB_surface [`SWSURFACE]
  ~w:w
  ~h:h
  ~bpp:32
  ~rmask:Int32.zero
  ~gmask:Int32.zero
  ~bmask:Int32.zero
  ~amask:Int32.zero

let surface_of_matrix mat =
  let (w, h) = Matrix.get_dims mat in
    let surf = create_surface w h in
      for j = 0 to h - 1 do
        for i = 0 to w - 1 do
          Sdlvideo.put_pixel_color surf i j mat.(i).(j);
        done
      done;
      surf

(* Main display function useful for both of the next functions *)
let disp w h = Sdlvideo.set_video_mode w h [`DOUBLEBUF]

(* Same that the previous function, for a matrix *)
let disp_mat src =
  let (w, h) = Matrix.get_dims src in
    disp w h

let disp_surf src =
  let (w, h) = get_dims src in
    disp w h
 
(*
  show img dst
  affiche la surface img 
  sur la surface de destination dst (normalement l'écran)
*)
let show src dst =
  let d = Sdlvideo.display_format src in
    Sdlvideo.blit_surface d dst ();
    Sdlvideo.flip dst

let show_mat mat dst =
  show (surface_of_matrix mat) dst

(* Load an image *)
let load = Sdlloader.load_image
(* Save an image *)
let save matrix =
  let image = (surface_of_matrix matrix) in
    Sdlvideo.unlock image;
    Sdlvideo.save_BMP image "result.bmp"

(* Code du TP *)
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