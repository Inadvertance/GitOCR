let greyLevel (r, g, b) =
  (
  float_of_int(r) *. 0.3 +.
  float_of_int(g) *. 0.59 +.
  float_of_int (b) *. 0.11
  ) /. 255.
(* Obtains a picture's grey level *)
