#
# gcc Makefile for da65
#

# Library dir
COMMON	= ../common

CFLAGS = -g -O2 -Wall -W -I$(COMMON)
CC=gcc
EBIND=emxbind
LDFLAGS=

OBJS = 	attrtab.o	\
	code.o	 	\
	config.o	\
	data.o		\
	error.o	 	\
	global.o 	\
  	handler.o	\
	main.o	 	\
        opc6502.o       \
        opc65816.o      \
        opc65c02.o      \
        opc65sc02.o     \
  	opctable.o	\
	output.o 	\
	scanner.o

LIBS = $(COMMON)/common.a


EXECS = da65

.PHONY: all
ifeq (.depend,$(wildcard .depend))
all : $(EXECS)
include .depend
else
all:	depend
	@$(MAKE) -f make/gcc.mak all
endif



da65:   $(OBJS) $(LIBS)
	$(CC) $(CFLAGS) -o $@ $(OBJS) $(LIBS)
	@if [ $(OS2_SHELL) ] ;	then $(EBIND) $@ ; fi

clean:
	rm -f *~ core *.map

zap:	clean
	rm -f *.o $(EXECS) .depend


# ------------------------------------------------------------------------------
# Make the dependencies

.PHONY: depend dep
depend dep:	$(OBJS:.o=.c)
	@echo "Creating dependency information"
	$(CC) -I$(COMMON) -MM $^ > .depend


