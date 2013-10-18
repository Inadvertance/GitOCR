let getCenter matrix =
	let (w, h) = Matrix.get_dims matrix in
		((w / 2) - 1, (h / 2) - 1)

let pi = 3.14159265

(* From angle in radians to angle in degrees *)
let rad2deg radAngle = 180. *. radAngle /. pi

(* From angle in degrees to angle in radians *)
let deg2rad degAngle = pi *. degAngle /. 180.

(* Get the new width of the rotated image before applying the rotation *)
let getNewWidth angle matrix =
	let (w, h) = Matrix.get_dims matrix in
		int_of_float 
		(
			float_of_int (w) *. cos(deg2rad angle)
			+. float_of_int (h) *. sin(deg2rad angle)
		)

(* Get the new height of the rotated image before applying the rotation *)
let getNewHeight angle matrix =
	let (w, h) = Matrix.get_dims matrix in
		int_of_float 
		(
			float_of_int (h) *. cos(deg2rad angle)
			+. float_of_int (w) *. sin(deg2rad angle)
		)

(* Obtain the X coordinate of the rotated image's center *)
let getNewCenterX angle matrix = ((getNewWidth angle matrix) / 2) - 1

(* Obtain the Y coordinate of the rotated image's center *)
let getNewCenterY angle matrix = ((getNewHeight angle matrix) / 2) - 1

(* Get the X coordinate of a pixel BEFORE rotation *)
let getX angle matrix i j =
	let (centerX, centerY) = getCenter matrix in
		let newCenterX = getNewCenterX angle matrix and
			  newCenterY = getNewCenterX angle matrix in
				int_of_float
				(
					sin(deg2rad angle) *. float_of_int (j - newCenterY)
		  		+. cos(deg2rad angle) *. float_of_int (i - newCenterX)
		  		+. float_of_int (centerX)
				)

(* Get the Y coordinate of a pixel BEFORE rotation *)
let getY angle matrix i j =
	let (centerX, centerY) = getCenter matrix in
		let newCenterX = getNewCenterX angle matrix and
		 	  newCenterY = getNewCenterY angle matrix in
					int_of_float (sin(deg2rad angle) *. float_of_int (i - newCenterX))
		  	+ int_of_float (cos(deg2rad angle) *. float_of_int (j - newCenterY))
		  	+ centerY

let rotate angle matrix =
	let (newW, newH) = (getNewWidth angle matrix, getNewHeight angle matrix) and
			(w, h) = Matrix.get_dims matrix in
		let newMatrix = Matrix.make newW newH (0, 0, 0) in
			for j = 0 to newH - 1 do
				for i = 0 to newW - 1 do
					let x = (getX angle newMatrix i j) and
							y = (getY angle newMatrix i j) in
						if (0 <= x && x < w && 0 <= y && y < h)  then
							newMatrix.(i).(j) <- matrix.(x).(y)
						else
							newMatrix.(i).(j) <- (255, 255, 255)
				done
			done;
			newMatrix