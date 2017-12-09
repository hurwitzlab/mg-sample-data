#!/usr/bin/env bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=1:ncpus=6:mem=25gb
#PBS -l walltime=3:00:00
#PBS -l cput=18:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea

#make sure this matches ncpus in the above header!
export THREADS="--threads 6"
#
# runs bowtie2-build 
#

# --------------------------------------------------
# singularity is needed to run singularity images
module load singularity
# --------------------------------------------------


cd $PBS_O_WORKDIR

set -u

echo "Started at $(date) on host $(hostname)"

CONFIG="$SCRIPT_DIR/config.sh"

if [ -e $CONFIG ]; then
  . "$CONFIG"
else
  echo Missing config \"$CONFIG\"
  exit 1
fi

export bt2="singularity exec \
    -B $BT2_DIR:$SING_BT2,$RNA_DIR:$SING_WD,$OUT:$SING_OUT \
    $SING_IMG/bowcuff.img bowtie2"

echo "Running bowtie2 mapping program on $SAMPLE"

for FASTQ in $(cat $FASTQ_LIST); do

    R1=$(basename $FASTQ)
    R2=$(basename $FASTQ R1.fastq)R2.fastq

    $bt2 $THREADS \
        --no-unal \
        -k 1 \
        -x $SING_BT2/$(basename $BT2) \
        -1 $SING_WD/$R1 \
        -2 $SING_WD/$R2 \
        -S $SING_OUT/$SAMPLE.sam

done

echo "Done at $(date)"
