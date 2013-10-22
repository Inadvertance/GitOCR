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

(* r, g and b are already the same so we just return one of them *)
let greycomp (r, g, b) = r

let greyLevel2 (r, g, b) =
  (
  float_of_int(r) *. 0.3 +.
  float_of_int(g) *. 0.59 +.
  float_of_int (b) *. 0.11
  )

let img2mat img =
  Sdlvideo.lock img;
  let (w, h) = Image.get_dims img in
    let mat = Matrix.make w h (0, 0, 0) in
      for j = 0 to h - 1 do
        for i = 0 to w - 1 do
          mat.(i).(j) <- Sdlvideo.get_pixel_color img i j
        done
      done;
      mat

(* Transform a picture into its matrix equivalent in greyscale *)
let image2grey img mat =
  Sdlvideo.lock img;
  let (w, h) = Image.get_dims img in
    for j = 0 to h - 1 do
      for i = 0 to w - 1 do
        mat.(i).(j) <- color2grey (Sdlvideo.get_pixel_color img i j)
      done
    done;
    mat

(* Get the average threshold of the image *)
let getThreshold mat =
  let (w, h) = Matrix.get_dims mat in
    let threshold = ref 0 in
    for j = 0 to h - 1 do
      for i = 0 to w - 1 do
        threshold := !threshold + int_of_float (greyLevel2 (mat.(i).(j)))
      done
    done;
    !threshold / (w * h)
      

(* Binarize a matrix using the average threshold of the image *)
let binarize mat =
  let (w, h) = Matrix.get_dims mat in
    let threshold = getThreshold mat in
    for j = 0 to h - 1 do
      for i = 0 to w - 1 do
        if ((greycomp (mat.(i).(j))) < threshold) then
          mat.(i).(j) <- (0, 0, 0) (* BLACK *)
        else
          mat.(i).(j) <- (255, 255, 255) (* WHITE *)
        done
      done;
      mat

let color_of_int c = (c, c, c)

let compare a b = if (a = b) then 0 else if (a > b) then 1 else -1

let getMedianValue mat i j =
  let auxArray = Array.make 9 (0) in
    begin
      auxArray.(0) <- int_of_float ( greyLevel2 (mat.(i-1).(j-1)) );
      auxArray.(1) <- int_of_float ( greyLevel2 (mat.(i).(j-1)) );
      auxArray.(2) <- int_of_float ( greyLevel2 (mat.(i+1).(j-1)) );
      auxArray.(3) <- int_of_float ( greyLevel2 (mat.(i).(j-1)) );
      auxArray.(4) <- int_of_float ( greyLevel2 (mat.(i).(j)) );
      auxArray.(5) <- int_of_float ( greyLevel2 (mat.(i).(j+1)) );
      auxArray.(6) <- int_of_float ( greyLevel2 (mat.(i+1).(j-1)) );
      auxArray.(7) <- int_of_float ( greyLevel2 (mat.(i).(j)) );
      auxArray.(8) <- int_of_float ( greyLevel2 (mat.(i).(j+1)) );
      Array.fast_sort compare auxArray;
    end;
    color_of_int (auxArray.(4))

let medianFilter mat =
  let (w, h) = Matrix.get_dims mat in
  let newMat = Matrix.make w h (0,0,0) in
    for j = 1 to h - 2 do
      for i = 1 to w - 2 do
        newMat.(i).(j) <- (getMedianValue mat i j);
      done
    done;
    newMat