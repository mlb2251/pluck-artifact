docker-start:
	docker run -it -m 60g -p 8000:8000 -v $(PWD):/PluckArtifact.jl pluckartifact:latest

bindings:
	cd Pluck.jl && make bindings
	cd PluckSynthesis.jl && make bindings

docker-build:
	docker build -t pluckartifact:latest .
