let pi = 3.14159265

let deg2rad = Rotate.deg2rad

(*
let getHisto matrix =
	let (w, h) = Matrix.get_dims matrix in
		let histo = Matrix.make w 1 (0) in
			for j = 0 to h - 1 do
				for i = 0 to w - 1 do
					if (matrix.(i).(j) = (0, 0, 0)) then
						histo.(i).(0) <- histo.(i).(0) + 1
				done
			done;
			histo

let getAvrg histo =
	let (w, h) = Matrix.get_dims histo in
		let sum = ref 0 in
			for i = 0 to w - 1 do
				sum := !sum + histo.(i).(0);
			done;
			(float_of_int !sum) /. (float_of_int w)

let getVar histo =
	let (w, h) = Matrix.get_dims histo in
		let sum2 = ref 0 in
			for i = 0 to w - 1 do
				sum2 := !sum2 + (histo.(i).(0) * histo.(i).(0));
			done;
			(float_of_int (!sum2) /. float_of_int (w)) 
				-. (getAvrg histo *. getAvrg histo)

let getAngle matrix =
	let newVariance = ref 0. in
	let newAngle = ref 0. and angle = ref 0. in
		while (!angle < 45.) do
			let newMatrix = Rotate.rotate !angle matrix in
				let histo = getHisto newMatrix in
					let variance = getVar histo in
					if (variance > !newVariance) then
						begin
						newAngle := !angle;
						newVariance := variance;
						end;
					angle := !angle +. 1.;
		done;
		(!newAngle -. 90.)
*)

let hough matrix =
	let (w, h) = Matrix.get_dims matrix in
	let p = ref 0 in
	let theta = ref 0 in
	let diago = (int_of_float(sqrt(float_of_int(w*w + h*h))) + 1) in
		let accu = Matrix.make 91 diago 0 in
			for j = 0 to h - 1 do
				for i = 0 to w - 1 do
					if (matrix.(i).(j) = (0, 0, 0)) then
					begin
					for angle = 0 to 90 do
						p := 1 + abs (int_of_float
						(
							float_of_int(i) *. cos(deg2rad (float_of_int angle))
							+. float_of_int(j) *. sin(deg2rad (float_of_int angle)))
						);
						accu.(angle).(!p) <- accu.(angle).(!p) + 1
					done
					end;
				done
			done;
			let max = ref 0 in
			for rho = 0 to diago - 1 do
				for angle = 0 to 90 do
					if (accu.(angle).(rho) > !max) then
					begin
						max := accu.(angle).(rho);
						theta := angle;
					end;
				done
			done;
			float_of_int (!theta - 90)