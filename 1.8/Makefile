.PHONY: run ex1 ex2 ex3 clean

run: ex1 ex2 ex3

ex1: mbox.beam
	@echo ex1
	@escript mbox.beam ex1

ex2: mbox.beam
	@echo ex2_1
	@escript mbox.beam ex2_1
	@echo ex2_2
	@escript mbox.beam ex2_2

ex3: mbox.beam
	@echo ex3_1
	@escript mbox.beam ex3_1
	@echo ex3_2
	@escript mbox.beam ex3_2

clean:
	@rm -f mbox.beam

mbox: mbox.beam

%.beam: %.erl
	erlc -v -Wall $<
