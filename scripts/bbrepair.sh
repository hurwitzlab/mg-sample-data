#!/usr/bin/env bash
#
# runs bbmap to fix read pairs from SRA
# because SRA sucks
#

set -u
source ./config.sh
export CWD="$PWD"
#batches of N
export STEP_SIZE=2

PROG=`basename $0 ".sh"`
STDOUT_DIR="$CWD/out/$PROG-"$(basename $SRA_DIR)""

init_dir "$STDOUT_DIR" 

cd $SRA_DIR

set -u

export LIST="$SRA_DIR"/fastq_file_list

find ./ -iname "*_1.fastq.gz" > $LIST

export TODO="$SRA_DIR"/repair_files_todo

if [ -e $TODO ]; then
    rm $TODO
fi

mkdir -p $FIXED_DIR

while read FASTQ; do
    
    if [ ! -e "$FIXED_DIR/$(basename $FASTQ .fastq.gz)_fixed.fq.gz" ]; then
        echo $FASTQ >> $TODO
    fi

done < $LIST

NUM_FILES=$(lc $TODO)

echo Found \"$NUM_FILES\" files in \"$SRA_DIR\" to work on

JOB=$(qsub -J 1-$NUM_FILES:$STEP_SIZE -V -N bbrepair -j oe -o "$STDOUT_DIR" $WORKER_DIR/runBBrepair.sh)

if [ $? -eq 0 ]; then
  echo "Submitted job \"$JOB\" for you in steps of \"$STEP_SIZE\"
  Discovery consists in seeing what everyone else has seen and thinking what no
  one else has thought.
          ― Albert Szent-Gyorgi"
else
  echo -e "\nError submitting job\n$JOB\n"
fi

