:- module(cases, [title/1, case/3]).
:- use_module('../prolog/novelty').
:- use_module(engine).
title('novelty').
idea_g(I) :- findall(F, ( member(F, [logic, music, art, time, mind, dance, code]), rnd_chance(35) ), I).
corpus_g(C) :- rnd_int(0, 4, K), length(C, K), maplist(idea_g, C).
case(distance, [A, B], distance) :- idea_g(A), idea_g(B).
case(novelty, [I, C], novelty) :- idea_g(I), corpus_g(C).
case(most_novel, [Is, C], most_novel) :- rnd_int(1, 4, K), length(Is, K), maplist(idea_g, Is), corpus_g(C).
