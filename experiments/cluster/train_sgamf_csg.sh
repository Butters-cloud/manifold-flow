#!/bin/bash

#SBATCH --job-name=t-sgamf-csg
#SBATCH --output=log_train_sgamf_csg.log
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=32GB
#SBATCH --time=7-00:00:00
#SBATCH --gres=gpu:1

module load cuda/10.1.105
source activate ml
cd /scratch/jb6504/manifold-flow/experiments

python -u train.py --dataset conditional_spherical_gaussian --algorithm gamf --specified --epsilon 0.01 --dir /scratch/jb6504/manifold-flow
python -u train.py --dataset conditional_spherical_gaussian --algorithm gamf --specified --epsilon 0.001 --dir /scratch/jb6504/manifold-flow
python -u train.py --dataset conditional_spherical_gaussian --algorithm gamf --specified --epsilon 0.1 --dir /scratch/jb6504/manifold-flow
