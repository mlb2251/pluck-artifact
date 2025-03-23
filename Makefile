# Docker configuration
DOCKER_IMAGE_NAME = mlbowers/pluck-artifact
DOCKER_TAG = latest
DOCKER_PORT = 8000
DOCKER_MEMORY = 60g

# Repository URLs
PLUCK_REPO = https://github.com/mlb2251/PluckArtifact.jl
SYNTHESIS_REPO = https://github.com/mlb2251/PluckArtifactDependency.jl
RSDD_REPO = https://github.com/alex-lew/rsdd.git

# Branch names
PLUCK_MAIN_BRANCH = main
PLUCK_SYNTHESIS_BRANCH = synthesis
PLUCK_MAIN_MADDY_BRANCH = main-maddy
PLUCK_DOTS_BRANCH = dots
RSDD_MAIN_BRANCH = main

# START THE DOCKER CONTAINER

docker-start:
	docker run -it -m $(DOCKER_MEMORY) -p $(DOCKER_PORT):$(DOCKER_PORT) -v $(PWD):/pluck-artifact $(DOCKER_IMAGE_NAME):$(DOCKER_TAG)

# BASICS

setup: bindings julia-instantiate

bindings:
	cd PluckArtifact.jl && make bindings
	cd PluckArtifact-synthesis && make bindings

julia-instantiate:
	cd PluckArtifact.jl && make julia-instantiate
	cd PluckArtifact-synthesis && make julia-instantiate

# DOCKER BUILD

docker-build:
	docker build -t pluck-artifact:$(DOCKER_TAG) .

docker-build-verbose:
	docker build -t pluck-artifact:$(DOCKER_TAG) . --progress=plain

# SUBMODULES (for development, not for artifact usage)

submodule-status:
	git submodule status
	git submodule foreach --recursive 'git submodule status'

submodule-clone:
	git clone $(PLUCK_REPO) -b $(PLUCK_MAIN_BRANCH)
	git clone $(PLUCK_REPO) -b $(PLUCK_SYNTHESIS_BRANCH) PluckArtifact-synthesis
	git clone $(SYNTHESIS_REPO) -b $(PLUCK_MAIN_MADDY_BRANCH) PluckArtifact.jl/Pluck.jl
	git clone $(SYNTHESIS_REPO) -b $(PLUCK_DOTS_BRANCH) PluckArtifact-synthesis/PluckSynthesis.jl
	git clone $(RSDD_REPO) -b $(RSDD_MAIN_BRANCH) PluckArtifact.jl/Pluck.jl/src/RSDD/rsdd
	git clone $(RSDD_REPO) -b $(RSDD_MAIN_BRANCH) PluckArtifact-synthesis/PluckSynthesis.jl/src/RSDD/rsdd

submodule-checkout:
	cd PluckArtifact.jl && git checkout $(PLUCK_MAIN_BRANCH) && git pull
	cd PluckArtifact-synthesis && git checkout $(PLUCK_SYNTHESIS_BRANCH) && git pull
	cd PluckArtifact.jl/Pluck.jl && git checkout $(PLUCK_MAIN_MADDY_BRANCH) && git pull
	cd PluckArtifact-synthesis/PluckSynthesis.jl && git checkout $(PLUCK_DOTS_BRANCH) && git pull
	cd PluckArtifact.jl/Pluck.jl/src/RSDD/rsdd && git checkout $(RSDD_MAIN_BRANCH) && git pull
	cd PluckArtifact-synthesis/PluckSynthesis.jl/src/RSDD/rsdd && git checkout $(RSDD_MAIN_BRANCH) && git pull

