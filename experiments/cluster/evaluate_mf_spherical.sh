#!/bin/bash

#SBATCH --job-name=e-mf-sg
#SBATCH --output=log_evaluate_mf_spherical_%a.log
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=32GB
#SBATCH --time=7-00:00:00
# #SBATCH --gres=gpu:1

source activate ml
cd /scratch/jb6504/manifold-flow/experiments

case ${SLURM_ARRAY_TASK_ID} in
#0) python -u evaluate.py --modelname small --dataset spherical_gaussian --algorithm mf --outercouplingmlp --outercouplinglayers 1 --epsilon 0.01 --dir /scratch/jb6504/manifold-flow ;;
#1) python -u evaluate.py --modelname small --dataset spherical_gaussian --algorithm mf --outercouplingmlp --outercouplinglayers 1 --epsilon 0.001 --dir /scratch/jb6504/manifold-flow ;;
#2) python -u evaluate.py --modelname small --dataset spherical_gaussian --algorithm mf --outercouplingmlp --outercouplinglayers 1 --epsilon 0.1 --dir /scratch/jb6504/manifold-flow ;;

0) python -u evaluate.py --modelname small_noprepost --dataset spherical_gaussian --epsilon 0.01 --algorithm mf --outercouplingmlp --outercouplinglayers 1 --dir /scratch/jb6504/manifold-flow ;;
1) python -u evaluate.py --modelname small_noprepost --dataset spherical_gaussian --epsilon 0.001 --algorithm mf --outercouplingmlp --outercouplinglayers 1 --dir /scratch/jb6504/manifold-flow ;;
2) python -u evaluate.py --modelname small_noprepost --dataset spherical_gaussian --epsilon 0.1  --algorithm mf --outercouplingmlp --outercouplinglayers 1 --dir /scratch/jb6504/manifold-flow ;;

3) python -u evaluate.py --modelname small_complex --dataset spherical_gaussian --epsilon 0.01 --algorithm mf --dir /scratch/jb6504/manifold-flow ;;
4) python -u evaluate.py --modelname small_complex --dataset spherical_gaussian --epsilon 0.001 --algorithm mf --dir /scratch/jb6504/manifold-flow ;;
5) python -u evaluate.py --modelname small_complex --dataset spherical_gaussian --epsilon 0.1  --algorithm mf --dir /scratch/jb6504/manifold-flow ;;

6) python -u evaluate.py --modelname small_shallow_long --dataset spherical_gaussian --algorithm mf --epsilon 0.01 --outerlayers 3 --innerlayers 3 --dir /scratch/jb6504/manifold-flow ;;
7) python -u evaluate.py --modelname small_shallow_long --dataset spherical_gaussian --algorithm mf --epsilon 0.001 --outerlayers 3 --innerlayers 3 --dir /scratch/jb6504/manifold-flow ;;
8) python -u evaluate.py --modelname small_shallow_long --dataset spherical_gaussian --algorithm mf --epsilon 0.1 --outerlayers 3 --innerlayers 3 --dir /scratch/jb6504/manifold-flow ;;

9) python -u evaluate.py --modelname small_long --dataset spherical_gaussian --algorithm mf --epsilon 0.01 --dir /scratch/jb6504/manifold-flow ;;
10) python -u evaluate.py --modelname small_long --dataset spherical_gaussian --algorithm mf --epsilon 0.001 --dir /scratch/jb6504/manifold-flow ;;
11) python -u evaluate.py --modelname small_long --dataset spherical_gaussian --algorithm mf --epsilon 0.1 --dir /scratch/jb6504/manifold-flow ;;

12) python -u evaluate.py --modelname small_prepie --dataset spherical_gaussian --epsilon 0.01 --algorithm mf --outercouplingmlp --outercouplinglayers 1 --dir /scratch/jb6504/manifold-flow ;;
13) python -u evaluate.py --modelname small_prepie --dataset spherical_gaussian --epsilon 0.001 --algorithm mf --outercouplingmlp --outercouplinglayers 1 --dir /scratch/jb6504/manifold-flow ;;
14) python -u evaluate.py --modelname small_prepie --dataset spherical_gaussian --epsilon 0.1  --algorithm mf --outercouplingmlp --outercouplinglayers 1 --dir /scratch/jb6504/manifold-flow ;;

15) python -u evaluate.py --modelname small_prepie_long --dataset spherical_gaussian --epsilon 0.01 --algorithm mf --outercouplingmlp --outercouplinglayers 1 --dir /scratch/jb6504/manifold-flow ;;
16) python -u evaluate.py --modelname small_prepie_long --dataset spherical_gaussian --epsilon 0.001 --algorithm mf --outercouplingmlp --outercouplinglayers 1 --dir /scratch/jb6504/manifold-flow ;;
17) python -u evaluate.py --modelname small_prepie_long --dataset spherical_gaussian --epsilon 0.1  --algorithm mf --outercouplingmlp --outercouplinglayers 1 --dir /scratch/jb6504/manifold-flow ;;

*) echo "Nothing to do for job ${SLURM_ARRAY_TASK_ID}" ;;
esac
