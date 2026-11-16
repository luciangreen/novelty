# novelty

how new is an idea? An idea is a set of features; its distance to another is the Jaccard distance (features in one but not both, over features in either), kept as an exact fraction d(Num, Den). Novelty is the distance to the nearest idea already in the corpus, and most_novel/3 picks the candidate furthest from everything seen.

## Use

```prolog
?- use_module(prolog/novelty).
?- distance([logic, music], [logic, art], D).            % D = d(2, 3)
?- novelty([logic, music], [[logic, art], [music]], N).  % N = d(1, 2)
?- most_novel([[logic], [dance, time]], [[logic, art]], I).   % I = [dance, time]
```

## Proofs

`proofs/theorems.pl` proves 4 theorems by exhaustion: each one is checked for every case in a finite domain that covers every branch of the definitions. every subset of the features a, b, c (8 sets), and corpora of 0..2 of them.

1. Distance is between 0 and 1, zero exactly for equal sets, and symmetric.
2. The triangle inequality holds.
3. Novelty is zero exactly when the idea is already in the corpus, and growing the corpus never raises it.
4. The most novel candidate is at least as novel as every other.

```sh
swipl -g main -t halt proofs/theorems.pl
```

## 200 inputs and outputs

`io/ios.txt` lists 200 inputs and outputs from real runs, and `io/ios.pl` has the same as Prolog facts. The inputs come from a fixed seed (`io/cases.pl`). `swipl -g check -t halt io/run.pl` runs them again. It fails if any output changes, or if a predicate doesn't confirm its own recorded output, which checks steadfastness. GitHub Actions runs the proofs and the examples on every push, and records the examples on the first push.

Licence: BSD-3-Clause.
