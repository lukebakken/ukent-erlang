-module(foo).
-export([bar/0, bar/1]).

bar() ->
    timer:sleep(500),
    io:format("bar started~n"),
    io:format("bar working~n"),
    io:format("bar finished~n").

bar(Pid) when is_pid(Pid) ->
    Pid ! "bar started~n",
    Pid ! "bar working~n",
    Pid ! "bar finished~n".
