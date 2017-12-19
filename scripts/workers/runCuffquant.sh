#!/usr/bin/env bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=1:ncpus=12:mem=72gb
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

echo Running cuffdiff with gff $GFF in $BT2_DIR
echo With sample "$SAMPLE".bam

if [[ ! -d "$SAMPLE"/cuffquant-out ]]; then
    mkdir -p "$SAMPLE"/cuffquant-out
else
    rm "$SAMPLE"/cuffquant-out/*
fi

cuffquant="singularity exec \
    -B $BT2_DIR:$SING_BT2,$ALN_DIR:$SING_WD \
    $SING_IMG/bowcuff.img cuffquant"

for BAM in $(cat $BAM_LIST); do

    BASE="$SING_WD/$SAMPLE/$(basename $BAM)"
    OUT_DIR="$SING_WD/$SAMPLE/cuffquant-out"

    time $cuffquant -p 12 \
        -o $OUT_DIR \
        -M $SING_BT2/$RRNAGFF \
        --quiet \
        $SING_BT2/$GFF $BASE

done
