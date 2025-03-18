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
