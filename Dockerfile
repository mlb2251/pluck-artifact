FROM julia:1.11.4

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    procps \
    time \
    && rm -rf /var/lib/apt/lists/*

USER root
WORKDIR /PluckArtifact.jl
COPY . /PluckArtifact.jl


# Install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install Python3
RUN apt-get update && apt-get install -y python3 python3-pip python3-sympy


# Build rust library
RUN make bindings

# Install Julia dependencies
RUN julia --project -e 'using Pkg; Pkg.instantiate()'

# Set default entrypoint to bash
ENTRYPOINT ["/bin/bash"]



