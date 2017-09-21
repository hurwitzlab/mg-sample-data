#!/usr/bin/env bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=1:ncpus=12:mem=72gb
#PBS -l walltime=24:00:00
#PBS -l cput=288:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m ea
#PBS -j oe

#make sure this matches ncpus in the above header!
export THREADS="--threads 12"
#
# runs taxoner
#
unset module
set -u

COMMON="$WORKER_DIR/common.sh"

if [ -e $COMMON ]; then
  . "$COMMON"
else
  echo Missing common \"$COMMON\"
  exit 1
fi

cd $PRJ_DIR

echo Host \"$(hostname)\"

echo Started $(date)

TMP_FILES=$(mktemp)

get_lines $TODO $TMP_FILES $PBS_ARRAY_INDEX $STEP_SIZE

NUM_FILES=$(lc $TMP_FILES)

if [[ $NUM_FILES -lt 1 ]]; then
    echo Something went wrong or no files to process
    exit 1
else
    echo Found \"$NUM_FILES\" files to process
fi

cd $SRA_DIR

echo "Running taxoner on "$(cat $TMP_FILES)""

#debugging for now
set -x

for file in $(cat $TMP_FILES); do

    BASE=$(basename $file _1_val_1.fq.gz)
    R1="$BASE"_1_val_1.fq.gz
    R2="$BASE"_2_val_2.fq.gz
    OUT_DIR=$TAXONER_DIR/$BASE

    if [ ! -d $OUT_DIR ]; then
        mkdir -p $OUT_DIR
    fi

#-l tells it to use large (>4gb bowtie2indices or forced with --large-index)
#-A gets all alignment info like CIGAR style alignment score etc.
    taxoner64 $THREADS \
        -l \
        -A \
        --dbPath $BT2_DIR \
        --taxpath $META_DIR/PATRIC_nodes.txt \
        --seq $TRIMMED_DIR/$R1 \
        --paired $TRIMMED_DIR/$R2 \
        --output $OUT_DIR \
        -y $SRA_DIR/extra_commands.txt

done

echo Finished $(date)
#
#Usage: taxoner -d <folder> -s <input reads> -o <output folder> -n <nodes.dmp>
#
#Taxoner64 version 0.1.3
#
#taxoner64 options:
#
# -d <string>,   --dbPath    Specifies folder path to database
# -s <string>,   --seq       Input fastq/fasta reads
# -o <string>,   --output    Output folder path
# -n <string>,   --taxpath   Specifies file nodes file (nodes.dmp from NCBI)
#
# Database options:
# -l,        --largeGenome   Bowtie2 will use large (>4Gb) genomes
# -g,        --both-genome-sizes Bowtie2 will use large (>4Gb) and smaller genomes
# -i <string>,   --bwt2-indexes  Specify comma separated names of indexes to be used at
#            alignment. Indexes present in --dbPath <folder>
#
# Read options:
# -f,        --fasta     Input reads are in fasta format
# -p <string>,   --paired    Specify second pair of reads for paired-end mode
# -I <int>,  --minInsert Minimum insert size for paired-end mode. Default: 0
# -X <int>,  --maxInsert Maximum insert size for paired-end mode. Default: 500
#
#
# Alignment options:
# -b <int>,  --bt2-maxhits   Maximum alignments to report. Default: 10
# -a,        --bt2-allhits   Report all alignments
# -w <string>,   --bowtie2   Specifies bowtie2 executable
# -c <string>,   --host-filter   Specify bowtie2 index to host genome to filter with.
# -A,    --alignStats    Add an extra CIGAR style column about alignments
# -y <string>,   --bwt2-params   Input file with all extra bowtie2 parameters.
#
# Nearest neighbor options:
# -r <float>,    --neighbor-score    Specifies alignment score for nearest neighbor.
#                Default score: 1.0
# -e,        --only-neighbor Perform only nearest neighbor analysis without alignment
# -k <string>,   --skip      Specify file containing taxon IDs to skip from analysis
# -m,        --megan     Create megan compatible output
# -u,        --virus-filter  Don't skip viruses from analysis
#            If specified, IDs 10239, 28384 will be used in analysis.
#
# Performance options:
# -t <int>,  --threads   Number of CPU threads to use. Default: 2
#
# -h,        --help      Display this usage information.
# -v,        --verbose   Quiet mode (no output in terminal
#
#********************************************************************************
#
#            Lorinc Pongor (e-mail: pongorlorinc@gmail.com)
#            Roberto Vera Alvarez (e-mail: r78v10a07@gmail.com)
#
