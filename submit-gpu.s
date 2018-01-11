#!/usr/bin/bash
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1
#SBATCH --get-user-env
srun python gpu-tutorial.py
