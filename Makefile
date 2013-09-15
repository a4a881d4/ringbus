
GHDLFLAGS= -fexplicit --ieee=synopsys -Pwork --workdir=work
GHDLRUNFLAGS= --stop-time=2000ns --wave=work/rbus.ghw

# Default target : elaborate
all : elab

# Elaborate target.  Almost useless
elab : force
	$(GHDL) -c $(GHDLFLAGS) -e speed

# Run target
run : force
	$(GHDL) -c $(GHDLFLAGS) -r speed $(GHDLRUNFLAGS)

# Targets to analyze libraries
init: force

force:
	$(GHDL) -i $(GHDLFLAGS) --work=simio simio/simio.vhd
	$(GHDL) -i $(GHDLFLAGS) --work=simio simio/*.vhd
	$(GHDL) -i $(GHDLFLAGS) common/*.vhd
	$(GHDL) -i $(GHDLFLAGS) V3.0/ringbus/rb_config.vhd
	$(GHDL) -i $(GHDLFLAGS) V3.0/ringbus/dma_config.vhd
	$(GHDL) -i $(GHDLFLAGS) V3.0/ringbus/contr_config.vhd
	$(GHDL) -i $(GHDLFLAGS) V3.0/ringbus/*.vhd
	$(GHDL) -i $(GHDLFLAGS) V3.0/examples/*.vhd
	$(GHDL) -i $(GHDLFLAGS) V3.0/testbench/*.vhd

clean:
	rm work/*
	