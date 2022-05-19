TARGET=examen
all: ${TARGET}

${TARGET}: ${TARGET}_parser.o ${TARGET}_lexer.o main.o
	g++  -g -o $@ $^

main.o: main.cpp
	g++  -g -c -o $@ $<

${TARGET}_lexer.o: ${TARGET}_lexer.cpp
	g++ -g -c -o $@ $<

${TARGET}_lexer.cpp: ${TARGET}.l
	flex -o $@ $<

${TARGET}_parser.cpp: ${TARGET}.y
	bison -v --defines=tokens.h -W -o $@ $<

${TARGET}_parser.o: ${TARGET}_parser.cpp
	g++  -g -c -o $@ $<

clean:
	rm -f *.o
	rm -f ${TARGET}_lexer.cpp
	rm -f ${TARGET}
	rm -f ${TARGET}_parser.cpp
	rm -f tokens.h
