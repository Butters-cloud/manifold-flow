#!/bin/bash

#SBATCH --job-name=t-emf-csg
#SBATCH --output=log_train_emf_csg_%a.log
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32GB
#SBATCH --time=7-00:00:00
#SBATCH --gres=gpu:1

module load cuda/10.1.105
source activate ml
export OMP_NUM_THREADS=1
cd /scratch/jb6504/manifold-flow/experiments

run=$((SLURM_ARRAY_TASK_ID / 9))
task=$((SLURM_ARRAY_TASK_ID % 9))
echo "SLURM_ARRAY_TASK_ID = ${SLURM_ARRAY_TASK_ID}, task = ${task}, run = ${run}"

case ${task} in
0) python -u train.py --modelname small --dataset conditional_spherical_gaussian --epsilon 0.01 --algorithm emf --outercouplingmlp --outercouplinglayers 1 --samplesize 100000 -i ${run} --dir /scratch/jb6504/manifold-flow ;;
1) python -u train.py --modelname small --dataset conditional_spherical_gaussian --epsilon 0.001 --algorithm emf --outercouplingmlp --outercouplinglayers 1 --samplesize 100000 -i ${run} --dir /scratch/jb6504/manifold-flow ;;
2) python -u train.py --modelname small --dataset conditional_spherical_gaussian --epsilon 0.1  --algorithm emf --outercouplingmlp --outercouplinglayers 1 --samplesize 100000 -i ${run} --dir /scratch/jb6504/manifold-flow ;;

3) python -u train.py --modelname small_shallow_long --dataset conditional_spherical_gaussian --algorithm emf --epsilon 0.01 --samplesize 100000 --epochs 50 --outerlayers 3 --innerlayers 3 -i ${run} --dir /scratch/jb6504/manifold-flow ;;
4) python -u train.py --modelname small_shallow_long --dataset conditional_spherical_gaussian --algorithm emf --epsilon 0.001 --samplesize 100000 --epochs 50 --outerlayers 3 --innerlayers 3 -i ${run} --dir /scratch/jb6504/manifold-flow ;;
5) python -u train.py --modelname small_shallow_long --dataset conditional_spherical_gaussian --algorithm emf --epsilon 0.1 --samplesize 100000 --epochs 50 --outerlayers 3 --innerlayers 3 -i ${run} --dir /scratch/jb6504/manifold-flow ;;

6) python -u train.py --modelname small_long --dataset conditional_spherical_gaussian --algorithm emf --epsilon 0.01 --samplesize 100000 --epochs 50 -i ${run} --dir /scratch/jb6504/manifold-flow ;;
7) python -u train.py --modelname small_long --dataset conditional_spherical_gaussian --algorithm emf --epsilon 0.001 --samplesize 100000 --epochs 50 -i ${run} --dir /scratch/jb6504/manifold-flow ;;
8) python -u train.py --modelname small_long --dataset conditional_spherical_gaussian --algorithm emf --epsilon 0.1 --samplesize 100000 --epochs 50 -i ${run} --dir /scratch/jb6504/manifold-flow ;;

*) echo "Nothing to do for job ${task}" ;;
esac
