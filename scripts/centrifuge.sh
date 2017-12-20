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
export STEP_SIZE=1

PROG=`basename $0 ".sh"`
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR" 

cd $PRJ_DIR

export DNALIST="$MY_TEMP_DIR/fna_list"

find $DNA_DIR -iname "*R1.fastq" > $DNALIST

export TODO="$MY_TEMP_DIR/files_todo"

if [ -e $TODO ]; then
    rm $TODO
fi
#
#for FASTA in $(cat $LIST); do
#
#    if [ ! -e ""$FASTA".rev.2.bt2" ]; then
#        echo $FASTA >> $TODO
#    fi
#
#done

cat $DNALIST >> $TODO

NUM_FILES=$(lc $TODO)

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

