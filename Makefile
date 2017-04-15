RESULT 	= tama
SOURCES = main.ml
LIBS    = bigarray sdl
INCDIRS = ~/.opam/system/lib/sdl
OCAMLLDFLAGS = -cclib "-framework Cocoa"
THREADS = true

OCAMLMAKEFILE = OcamlMakefile
include $(OCAMLMAKEFILE)
