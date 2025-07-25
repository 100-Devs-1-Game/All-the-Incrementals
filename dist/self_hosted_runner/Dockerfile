FROM ubuntu:22.04

# Avoid prompts during install
ENV DEBIAN_FRONTEND=noninteractive

# Install required dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    git \
    python3 \
    python3-pip \
    python-is-python3 \
    unzip \
    libicu70 \
    libssl-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create a user to run the GitHub Actions runner
RUN useradd -m runner
WORKDIR /home/runner

# Download and extract the latest runner
ARG RUNNER_VERSION=2.315.0
RUN curl -Ls https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    | tar xz

RUN apt-get update && apt-get install -y --no-install-recommends \
    docker

# Give runner user ownership
RUN chown -R runner:runner /home/runner

# Switch to the runner user
USER runner

# Entry point (you'll still need to configure this with ./config.sh at runtime or build time)
ENTRYPOINT ["/bin/bash"]
