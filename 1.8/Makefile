.PHONY: run clean

run: mbox
	@escript mbox.beam ex1

clean:
	@rm -f mbox.beam

mbox: mbox.beam

%.beam: %.erl
	erlc -v -Wall $<
