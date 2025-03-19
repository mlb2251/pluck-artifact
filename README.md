This is the official artifact for reproducing the results of the paper "Stochastic Lazy Knowledge Compilation for Inference in Discrete Probabilistic Programs" (PLDI 2025 Submission #545).

# Kick the tires

## Table 1

This part of the artifact is evaluated in `pluck-artifact/PluckArtifact.jl`. From the root of the repository, run:

```
cd PluckArtifact.jl
make table-1
```

The table will print out. Some entries will be marked as "skipped". These were specifically not included in this run because they take particularly long to run. Others are marked as "timeout" because they are expected to result in a timeout (based on prior runs). You can manually run "skipped" and "timeout" entries of the table with:

```
make table-1-cell <strategy> <benchmark>
```
where strategy is one of: `ours`, `dice`, `lazy_enum`, or `eager_enum` and benchmark is the name of the row in the printed table.

for example:
```
make table-1-cell eager_enum sorted_list
```

Differences from submission: we expect some differences from the original submission as during the review process we normalized one aspect of our comparison to Dice.jl (related to variable ordering). This results in some benchmarks improving for us (e.g. `insurance`) and others becoming weaker for us (e.g. `alarm`).

However the claim made by the table remains the same as in the original submission. In particular, in the Bayesian Networks and Network Reachability subsections of the table we broadly expect Dice.jl to outperform us, though we occasionally do better, as discussed in submission lines 748-754:

> The benchmarks from Dice’s repository are not defined over compound data and do not exercise many of lazy knowledge compilation’s strengths. In general, on such tasks we expect lazy knowledge compilation to perform slightly worse than eager knowledge compilation, as our algorithm adds several sources of constant-factor overhead...

Whereas on the more complex Sequence Models benchmarks (PCFG, String Editing, and Sorted List Generation) we expect to outperform Dice – as queries involving compound data are our strength.

Note we also include a second table "Added benchmarks" that will be added during the camera ready, as recommended by reviewers.

## Figure 4

This part of the artifact is evaluated in `pluck-artifact/PluckArtifact.jl` (same as Table 1).

```
cd PluckArtifact.jl
make figure-4
```

This will in turn run a separate `make` command for each of the six plots. If you need to rerun any specific command when debugging here they are:

```
make figure-4-diamond
make figure-4-ladder
make figure-4-hmm
make figure-4-sorted
make figure-4-pcfg
make figure-4-fuel
```

Resulting files will be written to `pluck-artifact/PluckArtifact.jl/out/plots/` where you can view them to verify that they align with the submission plots.

## Figure 5 (left)

This part of the artifact is evaluated in `pluck-artifact/PluckArtifact-synthesis`. From the root of the repository, run:

```
cd PluckArtifact-synthesis
make figure-5-left
```
This invokes 4 subcommands, which can optionally be run individually if you encounter issues. There's one subcommand for each of the 4 lines of the plot:
```
make figure-5-left-dice
make figure-5-left-bdd
make figure-5-left-lazy
make figure-5-left-smc
```
And finally a subcommand to create the plot:
```
make figure-5-left-show
```

## Figure 5 (center, right)

This part of the artifact is evaluated in `pluck-artifact/PluckArtifact-synthesis`. From the root of the repository, run:

```
cd PluckArtifact-synthesis
make figure-5-right
```
Note that this creates both the center and right plots in a single command (since they're different ways of displaying the results of the same runs). It invokes 4 subcommands, which can optionally be run individually if you encounter issues. There's one subcommand for each of the 4 lines of the two plots:
```
make figure-5-right-dice
make figure-5-right-bdd
make figure-5-right-lazy
make figure-5-right-smc
```
And finally a subcommand to create the plot:
```
make figure-5-right-show
```




## Usage guide & Running on your own inputs

See USAGE.md
