#!/usr/bin/env bash
#
# runs singularity fastqc.img trim_galore to trim adapters and low quality bases
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
cd $SRA_DIR

export LIST="fastq_file_list"

find ./ -iname "*_1.fastq.gz" > $LIST

export TODO="files_todo"

if [ -e $TODO ]; then
    rm $TODO
fi

while read FASTQ; do
    
    if [ ! -e "$TRIMMED_DIR/$(basename $FASTQ .fastq.gz)_val_1.fq" ]; then
        echo $FASTQ >> $TODO
    fi

done < $LIST

NUM_FILES=$(lc $TODO)

echo Found \"$NUM_FILES\" files in \"$SRA_DIR\" to work on

JOB=$(qsub -J 1-$NUM_FILES:$STEP_SIZE -V -N trimgalore -j oe -o "$STDOUT_DIR" $WORKER_DIR/trimgalore.sh)

if [ $? -eq 0 ]; then
  echo Submitted job \"$JOB\" for you in steps of \"$STEP_SIZE.\" grep me no patterns and I will tell you no lines.
else
  echo -e "\nError submitting job\n$JOB\n"
fi

