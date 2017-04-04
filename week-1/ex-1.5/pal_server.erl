-module(pal_server).

-export([server/1]).

server(Pid) ->
server(Pid, State) ->
    receive
        stop ->
            io:format("server stopping~n");
        {check, Str} ->
    end.

palindrome_check(Str) ->
    NStr = to_small(rem_punct(Str)),
    lists:reverse(Nstr) == NStr.

rem_punct(Str) ->
    re:replace(Str, Regex, "", [global]).

to_small(Str) ->
	string:to_lower(Str).

get_regex() ->
    {ok, Regex} = re:compile("[[:punct:]]"),
