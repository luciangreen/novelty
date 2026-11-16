% Theorems, proved by exhaustion. Run: swipl -g main -t halt proofs/theorems.pl
:- module(theorems, [main/0]).
:- use_module(prove).
:- discontiguous theorem/1.
:- use_module(library(lists)).
:- use_module(library(apply)).
main :- prove_all(theorems).
:- use_module('../prolog/novelty').

% Domain: every subset of the features a, b, c (8 sets), and corpora of 0..2 of them.
fset(S) :- sub([a, b, c], S).
sub([], []).
sub([X|Xs], [X|Ys]) :- sub(Xs, Ys).
sub([_|Xs], Ys) :- sub(Xs, Ys).
corpus(C) :- between(0, 2, K), length(C, K), maplist(fset, C).
plus_le(d(N1, D1), d(N2, D2), d(N3, D3)) :- N3 * D1 * D2 =< N1 * D2 * D3 + N2 * D1 * D3.

% 1. Distance is between 0 and 1, zero exactly for equal sets, and symmetric.
theorem(distance_metric_basics) :- forall(( fset(A), fset(B) ), ( distance(A, B, D), le(d(0, 1), D), le(D, d(1, 1)), distance(B, A, D2), le(D, D2), le(D2, D), iff(D = d(0, _), A == B) )).

% 2. The triangle inequality holds.
theorem(triangle_inequality) :- forall(( fset(A), fset(B), fset(C) ), ( distance(A, B, X), distance(B, C, Y), distance(A, C, Z), plus_le(X, Y, Z) )).

% 3. Novelty is zero exactly when the idea is already in the corpus, and growing the corpus never raises it.
theorem(novelty_zero_and_monotone) :- forall(( fset(I), corpus(C) ), ( novelty(I, C, N), ( C == [] -> true ; iff(N = d(0, _), memberchk(I, C)) ), forall(fset(X), ( novelty(I, [X|C], N2), le(N2, N) )) )).

% 4. The most novel candidate is at least as novel as every other.
theorem(most_novel_is_max) :- forall(( corpus(C), fset(A), fset(B), fset(D) ), ( most_novel([A, B, D], C, Best), novelty(Best, C, NB), forall(member(X, [A, B, D]), ( novelty(X, C, NX), le(NX, NB) )) )).
