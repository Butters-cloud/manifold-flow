#!/bin/bash


# sbatch timing.sh

# sbatch simulate.sh


# sbatch train_flow_spherical.sh  # some missing
# sbatch train_pie_spherical.sh  # some missing
# sbatch train_gamf_spherical.sh  # restarted with higher loss
# sbatch train_spie_spherical.sh  # not yet done
# sbatch train_sgamf_spherical.sh  # not yet done
# sbatch train_smf_spherical.sh  # not yet done (NaNs in likelihood -- fixed now?)
# sbatch --array=0-2 train_mf_spherical.sh  # not yet done
# sbatch train_pie_epsilon_spherical.sh  # not yet done, wait for L2 results

# sbatch train_flow_csg.sh  # some missing
# sbatch train_pie_csg.sh  # some missing
# sbatch train_gamf_csg.sh  # restarted with higher loss
# sbatch train_spie_csg.sh  # not yet done
# sbatch train_sgamf_csg.sh  # not yet done
# sbatch train_smf_csg.sh  # not yet done (NaNs in likelihood -- fixed now?)
# sbatch --array=0-2 train_mf_csg.sh  # not yet done
# sbatch train_pie_epsilon_csg.sh  # not yet done, wait for L2 results

# sbatch train_flow_tth2d.sh  # restarted b/c of dodgy results
# sbatch train_flow_tth.sh  # done
# sbatch train_pie_tth.sh  # done
# sbatch train_gamf_tth.sh  # restarted with higher loss
# sbatch train_mf_tth.sh  # CUDA memory issue, next try with bs 50


sbatch evaluate_flow_spherical.sh
sbatch evaluate_pie_spherical.sh
sbatch evaluate_gamf_spherical.sh
sbatch evaluate_spie_spherical.sh
sbatch evaluate_smf_spherical.sh
sbatch evaluate_sgamf_spherical.sh
sbatch evaluate_mf_spherical.sh
# sbatch evaluate_pie_epsilon_spherical.sh  # not yet trained

sbatch evaluate_flow_csg.sh
sbatch evaluate_pie_csg.sh
sbatch evaluate_gamf_csg.sh
sbatch evaluate_spie_csg.sh
sbatch evaluate_smf_csg.sh
sbatch evaluate_sgamf_csg.sh
sbatch evaluate_mf_csg.sh
# sbatch evaluate_pie_epsilon_csg.sh  # not yet trained

sbatch evaluate_flow_tth2d.sh
sbatch evaluate_flow_tth.sh
sbatch evaluate_pie_tth.sh
sbatch evaluate_gamf_tth.sh
# sbatch evaluate_mf_tth.sh  # not yet trained
