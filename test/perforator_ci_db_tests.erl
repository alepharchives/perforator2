%% @author Martynas <martynasp@gmail.com>

-module(perforator_ci_db_tests).

-include_lib("eunit/include/eunit.hrl").

-include("perforator_ci.hrl").

-compile(export_all).

%% ============================================================================

db_test_() ->
    {foreach, 
        fun () ->
            perforator_ci:init(),
            perforator_ci:start()
        end,
        fun (_) -> perforator_ci:stop() end,
        [
            {"Create project", fun test_create_project/0},
            {"Create build", fun test_create_build/0}
        ]
    }.

%% ============================================================================

test_create_project() ->
    ?assertEqual(
        1,
        perforator_ci_db:create_project(<<"omg">>, <<"repo">>, on_demand)
    ),
    ?assertEqual(
        1,
        perforator_ci_db:create_project(<<"omg">>, <<"repo">>, on_demand)
    ),
    ?assertEqual(
        2,
        perforator_ci_db:create_project(<<"gmo">>, <<"repo">>, on_demand)
    ),
    ?assertMatch(
        #project{id=1, name= <<"omg">>, repo= <<"repo">>,
            polling=on_demand},
        perforator_ci_db:get_project(1)
    ),
    ?assertMatch(
        [#project{id=1}, #project{id=2}],
        perforator_ci_db:get_projects()).

test_create_build() ->
    ?assertEqual(
        {1, 1},
        perforator_ci_db:create_build(42, 123, <<"cid0">>, [])),
    ?assertEqual(
        {1, 1},
        perforator_ci_db:create_build(42, 123, <<"cid0">>, [])),
    ?assertEqual(
        {2, 2},
        perforator_ci_db:create_build(42, 123, <<"cid1">>, [])),
    ?assertEqual(
        {3, 1},
        perforator_ci_db:create_build(666, 123, <<"cid2">>, [])),
    ?assertEqual(
        {4, 2},
        perforator_ci_db:create_build(666, 123, <<"cid3">>, [])),
    ?assertMatch(
        #project_build{commit_id= <<"cid1">>},
        perforator_ci_db:get_last_build(42)).
