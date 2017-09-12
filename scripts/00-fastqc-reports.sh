#!/usr/bin/env bash
#
# runs singularity fastqc.img to generate fastqc reports
#

set -u
source ./config.sh
export CWD="$PWD"
#batches of N
export STEP_SIZE=2

PROG=`basename $0 ".sh"`
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR" 


# --------------------------------------------------
# singularity is needed to run singularity images
module load singularity
# --------------------------------------------------
cd $PRJ_DIR

set -u

export DNALIST="dna_fastq_file_list"
export RNALIST="rna_fastq_file_list"

find $DNA_DIR -iname "*.fastq" > $DNALIST
find $RNA_DIR -iname "*.fastq" > $RNALIST

export TODO="files_todo"

if [ -e $TODO ]; then
    rm $TODO
fi

while read FASTQ; do
    
    if [ ! -e "$DNA_DIR/$(basename $FASTQ .fastq)_fastqc.html" ]; then
        echo $FASTQ >> $TODO
    fi

done < $DNALIST

while read FASTQ; do
    
    if [ ! -e "$RNA_DIR/$(basename $FASTQ .fastq)_fastqc.html" ]; then
        echo $FASTQ >> $TODO
    fi

done < $RNALIST

NUM_FILES=$(lc $TODO)

echo Found \"$NUM_FILES\" files in \"$PRJ_DIR\" to work on

JOB=$(qsub -J 1-$NUM_FILES:$STEP_SIZE -V -N fastqc -j oe -o "$STDOUT_DIR" $WORKER_DIR/fastqc.sh)

if [ $? -eq 0 ]; then
  echo Submitted job \"$JOB\" for you in steps of \"$STEP_SIZE.\" Remember: The golden rule is for non-satanists only.
else
  echo -e "\nError submitting job\n$JOB\n"
fi

