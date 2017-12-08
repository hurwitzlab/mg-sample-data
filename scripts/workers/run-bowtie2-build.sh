#!/usr/bin/env bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=1:ncpus=6:mem=10gb
#PBS -l walltime=4:00:00
#PBS -l cput=4:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea

cd $PBS_O_WORKDIR

set -u

echo "Started at $(date) on host $(hostname)"

echo "Bowtie2 indexing..."

cd $BT2_DIR

bowtie2-build --threads 6 all.fa all

echo "Done $(date)"
