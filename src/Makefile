# Makefile for the examples

MAKE=make

SRCS=$(wildcard *.mod)
OBJS=$(SRCS:.mod=.lp)

export TJPATH = kernel/ljf:kernel/lkf:kernel/imbed:utils:fpc/resolution:tests/eprover:tests/resolution:utils

.PHONY: all
all: compile

compile: compile_inner $(OBJS)

compile_inner:
	cd utils && $(MAKE)
	cd kernel && $(MAKE)
	cd fpc && $(MAKE)
	cd tests && $(MAKE)

cc: all clean

%.lpo : %.mod %.sig
	tjcc  $*

%.lp : %.lpo
	tjlink  $*

-include depend
depend: *.mod *.sig
	tjdepend *.mod > depend-stage
	mv depend-stage depend

.PHONY: clean
clean:
	rm -rf _debug
	rm -f *.lpo *.lp depend
	cd tests && $(MAKE) clean
	cd fpc && $(MAKE) clean
	cd kernel && $(MAKE) clean
	cd utils && $(MAKE) clean

