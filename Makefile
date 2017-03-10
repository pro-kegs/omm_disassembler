LINK.o = $(LINK.cc)
CXXFLAGS = -std=c++14 -g -Wall -Wno-sign-compare
CCFLAGS = -g
CPPFLAGS += -I cxx/include

VPATH = cxx/src

.PHONY: all
all: omm_disassembler hexterm
.PHONY: clean
clean:
	$(RM) hexterm hexterm.omf hexterm.o


o:
	mkdir o

omm_disassembler: o/omm_disassembler.o o/disassembler.o o/mapped_file.o
	$(LINK.o) $^ $(LDLIBS) -o $@

o/omm_disassembler.o: omm_disassembler.cpp disassembler.h | o
o/disassembler.o: disassembler.cpp disassembler.h | o
o/mapped_file.o: cxx/src/mapped_file.cpp | o

o/%.o : %.cpp
	$(CXX) -c $(CPPFLAGS) $(CXXFLAGS) -o $@ $<


hexterm : hexterm.omf
	mpw makebiniigs -org \$$0ff0 -p -s  -o $@ $^



hexterm.omf : hexterm.o
	mpw linkiigs -x -o $@ $^

hexterm.o : hexterm.aii
	mpw asmiigs -i "{MPW}Interfaces:ModemWorks" -o $@ $^
