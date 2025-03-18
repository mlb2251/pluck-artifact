docker-start:
	docker run -it -m 60g -p 8000:8000 -v $(PWD):/pluck-artifact pluck-artifact:latest

bindings:
	cd Pluck.jl && make bindings
	cd PluckSynthesis.jl && make bindings

julia-instantiate:
	cd PluckArtifact.jl && make julia-instantiate
	cd PluckArtifact-synthesis && make julia-instantiate

docker-build:
	docker build -t pluck-artifact:latest .

submodule-status:
	git submodule status
	git submodule foreach --recursive 'git submodule status'


submodule-update:
	cd PluckArtifact.jl && git checkout main && git pull
	cd PluckArtifact-synthesis && git checkout synthesis && git pull
	cd PluckArtifact.jl/Pluck.jl && git checkout main-maddy && git pull
	cd PluckArtifact-synthesis/PluckSynthesis.jl && git checkout dots && git pull
	cd PluckArtifact.jl/Pluck.jl/src/RSDD/rsdd && git checkout main && git pull
	cd PluckArtifact-synthesis/PluckSynthesis.jl/src/RSDD/rsdd && git checkout main && git pull
