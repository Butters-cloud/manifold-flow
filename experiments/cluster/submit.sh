#!/bin/bash


# sbatch timing.sh

# sbatch simulate.sh


#sbatch train_flow_spherical.sh
#sbatch train_pie_spherical.sh
#sbatch train_gamf_spherical.sh
#sbatch train_spie_spherical.sh
#sbatch train_sgamf_spherical.sh
#sbatch train_smf_spherical.sh
sbatch --array=0-10 train_mf_spherical.sh
#sbatch --array=0-2 train_emf_spherical.sh
# sbatch train_pie_epsilon_spherical.sh

#sbatch train_flow_csg.sh
#sbatch train_pie_csg.sh
#sbatch train_gamf_csg.sh
#sbatch train_spie_csg.sh
#sbatch train_sgamf_csg.sh
#sbatch train_smf_csg.sh
sbatch --array=0-10 train_mf_csg.sh
#sbatch --array=0-2 train_emf_csg.sh
# sbatch train_pie_epsilon_csg.sh

# sbatch train_flow_lhc2d.sh
# sbatch train_flow_lhc.sh
# sbatch train_pie_lhc.sh
#sbatch train_gamf_lhc.sh
# sbatch train_mf_lhc.sh
# sbatch train_emf_lhc.sh


#sbatch evaluate_flow_spherical.sh
#sbatch evaluate_pie_spherical.sh
#sbatch --array 0-11 evaluate_gamf_spherical.sh
#sbatch --array 0-17 evaluate_mf_spherical.sh
#sbatch --array 0-2 evaluate_emf_spherical.sh
#sbatch evaluate_spie_spherical.sh
#sbatch evaluate_smf_spherical.sh
#sbatch evaluate_sgamf_spherical.sh
###sbatch evaluate_pie_epsilon_spherical.sh
#
#sbatch evaluate_flow_csg.sh
#sbatch evaluate_pie_csg.sh
#sbatch --array 0-11 evaluate_gamf_csg.sh
#sbatch --array 0-17 evaluate_mf_csg.sh
#sbatch --array 0-2 evaluate_emf_csg.sh
#sbatch evaluate_spie_csg.sh
#sbatch evaluate_smf_csg.sh
#sbatch evaluate_sgamf_csg.sh
### sbatch evaluate_pie_epsilon_csg.sh
#
#sbatch evaluate_flow_lhc2d.sh
#sbatch evaluate_flow_lhc.sh
#sbatch evaluate_pie_lhc.sh
#sbatch --array 0-4 evaluate_gamf_lhc.sh
# sbatch evaluate_mf_lhc.sh
# sbatch evaluate_emf_lhc.sh
