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

export solexaqa="singularity run \
    -B $BIND:/work \
    $SING_IMG/fastqc.img" 

echo "Running solexaqa on dna"
for file in $(ls $DNA); do
    $solexaqa dynamictrim /work/$DNA/$file --illumina
done

echo "Running solexaqa on rna"
for file in $(ls $RNA); do
    $solexaqa dynamictrim /work/$RNA/$file --illumina
done

echo Finished $(date)

#solexaqa usage
#
#Usage: /usr/bin/solexaqa dynamictrim input_files [-t|torrent] [-p|probcutoff 0.05] [-h|phredcutoff 13] [-b|bwa] [-d|directory path] [--sanger --solexa --illumina] [-t|torrent]
#
#Options:
#-p|--probcutoff     probability value (between 0 and 1) at which base-calling error is considered too high (default; p = 0.05) *or*
#-h|--phredcutoff    Phred quality score (between 0 and 41) at which base-calling error is considered too high
#-b|--bwa            use BWA trimming algorithm
#-d|--directory      path to directory where output files are saved
#--sanger            Sanger format (bypasses automatic format detection)
#--solexa            Solexa format (bypasses automatic format detection)
#--illumina          Illumina format (bypasses automatic format detection)
#-a|--anchor         Reads will only be trimmed from the 3′ end
#-t|--torrent        Ion Torrent fastq file
