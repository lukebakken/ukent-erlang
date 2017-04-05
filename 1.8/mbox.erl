-module(mbox).
-export([main/1,
         simple_receiver/0]).

main([String]) ->
    try
        N = list_to_atom(String),
        io:format("~p ~p pid: ~p~n", [?MODULE, N, self()]),
        run_example(N)
    catch
        _:_ ->
            usage()
    end;
main(_) ->
    usage().

usage() ->
    io:format("usage: mbox exN~n"),
    halt(1).

run_example(ex1) ->
    Pid = spawn(?MODULE, simple_receiver, []),
    Pid ! "foo",
    Pid ! "bar",
    Pid ! "baz",
    sleep(1000),
    halt(0).

sleep(MSec) ->
    io:format("~p sleeping ~wms~n", [self(), MSec]),
    timer:sleep(MSec).

simple_receiver() ->
    receive
        Msg ->
            io:format("simple_receiver msg: ~s~n", [Msg])
    end,
    simple_receiver().
