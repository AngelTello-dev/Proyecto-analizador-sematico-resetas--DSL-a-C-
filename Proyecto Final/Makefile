
FLEX_FILE = compilador.l
BISON_FILE = compilador.y
OUTPUT = compilador
SOURCE = fuente.txt

all: clean compile run

clean:
	rm -f lex.yy.c $(OUTPUT) compilador.tab.c compilador.tab.h compilador.output

compile:
	@echo "Generando analizador sintáctico..."
	bison -d -v $(BISON_FILE)
	@echo "Generando analizador léxico..."
	flex $(FLEX_FILE)
	@echo "Compilando ejecutable..."
	cc lex.yy.c compilador.tab.c -o $(OUTPUT) -lm

run:
	@echo "Ejecutando compilador..."
	./$(OUTPUT) $(SOURCE)

interactive:
	./$(OUTPUT)

debug:
	bison -d -v $(BISON_FILE)
	flex $(FLEX_FILE)
	cc -g lex.yy.c compilador.tab.c -o $(OUTPUT) -lm
	./$(OUTPUT) $(SOURCE)

build:
	bison -d $(BISON_FILE)
	flex $(FLEX_FILE)
	cc lex.yy.c compilador.tab.c -o $(OUTPUT) -lm

.PHONY: all clean compile run interactive debug build