let image = ref (Image.create_surface 0 0)
let matrix = ref (Matrix.make 0 0 (0, 0, 0))

let window =
  ignore(GMain.init ());
  let wnd = GWindow.window
    ~title:"Coding Experiment"
    ~position:`CENTER 
    ~resizable:false
    ~width:1800 ~height:1000 () in
  ignore(wnd#connect#destroy GMain.quit);
  wnd

let lock () = Sdlvideo.lock !image

let unlock () = Sdlvideo.unlock !image
(* MODULE DE CHARGEMENT ET DE SAUVEGARDE D'IMAGE *)
(*
module Aux =
  struct
    let load (text : GText.view) file =
      let ich = open_in file in
      let len = in_channel_length ich in
      let buf = Buffer.create len in
      Buffer.add_channel buf ich len;
      close_in ich;
      text#buffer#set_text (Buffer.contents buf)  
      
    let save (text : GText.view) file =
      let och = open_out file in
      output_string och (text#buffer#get_text ());
      close_out och
    end
*)

(* wait for a key ... *)
let rec wait_key () =
  let e = Sdlevent.wait_event () in
    match e with
        Sdlevent.KEYDOWN _ -> ()
      | Sdlevent.QUIT -> GMain.quit ()
      | _ -> wait_key ()

let show img =
  let display = Image.disp_mat img in
    begin
      lock ();
      Image.show_mat img display;
    end

(* MESSAGE SENT TO THE USER AGAINST UNWANTED QUIT *)
let confirm _ =
  let dialog = GWindow.message_dialog
    ~message:"<b>Do you really want to quit ?</b>"
    ~parent:window
    ~destroy_with_parent:true
    ~use_markup:true
    ~message_type:`QUESTION
    ~position:`CENTER_ON_PARENT
    ~buttons:GWindow.Buttons.yes_no () in
  let res = dialog#run () = `NO in
  dialog#destroy ();
  res

let vbox = GPack.vbox
  ~spacing:10
  ~border_width:10
  ~packing:window#add ()

let hbox_img = GPack.hbox
  ~spacing:10
  ~border_width:10
  ~width:800
  ~height:600
  ~packing:vbox#add ()

let hbox_text = GPack.hbox
  ~spacing:10
  ~border_width:10
  ~width:400
  ~height:300
  ~packing:vbox#add ()

let toptoolbar = GPack.button_box `HORIZONTAL
  ~layout:`SPREAD
  ~packing:(vbox#pack ~expand:false) ()

let toolbar = GPack.button_box `HORIZONTAL
  ~layout:`EDGE
  ~packing:(vbox#pack ~expand:false) ()

let textbox =
  let scroll = GBin.scrolled_window
    ~hpolicy:`ALWAYS
    ~vpolicy:`ALWAYS
    ~shadow_type:`ETCHED_IN
    ~packing:hbox_text#add () in
  let txt = GText.view ~packing:scroll#add () in
  txt#misc#modify_font_by_name "Monospace 10";
  txt

let img = GMisc.image
    ~stock: `OPEN
    ~width: 800
    ~height: 600
  ~packing: hbox_img#add ()

let saveImg () = Image.save !matrix

let button_saveImg =
  let button = GButton.button
    ~label: "Save image"
    ~packing: toptoolbar#add () in
        ignore(button#connect#clicked ~callback:(saveImg));
    button

let showImg button () =
  match button#filename with
    | Some i ->
      image := Image.load i;
      lock ();
      img#set_file i;
      matrix := Functions.img2mat !image;
    | None -> ()

let button_open =
  let button = GFile.chooser_button
                 ~title:"Open"
                 ~action:`OPEN
                 ~packing:toptoolbar#add () in
              ignore (button#connect#selection_changed (showImg button));
     button

(* Preprocess without median filter *)
let preprocess () =
  matrix := Functions.binarize (Functions.image2grey !image !matrix);
  show !matrix

let rotPos90 () =
  matrix := Rotate.rotPos90 !matrix;
  show !matrix

let rotate () =
  let angle = (Angle.hough !matrix) in
    matrix := Rotate.rotate angle !matrix;
  (*
  let angle = Angle.getAngle !matrix in
    matrix := Rotate.rotate angle !matrix;
  *)
  show !matrix

(* Preprocess with median filter *)
let medianFilter () =
  matrix := Functions.medianFilter !matrix;
  show !matrix

let button_preprocess =
  let button = GButton.button
    ~label:"Preprocessing"
    ~packing:toptoolbar#add () in
      ignore(button#connect#clicked ~callback:(preprocess));
    button

let button_rotPos90 =
  let button = GButton.button
    ~label:"+90"
    ~packing:toptoolbar#add () in
      ignore(button#connect#clicked ~callback:(rotPos90));
    button

let button_rotate =
  let button = GButton.button
    ~label:"Rotate"
    ~packing:toptoolbar#add () in
      ignore(button#connect#clicked ~callback:(rotate));
    button

let button_medianFilter =
  let button = GButton.button
    ~label:"Filter"
    ~packing:toptoolbar#add () in
      ignore(button#connect#clicked ~callback:(medianFilter));
    button

let button_about =
  let dialog = GWindow.about_dialog
    ~authors:["Interface creation : Andrea GUEUGNAUT \n
    OCR's source code : 
    Tristan CHAMAYOU
     Maxime BUFFIN
      Benoit GARNIER
       Andrea GUEUGNAUT"]
    ~copyright:"This project may be useful for learning and understanding
    of how to make a simple OCR with OCaml programming language. \n
    You are allowed to use this project
     for learning and understanding purposes."
    ~license:"Project released under Public License"
    ~version:"Soutenance 1.0"
    ~website:"http://2fat2fly4real.hostei.com"
    ~website_label:"Coding Experiment"
    ~position:`CENTER_ON_PARENT
    ~parent:window
    ~destroy_with_parent:true () in
  let button = GButton.button ~stock:`ABOUT ~packing:toolbar#add () in
  ignore(GMisc.image ~stock:`ABOUT ~packing:button#set_image ());
  ignore(button#connect#clicked (fun () -> ignore (dialog#run ());
  ignore(dialog#misc#hide ())));
  button

let button_help = GButton.button
    ~stock:`HELP
    ~packing:toolbar#add ()

let button_detect =
  let button = GButton.button
    ~label:"Detect text"
    ~packing:toolbar#add () in
      ignore(button#connect#clicked ~callback:(detect));
    button

let button_quit =
  let button = GButton.button
    ~stock:`QUIT
    ~packing:toolbar#add () in
  ignore(button#connect#clicked ~callback:GMain.quit);
  button
  
let _ =
  ignore(window#event#connect#delete confirm);
  window#show ();
  GMain.main ()
