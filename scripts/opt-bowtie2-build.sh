#!/usr/bin/env bash
#
# Script to build those bowtie2 indices
#

set -u

CONFIG="./config.sh"

if [ -e $CONFIG ]; then
    . "$CONFIG"
else
    echo Missing config \"$CONFIG\" ermagod!
    exit 12345
fi

export CWD="$PWD"
export STEP_SIZE=1

PROG=`basename $0 ".sh"`
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR" 

cd $PRJ_DIR

export LIST="fna_list"

find $BT2_DIR -iname "*.fasta" > $LIST

export TODO="files_todo"

if [ -e $TODO ]; then
    rm $TODO
fi

for FASTA in $(cat $LIST); do

    if [ ! -e ""$FASTA".rev.2.bt2" ]; then
        echo $FASTA >> $TODO
    fi

done

NUM_FILES=$(lc $TODO)

echo Found \"$NUM_FILES\" files in \"$BT2_DIR\" to work on

if [ $NUM_FILES -eq 1 ]; then
    JOB=$(qsub -V -N bowtie2build -j oe -o "$STDOUT_DIR" $WORKER_DIR/bowtie2-build-single.sh)
else
    JOB=$(qsub -J 1-$NUM_FILES:$STEP_SIZE -V -N bowtie2build -j oe -o "$STDOUT_DIR" $WORKER_DIR/bowtie2-build.sh)
fi

if [ $? -eq 0 ]; then
  echo -e "Submitted job \"$JOB\" for you in steps of \"$STEP_SIZE.\"
  It is inhumane, in my opinion, to force people who have a genuine medical
  need for coffee to wait in line behind people who apparently view it as
  some kind of recreational activity.
  ― Dave Barry"
else
  echo -e "\nError submitting job\n$JOB\n"
fi
echo done $(date)

