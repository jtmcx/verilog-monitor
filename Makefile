PROJ     = monitor
SOURCES  = toplevel.v display.v pll.v videoram.v
PCF      = monitor.pcf

IVERILOG = iverilog

# Target device information.
TARG_DEVICE  = hx1k
TARG_SIZE    = 1k
TARG_PACKAGE = tq144

# Output clock for generated pll.v.
CLOCK_MHZ = 16.257

all: $(PROJ).bin $(PROJ).rpt

$(PROJ).blif: $(SOURCES)
	yosys -q -p 'synth_ice40 -top toplevel -blif $@' $(SOURCES)

$(PROJ).asc: $(PCF) $(PROJ).blif
	arachne-pnr -q -o $@ -p $(PCF) $(PROJ).blif \
		-d $(TARG_SIZE) -P $(TARG_PACKAGE)

$(PROJ).bin: $(PROJ).asc
	icepack $(PROJ).asc $@

$(PROJ).rpt: $(PROJ).asc
	icetime -d $(TARG_DEVICE) -mtr $@ $(PROJ).asc

prog: $(PROJ).bin
	iceprog $(PROJ).bin

pll.v: 
	icepll -q -o $(CLOCK_MHZ) -m -f $@

display.vcd : display.t
	vvp display.t

display.t : display.t.v display.v
	$(IVERILOG) -o $@ -Wall display.t.v display.v

farbfeld.vcd : farbfeld.t
	vvp farbfeld.t

farbfeld.t : farbfeld.t.v farbfeld.v
	$(IVERILOG) -o $@ -Wall farbfeld.t.v farbfeld.v

clean:
	rm -f *.t *.vcd
	rm -f $(PROJ).blif $(PROJ).asc $(PROJ).bin $(PROJ).rpt pll.v

