include options.mk

OBJDIR := objdir
OBJS := $(addprefix $(OBJDIR)/, ${MPIMOD}.o ${FFTMOD}.o ${GUIMOD}.o ${RAINMOD}.o ${VEGMOD}.o ${PLAMOD}.o resmod.o plasim.o plasimmod.o calmod.o gaussmod.o legmod.o outmod.o miscmod.o fluxmod.o radmod.o surfmod.o ${LANDMOD}.o seamod.o icemod.o oceanmod.o restartmod.o tracermod.o tpcore.o trc_routines.o ${PUMAX}.o ${OCEAN}.o ${OCEANCOUP}.o)

plasim.x:	$(OBJS)
	$(MOST_F90) -o plasim.x $(MOST_F90_OPTS) $(OBJS) ${GUILIB}

$(OBJDIR)/%.o : %.c
	$(MOST_CC) -c $(MOST_CC_OPTS) -o $@  $<

$(OBJDIR)/%.o : %.f90
	$(MOST_F90) -c $(MOST_F90_OPTS) $(MOST_PREC) -o $@  $<

$(OBJDIR)/%.o : %.f
	$(MOST_F90) -c $(MOST_F90_OPTS) -o $@ $<

$(OBJS): | $(OBJDIR)

$(OBJDIR):
	mkdir $(OBJDIR)

$(OBJDIR)/plasimmod.o:	$(OBJDIR)/resmod.o
$(OBJDIR)/plasimmod.o:	$(OBJDIR)/resmod.o
$(OBJDIR)/plasim.o:	$(OBJDIR)/plasimmod.o
$(OBJDIR)/${MPIMOD}.o:	$(OBJDIR)/plasimmod.o
$(OBJDIR)/${GUIMOD}.o:	$(OBJDIR)/plasimmod.o $(OBJDIR)/radmod.o $(OBJDIR)/${OCEANCOUP}.o
$(OBJDIR)/${RAINMOD}.o:	$(OBJDIR)/plasimmod.o
$(OBJDIR)/${VEGMOD}.o:	$(OBJDIR)/${LANDMOD}.o
$(OBJDIR)/${LANDMOD}.o:	$(OBJDIR)/plasimmod.o
$(OBJDIR)/${PLAMOD}.o:	$(OBJDIR)/radmod.o
$(OBJDIR)/calmod.o:	$(OBJDIR)/plasimmod.o
$(OBJDIR)/legmod.o:	$(OBJDIR)/plasimmod.o
$(OBJDIR)/outmod.o:	$(OBJDIR)/plasimmod.o
$(OBJDIR)/miscmod.o:	$(OBJDIR)/plasimmod.o
$(OBJDIR)/fluxmod.o:	$(OBJDIR)/plasimmod.o
$(OBJDIR)/radmod.o:	$(OBJDIR)/plasimmod.o
$(OBJDIR)/surfmod.o:	$(OBJDIR)/plasimmod.o
$(OBJDIR)/seamod.o:	$(OBJDIR)/plasimmod.o
$(OBJDIR)/icemod.o:	$(OBJDIR)/plasimmod.o
$(OBJDIR)/oceanmod.o:	$(OBJDIR)/plasimmod.o
$(OBJDIR)/tracermod.o:	$(OBJDIR)/plasimmod.o
$(OBJDIR)/${OCEANCOUP}.o:	$(OBJDIR)/plasimmod.o $(OBJDIR)/oceanmod.o $(OBJDIR)/icemod.o $(OBJDIR)/seamod.o
$(OBJDIR)/${OCEAN}.o:	$(OBJDIR)/${OCEANCOUP}.o

clean:
	rm -f $(OBJDIR)/*.o $(OBJDIR)/*.mod plasim.x
