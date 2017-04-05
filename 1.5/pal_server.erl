-module(pal_server).

-export([server/0]).

server() ->
    Regex = get_regex(),
    server(Regex).

server(Regex) ->
    receive
        stop ->
            io:format("server stopping~n");
        {check, Pid, Str} ->
            Rslt = handle_palindrome_check(palindrome_check(Str, Regex), Str),
            Pid ! Rslt,
            server(Regex)
    end.

palindrome_check(Str, Regex) ->
    NStr = to_small(rem_punct(Str, Regex)),
    lists:reverse(NStr) == NStr.

handle_palindrome_check(true, Str) ->
    Msg = lists:flatten(io_lib:format("\"~s\" is a palindrome", [Str])),
    {result, Msg};
handle_palindrome_check(false, Str) ->
    Msg = lists:flatten(io_lib:format("\"~s\" is not a palindrome", [Str])),
    {result, Msg}.

rem_punct(Str, Regex) ->
    re:replace(Str, Regex, "", [global, {return, list}]).

to_small(Str) ->
	string:to_lower(Str).

get_regex() ->
    {ok, Regex} = re:compile("[[:punct:][:space:]]"),
    Regex.
