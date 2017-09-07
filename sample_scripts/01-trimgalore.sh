#!/bin/bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=1:ncpus=2:mem=4gb
#PBS -l walltime=24:00:00
#PBS -l cput=24:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m ea
#PBS -j oe

#
# runs singularity fastqc.img to generate fastqc reports
#

# --------------------------------------------------
# singularity is needed to run singularity images
module load singularity
# --------------------------------------------------

# IMPORTANT VARIABLES YOU NEED TO SET, YES YOU! 
export SING_IMG="/rsgrps/bhurwitz/scottdaniel/singularity-images"
export BIND="/rsgrps/bhurwitz/scottdaniel/mg-sample-data"
export DNA="dna"
export RNA="rna"

cd $BIND

set -u

echo Host \"$(hostname)\"

echo Started $(date)

export trim_galore="singularity exec \
    -B $BIND:/work \
    $SING_IMG/fastqc.img trim_galore" 

echo "Running trim_galore on dna"
for file in $(ls $DNA/*R1.fastq); do
    PREFIX="/work/$DNA"
    R1=$file
    R2=$(basename $file R1.fastq)R2.fastq
    $trim_galore --paired --fastqc -o $PREFIX $PREFIX/$R1 $PREFIX/$R2 
done

echo "Running trim_galore on rna"
for file in $(ls $RNA/*R1.fastq); do
    PREFIX="/work/$RNA"
    R1=$file
    R2=$(basename $file R1.fastq)R2.fastq
    $trim_galore --paired --fastqc -o $PREFIX $PREFIX/$R1 $PREFIX/$R2
done

echo Finished $(date)

#EXampel:
#singularity exec -B $BIND:/work /rsgrps/bhurwitz/scottdaniel/singularity-images/fastqc.img trim_galore --paired --fastqc -o /work/dna /work/dna/DNA_cancer_R1.fastq /work/dna/DA_cancer_R2.fastq
