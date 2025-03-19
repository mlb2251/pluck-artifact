Thank you for taking the time to evaluate this artifact. This artifact is for reproducing the results of the paper "Stochastic Lazy Knowledge Compilation for Inference in Discrete Probabilistic Programs" (PLDI 2025 Submission #545).

# Kicking the tires

## Getting the artifact

### From GitHub

```
git clone --recursive https://github.com/mlb2251/pluck-artifact.git
```

### From Zenodo

Download and unzip `pluck-artifact.zip` to make a new folder `pluck-artifact`. While the bulk of the will remain fixed, we recommend updating to any recent tweaks/improvements in the repo, including to the ReadMe:

```
cd pluck-artifact
git pull
git submodule update --init --recursive
```

## Docker setup

The artifact is set up to run in Docker - you can pull the docker container like so:

```
docker pull mlbowers/pluck-artifact:latest
```


From the root of the repo, launch the docker container with:
```
make docker-start
```
or by running:
```
docker run -it -m 60g -p 8000:8000 -v $(pwd):/pluck-artifact mlbowers/pluck-artifact:latest
```
The flag `-p 8000:8000` is only relevant to Figure 5, as the graphs there are generated as HTML/JS pages which need to be served to `localhost:8000` on the built-in python3 HTTP server. The 60GB limit is unnecessary, though we did notice some baselines we compare to within the docker container can reach up to 40GB (despite taking less on our machine outside of the container). However these high-memory baselines can be avoided as needed.

**All commands after this point should be run within Docker unless otherwise specified**

## Compilation

Run the following command from the root of the repo to make sure the Rust binaries are compiled, and that the Julia libraries are instantiated.
```
make setup
```

## Check that PluckArtifact.jl precompiles successfully
From the root of the repo, run:
```
cd PluckArtifact.jl
julia --project
```
This should drop you into a julia REPL where you can run:
```
julia> using PluckArtifact
```
This should load without error.

## Checking that PluckArtifact-synthesis precompiles successfully
From the root of the repo, run:
```
cd PluckArtifact-synthesis
julia --project
```
This should drop you into a julia REPL where you can run:
```
julia> using PluckArtifact
```
This should load without error.


## Basic test of Pluck and baselines
As a quick test that likelihood evaluation works for us and the baselines, we'll run one of the simpler baselines:

```
cd PluckArtifact.jl
make figure-4-diamond
```

This should run within a few minutes. Check that it produces a graph at `pluck-artifact/PluckArtifact.jl/out/plots/diamond.png` (which should look similar to the first graph in Figure 4 of the paper).

Finally, make sure that you can run

```
cd PluckArtifact-synthesis
python3 -m http.server 8000
```
and navigating to http://localhost:8000/html/fuzzing.html?path=data/figure5/new_nov14.json shows a page including Figure 5 (left).

This can be run either within or outside of the Docker container, since the Docker container is mounted to the local directory.


# Artifact Evaluation

We recommend running
```
git pull
git submodule update --init --recursive
```
To get the latest version of the repo and ReadMe for evaluation.

## Table 1

This part of the artifact is evaluated in `pluck-artifact/PluckArtifact.jl`. From the root of the repository, run:

```
cd PluckArtifact.jl
make table-1
```

The results table will print out, which can be compared to Table 1.

Differences from submission: we expect some differences from the original submission as during the review process we normalized for one aspect of our comparison to Dice.jl (related to variable ordering). This results in some benchmarks becoming stronger for us (e.g. `insurance`) and others becoming weaker for us (e.g. `alarm`).

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

To view the generated plots, launch an HTTP server with python (either within Docker or outside of Docker – since the container is mounted in the local directory either will work):

```
cd PluckArtifact-synthesis
python3 -m http.server 8000
```

Then view the result at: http://localhost:8000/html/fuzzing.html?path=data_to_plot/figure5-left/fuzzing_result.json


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
And finally a subcommand to create the plot (which is already run by `make figure-5-right`):
```
make figure-5-right-show
```

To view the generated plots, launch an HTTP server with python (either within Docker or outside of Docker – since the container is mounted in the local directory either will work):

```
cd PluckArtifact-synthesis
python3 -m http.server 8000
```

Then view the result at: http://localhost:8000/html/synthesis.html?path=data_to_plot/figure5-right/synthesis_result.json

## Running on your own inputs


We have an additional guide for running Pluck on your own inputs. See `PluckArtifact.jl/Pluck.jl/USAGE.md` for a guide.
