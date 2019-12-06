#!/bin/bash

#SBATCH --job-name=e-hy-csg
#SBATCH --output=log_evaluate_hybrid_csg.log
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=32GB
#SBATCH --time=7-00:00:00
# #SBATCH --gres=gpu:1

source activate ml
cd /scratch/jb6504/manifold-flow/experiments

python -u evaluate.py --dataset conditional_spherical_gaussian --algorithm hybrid --epsilon 0.01 --dir /scratch/jb6504/manifold-flow
python -u evaluate.py --dataset conditional_spherical_gaussian --algorithm hybrid --epsilon 0.001 --dir /scratch/jb6504/manifold-flow
python -u evaluate.py --dataset conditional_spherical_gaussian --algorithm hybrid --epsilon 0.1 --dir /scratch/jb6504/manifold-flow
