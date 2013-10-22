type rectangle =
  {
    x : int;
    y : int;
    w : int;
    h : int;
  }

type binaryTree =
  | Empty
  | Node of binaryTree * rectangle * binaryTree

let create i j width height =
  {
    x = i;
    y = j;
    w = width;
    h = height;
  }

let make matrix =
  let (w, h) = Matrix.get_dims matrix in
    create 0 0 w h

let print rectangle matrix =
  let w = rectangle.w and
      h = rectangle.h in
    for i = 0 to w - 1 do
      matrix.(i).(rectangle.y) <- (0, 0, 0);
      matrix.(i).(h) <- (0, 0, 0)
    done;
    for j = 0 to h - 1 do
      matrix.(rectangle.x).(j) <- (0, 0, 0);
      matrix.(rectangle.width).(j) <- (0, 0, 0)
    done;