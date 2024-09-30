/** 
======= Hamiltonian cycles ======= 
            2023/2024

This module processes graph from an input and prints out all unique
Hamiltonian cycles of this graph. If no cycles are detected, 
nothing is printed.

@author Sabina Gulcikova, xgulci00
*/

:- consult('input2.pl').
:- dynamic edge/2, vertex/1.

% -------- INPUT PROCESSING
% -------- storing input in dynamic predicates
read_input(InputData) :-
    read_lines(LL),
    split_lines(LL, InputData).

process_input(InputLines) :-
    split_lines(InputLines, SplitLines),
    process_lines(SplitLines).

process_lines([]).
process_lines([[Node1, Node2] | Rest]) :-
    atom_chars(Node1Stripped, Node1),
    atom_chars(Node2Stripped, Node2),

    (not(edge(Node1Stripped, Node2Stripped)) -> 
        assertz(edge(Node1Stripped, Node2Stripped)); 
            edge(Node1Stripped, Node2Stripped)),

    % also save symmetric relation because we work with undirected graphs
    (not(edge(Node2Stripped, Node1Stripped)) -> 
        assertz(edge(Node2Stripped, Node1Stripped)); 
            edge(Node2Stripped, Node1Stripped)),

    (not(vertex(Node1Stripped)) -> assertz(vertex(Node1Stripped)); vertex(Node1Stripped)),
    (not(vertex(Node2Stripped)) -> assertz(vertex(Node2Stripped)); vertex(Node2Stripped)),

    process_lines(Rest).

% -------- HELPER predicates
% checks if all elements of list are unique
all_distinct([]).
all_distinct([H|T]) :-
    \+ member(H, T),
    all_distinct(T).

% checks that list doesnt start with StartVertex element
not_starts_with_vertex(StartVertex, Cycle) :-
    Cycle = [FirstVertex|_],
    FirstVertex \= StartVertex.

% duplicates first element and appends it to the end of the list 
% - "closes" the cycle
append_first_to_end([], []).
append_first_to_end([Cycle|Rest], [FullCycle|FullCycles]) :-
    Cycle = [FirstVertex|_],
    (var(FirstVertex) -> vertex(FirstVertex) ; true),
    append(Cycle, [FirstVertex], FullCycle),
    append_first_to_end(Rest, FullCycles).

% check if the current vertex is connected to the next vertex
% for base case: check if the last vertex is connected to the starting vertex
are_neighboring([LastVertex, StartVertex], [StartVertex]) :-
    edge(LastVertex, StartVertex).
are_neighboring([CurrVertex, NextVertex|Rest], [CurrVertex|Cycle]) :-
    edge(CurrVertex, NextVertex),
    are_neighboring([NextVertex|Rest], Cycle).

% obtain edges by merging consecutive pairs of vertices
% additionally, sort vertices within edge
vertices_to_edges([X,Y], [[X,Y]]):- X @< Y.
vertices_to_edges([X,Y], [[Y,X]]):- Y @< X.
vertices_to_edges([X,Y|Rest], [Edge|Edges]) :-
    (X @< Y -> Edge = [X,Y] ; Edge = [Y,X]),
    vertices_to_edges([Y|Rest], Edges).

% convert list of vertices forming cycle into list of edges forming cycle
paths_to_edges([], []).
paths_to_edges([Cycle|RestCycles], [CycleEdges|RestEdges]) :-
    vertices_to_edges(Cycle, CycleEdges),
    paths_to_edges(RestCycles, RestEdges).

% sort edges within cycle
sort_edges([], []).
sort_edges(Edges, SortedEdges) :-
    sort(Edges, SortedEdges).

sort_all_edges(Edges, SortedEdges) :-
    maplist(sort_edges, Edges, SortedEdges).

% remove duplicate cycles
remove_duplicates([], []).
remove_duplicates([L|Ls], Unique) :-
    ( memberchk(L, Ls) ->
        remove_duplicates(Ls, Unique)
    ;   Unique = [L|Rest],
        remove_duplicates(Ls, Rest)
    ).

% prints cycle in predefined format
print_cycle([]).
print_cycle([[X,Y]|Rest]) :-
    format('~w-~w ', [X, Y]),
    print_cycle(Rest).
    
print_cycles([]).
print_cycles([Cycle|Rest]) :-
    print_cycle(Cycle),
    nl,
    print_cycles(Rest).

% -------- ------------------
hamiltonian_cycles(Cycle) :-
    findall(Vertex, vertex(Vertex), Vertices),
    permutation(Vertices, Perm),
    member(StartVertex, Perm),
    are_neighboring([StartVertex|Perm], Cycle),
    all_distinct(Cycle).

% filter duplicate cycles and transform into desired format for printing
filter_and_transform(Cycles, Final) :-
    findall(Vertex, vertex(Vertex), VertexList),
    [StartVertex|_] = VertexList, 
    exclude(not_starts_with_vertex(StartVertex), Cycles, FilteredCycles),
    append_first_to_end(FilteredCycles, FullCycles),
    paths_to_edges(FullCycles, Edges),
    sort_all_edges(Edges, SortedEdges),
    remove_duplicates(SortedEdges, Final).

main :-
    prompt(_, ''),
    read_lines(LL),
    split_lines(LL,S),
    process_lines(S),

    findall(Cycle, hamiltonian_cycles(Cycle), Cycles),
    
    filter_and_transform(Cycles, Filtered),

    print_cycles(Filtered),

    halt.