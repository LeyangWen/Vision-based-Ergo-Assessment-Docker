# Models

This folder is for storing pre-trained model weights.

## Structure

```
models/
├── mmpose/         # MMPose model weights
├── motionbert/     # MotionBERT model weights
└── custom/         # Custom model weights
```

## Notes

- This directory is mounted as a Docker volume for data persistence
- Download pre-trained weights and place them in the appropriate subdirectory
- Model files are typically large and should not be committed to git
