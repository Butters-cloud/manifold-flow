#!/bin/bash

#SBATCH --job-name=mf-t-sf-csg
#SBATCH --output=log_train_flow_csg.log
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=32GB
#SBATCH --time=7-00:00:00
#SBATCH --gres=gpu:1

source activate ml
cd /scratch/jb6504/manifold-flow/experiments

python -u train.py --dataset conditional_spherical_gaussian --algorithm flow --datadim 9 --epsilon 0.01 --dir /scratch/jb6504/manifold-flow --debug
python -u train.py --dataset conditional_spherical_gaussian --algorithm flow --datadim 9 --epsilon 0.001 --dir /scratch/jb6504/manifold-flow
python -u train.py --dataset conditional_spherical_gaussian --algorithm flow --datadim 9 --epsilon 0.1 --dir /scratch/jb6504/manifold-flow
python -u train.py --dataset conditional_spherical_gaussian --algorithm flow --datadim 12 --epsilon 0.01 --dir /scratch/jb6504/manifold-flow
python -u train.py --dataset conditional_spherical_gaussian --algorithm flow --datadim 16 --epsilon 0.01 --dir /scratch/jb6504/manifold-flow
