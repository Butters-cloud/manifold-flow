#!/bin/bash

#SBATCH --job-name=t-mf-sg
#SBATCH --output=log_train_mf_spherical_%a.log
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32GB
#SBATCH --time=7-00:00:00
#SBATCH --gres=gpu:1

module load cuda/10.1.105
source activate ml
export OMP_NUM_THREADS=1
cd /scratch/jb6504/manifold-flow/experiments

case ${SLURM_ARRAY_TASK_ID} in
#0) python -u train.py --modelname small --dataset spherical_gaussian --epsilon 0.01 --algorithm mf --outercouplingmlp --outercouplinglayers 1 --samplesize 100000 --dir /scratch/jb6504/manifold-flow ;;
#1) python -u train.py --modelname small --dataset spherical_gaussian --epsilon 0.001 --algorithm mf --outercouplingmlp --outercouplinglayers 1 --samplesize 100000 --dir /scratch/jb6504/manifold-flow ;;
#2) python -u train.py --modelname small --dataset spherical_gaussian --epsilon 0.1  --algorithm mf --outercouplingmlp --outercouplinglayers 1 --samplesize 100000 --dir /scratch/jb6504/manifold-flow ;;

#0) python -u train.py --modelname small_noprepost --dataset spherical_gaussian --epsilon 0.01 --algorithm mf --outercouplingmlp --outercouplinglayers 1 --nopretraining --noposttraining --samplesize 100000 --dir /scratch/jb6504/manifold-flow ;;
#1) python -u train.py --modelname small_noprepost --dataset spherical_gaussian --epsilon 0.001 --algorithm mf --outercouplingmlp --outercouplinglayers 1 --nopretraining --noposttraining --samplesize 100000 --dir /scratch/jb6504/manifold-flow ;;
#2) python -u train.py --modelname small_noprepost --dataset spherical_gaussian --epsilon 0.1  --algorithm mf --outercouplingmlp --outercouplinglayers 1 --nopretraining --noposttraining --samplesize 100000 --dir /scratch/jb6504/manifold-flow ;;
#
#3) python -u train.py --modelname small_complex --dataset spherical_gaussian --epsilon 0.01 --algorithm mf --samplesize 100000 --dir /scratch/jb6504/manifold-flow ;;
#4) python -u train.py --modelname small_complex --dataset spherical_gaussian --epsilon 0.001 --algorithm mf --samplesize 100000 --dir /scratch/jb6504/manifold-flow ;;
#5) python -u train.py --modelname small_complex --dataset spherical_gaussian --epsilon 0.1  --algorithm mf --samplesize 100000 --dir /scratch/jb6504/manifold-flow ;;

0) python -u train.py --modelname small_shallow_long --dataset spherical_gaussian --algorithm mf --epsilon 0.01 --samplesize 100000 --epochs 50 --outerlayers 3 --innerlayers 3 --dir /scratch/jb6504/manifold-flow ;;
1) python -u train.py --modelname small_shallow_long --dataset spherical_gaussian --algorithm mf --epsilon 0.001 --samplesize 100000 --epochs 50 --outerlayers 3 --innerlayers 3 --dir /scratch/jb6504/manifold-flow ;;
2) python -u train.py --modelname small_shallow_long --dataset spherical_gaussian --algorithm mf --epsilon 0.1 --samplesize 100000 --epochs 50 --outerlayers 3 --innerlayers 3 --dir /scratch/jb6504/manifold-flow ;;

3) python -u train.py --modelname small_long --dataset spherical_gaussian --algorithm mf --epsilon 0.01 --samplesize 100000 --epochs 50 --dir /scratch/jb6504/manifold-flow ;;
#4) python -u train.py --modelname small_long --dataset spherical_gaussian --algorithm mf --epsilon 0.001 --samplesize 100000 --epochs 50 --dir /scratch/jb6504/manifold-flow ;;
#5) python -u train.py --modelname small_long --dataset spherical_gaussian --algorithm mf --epsilon 0.1 --samplesize 100000 --epochs 50 --dir /scratch/jb6504/manifold-flow ;;

4) python -u train.py --modelname small_prepie --dataset spherical_gaussian --epsilon 0.01 --algorithm mf --outercouplingmlp --outercouplinglayers 1 --prepie  --samplesize 100000 --dir /scratch/jb6504/manifold-flow ;;
5) python -u train.py --modelname small_prepie --dataset spherical_gaussian --epsilon 0.001 --algorithm mf --outercouplingmlp --outercouplinglayers 1 --prepie  --samplesize 100000 --dir /scratch/jb6504/manifold-flow ;;
6) python -u train.py --modelname small_prepie --dataset spherical_gaussian --epsilon 0.1  --algorithm mf --outercouplingmlp --outercouplinglayers 1 --prepie  --samplesize 100000 --dir /scratch/jb6504/manifold-flow ;;

7) python -u train.py --modelname small_prepie_long --dataset spherical_gaussian --epsilon 0.01 --algorithm mf --outercouplingmlp --outercouplinglayers 1 --prepie  --epochs 50 --samplesize 100000 --dir /scratch/jb6504/manifold-flow ;;
8) python -u train.py --modelname small_prepie_long --dataset spherical_gaussian --epsilon 0.001 --algorithm mf --outercouplingmlp --outercouplinglayers 1 --prepie  --epochs 50 --samplesize 100000 --dir /scratch/jb6504/manifold-flow ;;
9) python -u train.py --modelname small_prepie_long --dataset spherical_gaussian --epsilon 0.1  --algorithm mf --outercouplingmlp --outercouplinglayers 1 --prepie  --epochs 50 --samplesize 100000 --dir /scratch/jb6504/manifold-flow ;;

10) python -u train.py --modelname small_morenll --dataset spherical_gaussian --epsilon 0.01 --algorithm mf --outercouplingmlp --outercouplinglayers 1 --samplesize 100000 -addnllfactor 1.0 --dir /scratch/jb6504/manifold-flow ;;
11) python -u train.py --modelname small_morenll --dataset spherical_gaussian --epsilon 0.001 --algorithm mf --outercouplingmlp --outercouplinglayers 1 --samplesize 100000 -addnllfactor 1.0 --dir /scratch/jb6504/manifold-flow ;;
12) python -u train.py --modelname small_morenll --dataset spherical_gaussian --epsilon 0.1  --algorithm mf --outercouplingmlp --outercouplinglayers 1 --samplesize 100000 -addnllfactor 1.0 --dir /scratch/jb6504/manifold-flow ;;

13) python -u train.py --modelname small_morenll_long --dataset spherical_gaussian --epsilon 0.01 --algorithm mf --outercouplingmlp --outercouplinglayers 1 --samplesize 100000 -addnllfactor 1.0 --epochs 50 --dir /scratch/jb6504/manifold-flow ;;
14) python -u train.py --modelname small_morenll_long --dataset spherical_gaussian --epsilon 0.001 --algorithm mf --outercouplingmlp --outercouplinglayers 1 --samplesize 100000 -addnllfactor 1.0 --epochs 50 --dir /scratch/jb6504/manifold-flow ;;
15) python -u train.py --modelname small_morenll_long --dataset spherical_gaussian --epsilon 0.1  --algorithm mf --outercouplingmlp --outercouplinglayers 1 --samplesize 100000 -addnllfactor 1.0 --epochs 50 --dir /scratch/jb6504/manifold-flow ;;

*) echo "Nothing to do for job ${SLURM_ARRAY_TASK_ID}" ;;
esac
