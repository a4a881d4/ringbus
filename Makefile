
GHDLFLAGS= -fexplicit --ieee=synopsys -Pwork --workdir=work
GHDLRUNFLAGS= --stop-time=2000ns --wave=work/rbus.ghw

# Default target : elaborate
all : elab

# Elaborate target.  Almost useless
elab : force
	$(GHDL) -c $(GHDLFLAGS) -e rbus2_tb

# Run target
run : force
	$(GHDL) -r rbus2_tb $(GHDLRUNFLAGS)

# Targets to analyze libraries
init: force

force:
	$(GHDL) -a $(GHDLFLAGS) --work=simio simio/simio.vhd
	$(GHDL) -a $(GHDLFLAGS) --work=simio simio/dspemulator.vhd
	$(GHDL) -a $(GHDLFLAGS) common/*.vhd
	$(GHDL) -a $(GHDLFLAGS) V3.0/ringbus/rb_config.vhd
	$(GHDL) -a $(GHDLFLAGS) V3.0/ringbus/dma_config.vhd
	$(GHDL) -a $(GHDLFLAGS) V3.0/ringbus/contr_config.vhd
	$(GHDL) -a $(GHDLFLAGS) V3.0/ringbus/EPMemOut.vhd
	$(GHDL) -a $(GHDLFLAGS) V3.0/ringbus/EPMemIn.vhd
	$(GHDL) -a $(GHDLFLAGS) V3.0/ringbus/rbus.vhd
	$(GHDL) -a $(GHDLFLAGS) V3.0/ringbus/DMANP.vhd
	$(GHDL) -a $(GHDLFLAGS) V3.0/ringbus/buscontroller.vhd
	$(GHDL) -a $(GHDLFLAGS) V3.0/ringbus/busEP.vhd
	$(GHDL) -a $(GHDLFLAGS) V3.0/ringbus/AAI.vhd
	$(GHDL) -a $(GHDLFLAGS) V3.0/examples/*.vhd
	$(GHDL) -a $(GHDLFLAGS) V3.0/examples/rbus2.vhd
	$(GHDL) -a $(GHDLFLAGS) V3.0/testbench/rbus2_tb.vhd

clean:
	rm work/*
	
