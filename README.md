# Vision-based Ergonomic Assessment Docker

A Docker-based pipeline for vision-based ergonomic assessment using pose estimation.

## Overview

This project provides a containerized environment for ergonomic assessment through three main components:

1. **mmpose** - Image/Video to 2D Pose Estimation
2. **motionbert** - 2D to 3D Pose Estimation  
3. **3D-angle** - 3D Pose to Joint Angle Calculation

## Prerequisites

- Docker with NVIDIA GPU support
- NVIDIA Driver (tested with NVIDIA-SMI 570.133.07, CUDA Version: 12.8)
- NVIDIA Container Toolkit

### Verify GPU Support

```bash
# Verify NVIDIA driver is installed
nvidia-smi

# Test Docker GPU access
sudo docker run --rm --gpus all nvcr.io/nvidia/pytorch:22.03-py3 nvidia-smi
```

## Project Structure

```
Vision-based-Ergo-Assessment-Docker/
├── Dockerfile              # Docker image definition
├── docker-compose.yml      # Docker Compose configuration
├── .dockerignore          # Files to exclude from Docker build
├── mmpose/                # MMPose component (2D pose estimation)
├── motionbert/            # MotionBERT component (2D to 3D pose)
├── 3D-angle/              # 3D angle calculation component
├── dataset/               # Input data and output results
└── models/                # Pre-trained model weights
```

## Quick Start

### Option 1: Using Docker Compose (Recommended)

```bash
# Clone the repository
git clone https://github.com/LeyangWen/Vision-based-Ergo-Assessment-Docker.git
cd Vision-based-Ergo-Assessment-Docker

# Build and start the container
docker-compose up -d

# Enter the container
docker-compose exec vision-ergo bash

# Stop the container
docker-compose down
```

### Option 2: Using Docker Run

```bash
# Build the image
docker build -t vision-ergo-assessment .

# Run the container with GPU support
sudo docker run --rm -it --gpus all \
    -v $(pwd)/mmpose:/workspace/mmpose \
    -v $(pwd)/motionbert:/workspace/motionbert \
    -v $(pwd)/3D-angle:/workspace/3D-angle \
    -v $(pwd)/dataset:/workspace/dataset \
    -v $(pwd)/models:/workspace/models \
    vision-ergo-assessment
```

### Option 3: Using Base NVIDIA Image Directly

```bash
# Run directly with the NVIDIA PyTorch base image (with specific mounts for security)
sudo docker run --rm -it --gpus all \
    -v $(pwd)/mmpose:/workspace/mmpose \
    -v $(pwd)/motionbert:/workspace/motionbert \
    -v $(pwd)/3D-angle:/workspace/3D-angle \
    -v $(pwd)/dataset:/workspace/dataset \
    -v $(pwd)/models:/workspace/models \
    -w /workspace \
    nvcr.io/nvidia/pytorch:22.03-py3
```

## Setting Up Components

After entering the Docker container, clone the required repositories:

### 1. MMPose (2D Pose Estimation)

```bash
cd /workspace/mmpose
git clone https://github.com/open-mmlab/mmpose.git .
pip install -r requirements.txt
pip install -e .
```

### 2. MotionBERT (2D to 3D Pose)

```bash
cd /workspace/motionbert
git clone https://github.com/Walter0807/MotionBERT.git .
pip install -r requirements.txt
```

### 3. 3D-Angle Calculation

```bash
cd /workspace/3D-angle
# Clone or add your custom 3D angle calculation code
```

## Accessing Files

### From Host Machine

All mounted directories are accessible from your host machine:
- `./mmpose` ↔ `/workspace/mmpose`
- `./motionbert` ↔ `/workspace/motionbert`
- `./3D-angle` ↔ `/workspace/3D-angle`
- `./dataset` ↔ `/workspace/dataset`
- `./models` ↔ `/workspace/models`

### Inside Container

```bash
# Navigate to workspace
cd /workspace

# List all components
ls -la

# Check GPU availability
python -c "import torch; print(f'CUDA available: {torch.cuda.is_available()}')"
python -c "import torch; print(f'GPU count: {torch.cuda.device_count()}')"
```

## GPU Configuration

The Docker setup is configured for full GPU access:

- Uses NVIDIA Container Runtime
- All GPUs are exposed by default
- CUDA and cuDNN are pre-installed in the base image

To limit GPU access, modify `docker-compose.yml`:

```yaml
environment:
  - NVIDIA_VISIBLE_DEVICES=0  # Use only GPU 0
```

## Troubleshooting

### Docker GPU Access Issues

```bash
# Ensure NVIDIA Container Toolkit is installed
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker
```

### Permission Issues

```bash
# If you encounter permission issues with mounted volumes
sudo chown -R $(id -u):$(id -g) ./dataset ./models
```

## License

See individual component repositories for their respective licenses.