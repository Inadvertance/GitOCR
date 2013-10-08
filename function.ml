(* Obtains a picture's grey level *)
let greyLevel (r, g, b) =
  (
  float_of_int(r) *. 0.3 +.
  float_of_int(g) *. 0.59 +.
  float_of_int (b) *. 0.11
  ) /. 255.

(* Transforms a colored pixel into a grey one *)
let color2grey (r, g, b) =
  let grey = int_of_float (255. *. greyLevel (r, g, b)) in
    (grey, grey, grey)

(* Transforms a picture into his equivalent in greyscale *)
let image2grey src dst =
  let (w, h) = Image.get_dims src in
    for j = 0 to h - 1 do
      for i = 0 to w - 1 do
	dst.(i).(j) <- color2grey (Sdlvideo.get_pixel_color src i j)
      done
    done;
    src

let binarize_img img_grey =
  let (w, h) = Image.get_dims img_grey in
    for j = 0 to h - 1 do
      for i = 0 to w - 1 do
	let (r, g, b) = Sdlvideo.get_pixel_color img_grey i j in
	  let m = (r + g + b) / 3 in
	    if m > 128 then
	      Sdlvideo.put_pixel_color img_grey i j Sdlvideo.white
	    else
	      Sdlvideo.put_pixel_color img_grey i j Sdlvideo.black
      done
    done;
    img_grey
