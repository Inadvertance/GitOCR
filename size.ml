let average matrix i j =
	let tempMatrix = Matrix.make 2 2 (0, 0, 0) in
		tempMatrix.(0).(0) <- matrix.(i-1).(j);
		tempMatrix.(1).(0) <- matrix.(i+1).(j);
		tempMatrix.(0).(1) <- matrix.(i).(j-1);
		tempMatrix.(1).(1) <- matrix.(i).(j+1);
		let avrg = ref 0 in
			for j = 0 to 2 do
				for i = 0 to 2 do
					avrg := !avrg + Functions.greycomp (tempMatrix.(i).(j))
				done
			done;
			!avrg/4

let reduction matrix =
	let (w, h) = Matrix.get_dims matrix in
		let newMatrix = Matrix.make (w) (h) (0, 0, 0) in
			for j = 0 to (h/2) - 1 do
				for i = 0 to (w/2) - 1 do
					let comp = average matrix i j in
					newMatrix.(i).(j) <- (comp, comp, comp)
				done
			done;
			newMatrix