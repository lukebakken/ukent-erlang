-module(mbox).
-export([main/1,
         receiver_ex1/0,
         receiver_ex2_1/0,
         receiver_ex2_2/0,
         receiver_ex3_1/0,
         receiver_ex3_2/0]).

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

sleep(MSec) ->
    io:format("~p sleeping ~wms~n", [self(), MSec]),
    timer:sleep(MSec).

sleep_exit(MSec) ->
    sleep(MSec),
    halt(0).

sleep_exit() ->
    sleep_exit(1000).

send_msgs(Pid, Ex) ->
    Pid ! io_lib:format("~s foo", [Ex]),
    Pid ! io_lib:format("~s bar", [Ex]),
    Pid ! io_lib:format("~s baz", [Ex]),
    Pid ! io_lib:format("~s bat", [Ex]).

run_example(Ex=ex1) ->
    Pid = spawn(?MODULE, receiver_ex1, []),
    send_msgs(Pid, Ex),
    sleep_exit();
run_example(Ex=ex2_1) ->
    Pid = spawn(?MODULE, receiver_ex2_1, []),
    send_msgs(Pid, Ex),
    Pid ! stop,
    sleep_exit();
run_example(Ex=ex2_2) ->
    Pid = spawn(?MODULE, receiver_ex2_2, []),
    send_msgs(Pid, Ex),
    Pid ! stop,
    sleep_exit();
run_example(ex3_1) ->
    Pid = spawn(?MODULE, receiver_ex3_1, []),
    Pid ! {second, "ex3_1 second"},
    Pid ! {first, "ex3_1 first"},
    Pid ! stop,
    sleep_exit();
run_example(ex3_2) ->
    Pid = spawn(?MODULE, receiver_ex3_2, []),
    Pid ! {second, "ex3_2 second"},
    sleep(250),
    Pid ! {first, "ex3_2 first"},
    sleep(250),
    Pid ! stop,
    sleep_exit().

receiver_ex1() ->
    receive
        Msg ->
            io:format("receiver_ex1 msg: ~s~n", [Msg])
    end,
    receiver_ex1().

receiver_ex2_1() ->
    receive
        stop ->
            io:format("receiver_ex2_1 STOP~n");
        Msg ->
            io:format("receiver_ex2_1 msg: ~s~n", [Msg]),
            receiver_ex2_1()
    end.

receiver_ex2_2() ->
    receive
        Msg -> receiver_ex2_2_handle(Msg)
    end.

receiver_ex2_2_handle(stop) ->
    io:format("receiver_ex2_2 STOP~n");
receiver_ex2_2_handle(Msg) ->
    io:format("receiver_ex2_2 msg: ~s~n", [Msg]),
    receiver_ex2_2().

receiver_ex3_1() ->
    receive
        {first, Msg1} ->
            io:format("receiver_ex3_1 first ~s~n", [Msg1]),
            receive
                {second, Msg2} ->
                    io:format("receiver_ex3_1 second ~s~n", [Msg2]);
                stop ->
                    io:format("receiver_ex3_1 inner STOP~n")
            end;
        stop ->
            io:format("receiver_ex3_1 outer STOP~n")
    end,
    receiver_ex3_1().

receive_in_order([]) ->
    io:format("receiver_ex3_2 tag list empty!~n");
receive_in_order([stop|T]) ->
    receive
        stop ->
            io:format("receiver_ex3_2 STOP~n")
    end,
    receive_in_order(T);
receive_in_order([Tag|T]) ->
    receive
        {Tag, Msg} ->
            io:format("receiver_ex3_2: ~p~n", [Msg])
    end,
    receive_in_order(T).

receiver_ex3_2() ->
    Order = [first, second, stop],
    receive_in_order(Order).
