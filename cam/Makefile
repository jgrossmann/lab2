DUV=cam
MOD1=cam_mux
MOD2=cam_decoder
MOD3=cam_pencoder
MOD4=eff
TEST=cam_test
BENCH=testbench.exe

all:
	make clean
	make test
	#make view

test:
	vcs -full64 -PP -sverilog +define+SV +define+VPD $(MOD1).sv $(MOD2).sv $(MOD3).sv $(MOD4).sv $(DUV).sv $(TEST).sv -o $(BENCH)
	#vcs -full64 -PP -sverilog +define+SV +define+VPD $(DUV).sv $(TEST).sv -o $(BENCH)
	./$(BENCH)

#view:
	#dve -full64 -vpd vcdplus.vpd &

leda:
	leda -full64 -sverilog -top $(DUV) $(DUV).sv

clean:
	rm -rf csrc *.exe.daidir *.exe *.log *.inf .leda_work *.key *.vpd *.vcd DVEfiles

