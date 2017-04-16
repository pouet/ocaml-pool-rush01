RESULT 	= tama
SOURCES = event.ml tama.ml button.ml frame.ml main.ml
LIBS    = bigarray sdlttf sdl sdlmixer sdlloader
INCDIRS = ~/.opam/system/lib/sdl
OCAMLLDFLAGS = -cclib "-framework Cocoa"
THREADS = true

OCAMLMAKEFILE = OcamlMakefile
include $(OCAMLMAKEFILE)
