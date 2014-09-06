IRRLICHT_HOME = /usr/local/include/irrlicht
CIRRLICHT_HOME = CIrrlicht/include/

all: main

main:
	g++ src/dirrlicht/cpp/main.cpp -c -o cpp.o -I$(IRRLICHT_HOME) -I$(CIRRLICHT_HOME) -std=c++11
	
.PHONY:
	all
