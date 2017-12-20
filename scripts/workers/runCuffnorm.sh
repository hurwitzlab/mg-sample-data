#!/usr/bin/env bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=1:ncpus=12:mem=72gb
###and the amount of time required to run it
#PBS -l walltime=03:00:00
#PBS -l cput=36:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea

if [ -n "$PBS_O_WORKDIR" ]; then
    cd $PBS_O_WORKDIR
fi

set -u

module load singularity

cd $ALN_DIR

echo Running cuffdiff with gff $GFF in $ALN_DIR

if [[ ! -d cuffnorm-out ]]; then
    mkdir -p cuffnorm-out
else
    rm -r cuffnorm-out/*
fi

cuffnorm="singularity exec \
    -B $BT2_DIR:$SING_BT2,$ALN_DIR:$SING_WD \
    $SING_IMG/bowcuff.img cuffnorm"

#need to manually set labels
time $cuffnorm -p 12 --labels "cancer","control" \
    -o $SING_WD/cuffnorm-out \
    --quiet \
    $SING_BT2/$GFF $(cat $CXB_LIST)
