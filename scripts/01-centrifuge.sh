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

STDOUT_DIR="$CWD/out/$PROG-"$(basename $SRA_DIR)""

init_dir "$STDOUT_DIR" 
mkdir -p $CFUGE_DIR
mkdir -p $PLOT_OUT

cd $SRA_DIR

set -u

export LIST="$SRA_DIR"/fq_clean_file_list

find $FIXED_DIR -iname "*_1_fixed.fq.gz" > $LIST

export TODO="$SRA_DIR"/cf_files_todo

if [ -e $TODO ]; then
    rm $TODO
fi

while read FASTQ; do
    
    if [ ! -e "$CFUGE_DIR/$(basename $FASTQ _1_fixed.fq.gz)-centrifuge_hits.tsv" ]; then
        echo $FASTQ >> $TODO
    fi

done < $LIST

NUM_FILES=$(lc $TODO)

echo Found \"$NUM_FILES\" files in \"$SRA_DIR\" to work on

JOB=$(qsub -J 1-$NUM_FILES:$STEP_SIZE -V -N cfuge -M scottdaniel@email.arizona.edu -j oe -o "$STDOUT_DIR" $WORKER_DIR/centrifuge_paired_tax.sh)

if [ $? -eq 0 ]; then
  echo Submitted job \"$JOB\" for you in steps of \"$STEP_SIZE.\" Remember: The golden rule is for non-satanists only.
else
  echo -e "\nError submitting job\n$JOB\n"
fi

