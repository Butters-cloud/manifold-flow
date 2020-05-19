#!/bin/bash

conda activate ml
dir=/Users/johannbrehmer/work/projects/manifold_flow/manifold-flow
cd $dir/experiments

for run in 0 1 2 3 4
do
    for chain in 0 1 2 3
    do
        for param in 0 1 2
        do
            echo ""
            echo "Starting evaluation for param = ${param}, chain = ${chain}, run = ${run}"
            python -u evaluate.py -c configs/evaluate_flow_lhc_june.config --algorithm pie -i $run --trueparam $param --chain $chain

        done
    done
done

for run in 0 1 2 3 4
do
    for chain in 0 1 2 3
    do
        for param in 0 1 2
        do
            echo ""
            echo "Starting SCANDAL evaluation for param = ${param}, chain = ${chain}, run = ${run}"
            python -u evaluate.py -c configs/evaluate_flow_lhc_june.config --algorithm pie --modelname scandal_june -i $run --trueparam $param --chain $chain

        done
    done
done

for run in 0 1 2 3 4
do
    for chain in 0 1 2 3
    do
        for param in 0 1 2
        do
            echo ""
            echo "Starting conditional-manifold evaluation for param = ${param}, chain = ${chain}, run = ${run}"
            python -u evaluate.py -c configs/evaluate_flow_lhc_june.config --algorithm pie --modelname conditionalmanifold_june -i $run --trueparam $param --chain $chain

        done
    done
done

for run in 0 1 2 3 4
do
    for chain in 0 1 2 3
    do
        for param in 0 1 2
        do
            echo ""
            echo "Starting conditional-manifold SCANDAL evaluation for param = ${param}, chain = ${chain}, run = ${run}"
            python -u evaluate.py -c configs/evaluate_flow_lhc_june.config --algorithm pie --modelname scandal_conditionalmanifold_june -i $run --trueparam $param --chain $chain

        done
    done
done