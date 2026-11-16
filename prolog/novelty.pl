% novelty: how new is an idea? An idea is a set of features; its distance to another is the
% Jaccard distance (features in one but not both, over features in either), kept as an exact
% fraction d(Num, Den). Novelty is the distance to the nearest idea already in the corpus, and
% most_novel/3 picks the candidate furthest from everything seen.
%?- distance([logic, music], [logic, art], D).            % D = d(2, 3)
%?- novelty([logic, music], [[logic, art], [music]], N).  % N = d(1, 2)
%?- most_novel([[logic], [dance, time]], [[logic, art]], I).   % I = [dance, time]
:- module(novelty, [distance/3, novelty/3, most_novel/3, le/2]).
:- use_module(library(lists)).
:- use_module(library(apply)).

distance(A0, B0, d(N, D)) :- sort(A0, A), sort(B0, B), union(A, B, U), intersection(A, B, I), length(U, LU), length(I, LI), ( LU =:= 0 -> N = 0, D = 1 ; N is LU - LI, D = LU ).

% le(+X, +Y): fraction X is at most fraction Y.
le(d(N1, D1), d(N2, D2)) :- N1 * D2 =< N2 * D1.

% novelty(+Idea, +Corpus, -Distance): distance to the nearest corpus idea (1 for an empty corpus).
novelty(_, [], d(1, 1)) :- !.
novelty(I, [C|Cs], N) :- distance(I, C, D0), foldl([X, M0, M]>>( distance(I, X, Dx), ( le(Dx, M0) -> M = Dx ; M = M0 ) ), Cs, D0, N).

most_novel([I|Is], Corpus, Best) :- novelty(I, Corpus, N0), foldl([X, B0-M0, B-M]>>( novelty(X, Corpus, Nx), ( le(Nx, M0) -> B-M = B0-M0 ; B-M = X-Nx ) ), Is, I-N0, Best-_).
