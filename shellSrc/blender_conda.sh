#! /bin/bash

eval "$(~/anaconda3/bin/conda shell.bash hook)"
conda activate blpy
LD_LIBRARY_PATH=${CONDA_PREFIX}/lib:LD_LIBRARY_PATH ${CONDA_PREFIX}/blender/blender &