#!/usr/bin/env bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=1:ncpus=2:mem=12gb
#PBS -l walltime=00:30:00
#PBS -l cput=00:30:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m ea
#PBS -j oe

#
# runs bowtie2-build 
#

# --------------------------------------------------
# singularity is needed to run singularity images
module load singularity
# --------------------------------------------------

unset module
set -u
cd $PBS_O_WORKDIR

echo "Started at $(date) on host $(hostname)"

echo "Bowtie2 indexing..."

cd $BT2_DIR

export bt2build="singularity exec \
    -B $BT2_DIR:$SING_BT2 \
    $SING_IMG/bowcuff.img bowtie2-build" 

BASE=$(basename $GENOME .fa)

$bt2build $SING_BT2/$BASE.fa $SING_BT2/$BASE

echo "Done $(date)"
