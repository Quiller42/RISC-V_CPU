COMPILER = iverilog
FLAGS = -g2012
OUTPUT = cpu_sim.vvp
WAVE_FILE = cpu_waves.vcd

SOURCES = $(wildcard *.sv)

all: compile run

compile:
	$(COMPILER) $(FLAGS) -o $(OUTPUT) $(SOURCES)

run:
	# Running simulation cleanly; testbench handles VCD generation
	vvp $(OUTPUT)

wave:
	# Opens the generated wave traces in GTKWave
	gtkwave $(WAVE_FILE) &

clean:
	rm -f $(OUTPUT) $(WAVE_FILE) dump.vcd