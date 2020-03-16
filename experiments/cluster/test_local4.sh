#!/usr/bin/env bash

source activate ml
basedir=/Users/johannbrehmer/work/projects/manifold_flow/manifold-flow
cd $basedir/experiments

i=3

python -u evaluate.py --modelname march --dataset power --algorithm pie --splinebins 10 --splinerange 6. --gridresolution 101 -i $i --dir $basedir
python -u evaluate.py --modelname march --dataset power --algorithm emf --splinebins 10 --splinerange 6. --gridresolution 101  -i $i --dir $basedir
python -u evaluate.py --modelname alternate_march --dataset power --algorithm gamf --splinebins 10 --splinerange 6. --gridresolution 101 -i $i --dir $basedir
python -u evaluate.py --modelname march --dataset power --algorithm gamf --splinebins 10 --splinerange 6. --gridresolution 101 -i $i --dir $basedir
