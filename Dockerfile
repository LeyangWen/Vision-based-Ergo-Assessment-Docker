# Vision-based Ergonomic Assessment Docker
# Base image with GPU support (NVIDIA PyTorch)
FROM nvcr.io/nvidia/pytorch:22.03-py3

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    wget \
    curl \
    ffmpeg \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libglib2.0-0 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /workspace

# Create directory structure for the 3 main components
RUN mkdir -p /workspace/mmpose \
    && mkdir -p /workspace/motionbert \
    && mkdir -p /workspace/3D-angle \
    && mkdir -p /workspace/dataset \
    && mkdir -p /workspace/models

# Create volume mount points for data persistence
VOLUME ["/workspace/dataset", "/workspace/models"]

# Default command
CMD ["/bin/bash"]
