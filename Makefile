OCAML= ocamlopt
OCAMLFLAGS= -I +lablgtk2 -I +site-lib/lablgtk2 -I +sdl -I +site-lib/sdl
OCAMLLD= bigarray.cmxa sdl.cmxa sdlloader.cmxa lablgtk.cmxa
SRC= image.ml functions.ml main.ml

all:
	$(OCAML) $(OCAMLLD) $(OCAMLFLAGS) -o OCR $(SRC)

main:
	$(OCAML) $(OCAMLFLAGS) $(OCAMLLD) -o main main.ml

image:
	$(OCAML) $(OCAMLLD) $(OCAMLFLAGS) -o image image.ml

functions:
	$(OCAML) $(OCAMLLD) $(OCAMLFLAGS) -o functions functions.ml

clean::
	rm -f *~ *.o *.cmi *.cmo *.cmx
