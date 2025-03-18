docker-start:
	docker run -it -m 60g -p 8000:8000 -v $(PWD):/pluck-artifact pluck-artifact:latest

setup: bindings julia-instantiate

bindings:
	cd PluckArtifact.jl && make bindings
	cd PluckArtifact-synthesis && make bindings

julia-instantiate:
	cd PluckArtifact.jl && make julia-instantiate
	cd PluckArtifact-synthesis && make julia-instantiate

docker-build:
	docker build -t pluck-artifact:latest .

docker-build-verbose:
	docker build -t pluck-artifact:latest . --progress=plain

submodule-status:
	git submodule status
	git submodule foreach --recursive 'git submodule status'

# useful for having them not lose their branches
submodule-clone:
	git clone https://github.com/mlb2251/PluckArtifact.jl -b main
	git clone https://github.com/mlb2251/PluckArtifact.jl -b synthesis PluckArtifact-synthesis
	git clone https://github.com/alex-lew/coarse-to-fine-synthesis.git -b main-maddy PluckArtifact.jl/Pluck.jl
	git clone https://github.com/alex-lew/coarse-to-fine-synthesis.git -b dots PluckArtifact-synthesis/PluckSynthesis.jl
	git clone https://github.com/alex-lew/coarse-to-fine-synthesis.git -b dots PluckArtifact-synthesis/PluckSynthesis.jl
	git clone https://github.com/alex-lew/rsdd.git -b main PluckArtifact.jl/Pluck.jl/src/RSDD/rsdd
	git clone https://github.com/alex-lew/rsdd.git -b main PluckArtifact-synthesis/PluckSynthesis.jl/src/RSDD/rsdd

submodule-checkout:
	cd PluckArtifact.jl && git checkout main && git pull
	cd PluckArtifact-synthesis && git checkout synthesis && git pull
	cd PluckArtifact.jl/Pluck.jl && git checkout main-maddy && git pull
	cd PluckArtifact-synthesis/PluckSynthesis.jl && git checkout dots && git pull
	cd PluckArtifact.jl/Pluck.jl/src/RSDD/rsdd && git checkout main && git pull
	cd PluckArtifact-synthesis/PluckSynthesis.jl/src/RSDD/rsdd && git checkout main && git pull


