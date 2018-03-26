#!/usr/bin/env bash
#
# Script to run centrifuge 
#

set -u

CONFIG="./config.sh"

if [ -e $CONFIG ]; then
    . "$CONFIG"
else
    echo Missing config \"$CONFIG\" ermagod!
    exit 12345
fi

mkdir -p $MY_TEMP_DIR
export CWD="$PWD"
export STEP_SIZE=10

PROG=`basename $0 ".sh"`
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR" 

cd $PRJ_DIR

export LEFT_FILES_LIST="$MY_TEMP_DIR/sorted_left_fastqs"
export RIGHT_FILES_LIST="$MY_TEMP_DIR/sorted_right_fastqs"

echo "Finding fastq's"

find $DNA_DIR -type f -iname \*R1*fastq | sed "s/^\.\///" | sort > $LEFT_FILES_LIST 
find $DNA_DIR -type f -iname \*R2*fastq | sed "s/^\.\///" | sort > $RIGHT_FILES_LIST 

echo "Checking if already processed"

if [ -e $MY_TEMP_DIR/files-to-process ]; then
    rm $MY_TEMP_DIR/files-to-process
fi

export FILES_TO_PROCESS="$MY_TEMP_DIR/files-to-process"


#for FASTA in $(cat $LIST); do
#
#    if [ ! -e ""$FASTA".rev.2.bt2" ]; then
#        echo $FASTA >> $TODO
#    fi
#
#done

cat $LEFT_FILES_LIST >> $FILES_TO_PROCESS

NUM_FILES=$(lc $FILES_TO_PROCESS)

echo Found \"$NUM_FILES\" files in \"$DNA_DIR\" to work on

JOB=$(qsub -J 1-$NUM_FILES:$STEP_SIZE -V -N centrifuge -j oe -o "$STDOUT_DIR" $WORKER_DIR/centrifuge_paired_tax.sh)

if [ $? -eq 0 ]; then
  echo -e "Submitted job \"$JOB\" for you in steps of \"$STEP_SIZE.\"
  There's no such thing as bad language. I don't believe that any more. That's
  ridiculous. They call it a "debasing of the language?" No! We are adults.
  These are the words that WE use, to express frustration, rage, anger―in
  order that we don't pick up a tire iron and beat the shit out of someone.
          ― Lewis Black"
else
  echo -e "\nError submitting job\n$JOB\n"
fi
echo done $(date)

