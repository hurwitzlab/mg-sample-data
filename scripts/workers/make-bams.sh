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

echo Converting $SAMPLE using reference $GENOME

samtools view -@ 12 -bT $GENOME $SAMPLE.sam > $SAMPLE.temp

echo Sorting $SAMPLE

samtools sort -@ 12 $SAMPLE.temp > $SAMDIR/$SAMPLE.bam

echo Removing $SAMPLE.temp

rm $SAMPLE.temp

