OCAML= ocamlopt
OCAMLFLAGS= -I +lablgtk2 -I +site-lib/lablgtk2 -I +sdl -I +site-lib/sdl
OCAMLLD= bigarray.cmxa sdl.cmxa sdlloader.cmxa lablgtk.cmxa
SRC= matrix.ml image.ml functions.ml rotate.ml main.ml

all:
	$(OCAML) $(OCAMLLD) $(OCAMLFLAGS) -o OCR $(SRC)

clean::
	rm -f *~ *.o *.cmi *.cmo *.cmx