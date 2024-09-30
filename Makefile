PROLOG_SRC = src/*.pl

PROLOG_EXE = flp23-log

default: $(PROLOG_EXE)

$(PROLOG_EXE): $(PROLOG_SRC)
	swipl -q -g main -o $(PROLOG_EXE) -c $(PROLOG_SRC) 

run: $(PROLOG_EXE)
	./$(PROLOG_EXE)

clean:
	rm -f $(PROLOG_EXE)
