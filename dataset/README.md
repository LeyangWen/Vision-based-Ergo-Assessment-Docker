# Dataset

This folder is for storing datasets used by the vision-based ergonomic assessment pipeline.

## Structure

```
dataset/
├── images/         # Input images
├── videos/         # Input videos
├── poses_2d/       # 2D pose estimation outputs
├── poses_3d/       # 3D pose estimation outputs
└── results/        # Final ergonomic assessment results
```

## Notes

- This directory is mounted as a Docker volume for data persistence
- Large datasets should be stored here for processing
