let window =
  GMain.init ();
  let wnd = GWindow.window
    ~title:"Coding Experiment"
    ~position:`CENTER 
    ~resizable:false
    ~width:600 ~height:400 () in
  wnd#connect#destroy GMain.quit;
  wnd

  
(* MODULE DE CHARGEMENT ET DE SAUVEGARDE D'IMAGE *)
module Aux = (* A FAIRE CORRECTEMENT *)
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
  
(* MESSAGE LORSQUE L'UTILISATEUR ESSAYE DE QUITTER *)
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

let text =
  let scroll = GBin.scrolled_window
    ~hpolicy:`ALWAYS
    ~vpolicy:`ALWAYS
    ~shadow_type:`ETCHED_IN
    ~packing:vbox#add () in
  let txt = GText.view ~packing:scroll#add () in
  txt#misc#modify_font_by_name "Monospace 10";
  txt
  
let topbbox = GPack.button_box `HORIZONTAL
  ~layout:`SPREAD
  ~packing:(vbox#pack ~expand:false) ()
  
let help_func () = print_endline "HELP"

let open_func () = print_endline "Looking for a file..."
let open_msg () = print_endline "Open a choosen file..."

let save_func () = print_endline "Saving..."
let save_msg () = print_endline "Save the current file ?"

let saveAs_func () = print_endline "Saving as..."

let button_open stock event action =
  let dialog = GWindow.file_chooser_dialog
    ~action:`OPEN
    ~parent:window
    ~position:`CENTER_ON_PARENT
    ~destroy_with_parent:true () in
  dialog#add_button_stock `CANCEL `CANCEL;
  dialog#add_select_button_stock stock event;
  let button = GButton.button ~stock ~packing:topbbox#add () in
  GMisc.image ~stock ~packing:button#set_image ();
  button#connect#clicked (fun () ->
    if dialog#run () = `OPEN then Gaux.may action dialog#filename;
    dialog#misc#hide ());
  button
  
let button_save_as stock event action =
  let dialog = GWindow.file_chooser_dialog
    ~action:`SAVE
    ~parent:window
    ~position:`CENTER_ON_PARENT
    ~destroy_with_parent:true () in
  dialog#add_button_stock `CANCEL `CANCEL;
  dialog#add_select_button_stock stock event;
  let button = GButton.button ~stock ~packing:topbbox#add () in
  GMisc.image ~stock ~packing:button#set_image ();
  button#connect#clicked (fun () ->
    if dialog#run () = `SAVE_AS then Gaux.may action dialog#filename;
    dialog#misc#hide ());
  button
  
let open_button = button_open `OPEN `OPEN (Aux.load text)
let save_as_button = button_save_as `SAVE_AS `SAVE_AS (Aux.save text)
   

let botbbox = GPack.button_box `HORIZONTAL
  ~layout:`EDGE
  ~packing:(vbox#pack ~expand:false) ()

let button_about =
  let dialog = GWindow.about_dialog
    ~authors:["Interface creation : Andrea GUEUGNAUT \nOCR's source code : Tristan CHAMAYOU / Maxime BUFFIN / Benoit GARNIER / Andrea GUEUGNAUT"]
    ~copyright:"This project may be useful for learning and understanding 
    how to make a simple OCR with OCaml programming language. \n
    You are allowed to use this project for learning and understanding purposes.\n
    You are not allowed to copy (a part of) it without naming its source and its owners."
    ~license:"Project released under GNU General Public License"
    ~version:"Alpha 1.0"
    ~website:"http://site.com"
    ~website_label:"Coding Experiment"
    ~position:`CENTER_ON_PARENT
    ~parent:window
    ~destroy_with_parent:true () in
  let button = GButton.button ~stock:`ABOUT ~packing:botbbox#add () in
  GMisc.image ~stock:`ABOUT ~packing:button#set_image ();
  button#connect#clicked (fun () -> ignore (dialog#run ()); dialog#misc#hide ());
  button
  
let button_help =
  let button = GButton.button
    ~stock:`HELP
    ~packing:botbbox#add () in
  button#connect#clicked ~callback:help_func;
  button
  
let button_quit =
  let button = GButton.button
    ~stock:`QUIT
    ~packing:botbbox#add () in
  button#connect#clicked ~callback:GMain.quit;
  button
  
let _ =
  window#event#connect#delete confirm;
  window#show ();
  GMain.main ()
