#!/bin/bash

#SBATCH --job-name=t-hy-tth
#SBATCH --output=log_train_hybrid_tth.log
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=32GB
#SBATCH --time=7-00:00:00
#SBATCH --gres=gpu:1

module load cuda/10.1.105
source activate ml
cd /scratch/jb6504/manifold-flow/experiments

python -u train.py --dataset tth --algorithm hybrid --outercouplingmlp --outercouplinglayers 1 --outercouplinghidden 100 --modellatentdim 20 --lr 1.e-4 --dir /scratch/jb6504/manifold-flow
