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

samtools="singularity exec -B $BT2_DIR:$SING_BT2,$ALN_DIR:$SING_WD \
    $SING_IMG/pythonFaves.img \
    samtools"

echo Converting $SAMPLE using reference $GENOME

for SAM in $(cat $SAM_LIST); do

    REALG="$SING_BT2/$GENOME"
    BASE="$SING_WD/$SAMPLE/$(basename $SAM .sam)"

    $samtools view -@ 12 -bT $REALG $BASE.sam > $BASE.temp

    echo Sorting $SAMPLE

    $samtools sort -@ 12 $BASE.temp > $BASE.bam

    echo Removing $SAMPLE.temp

    rm $SAMPLE/$(basename $SAM .sam).temp

done

echo DONE at $(date)
