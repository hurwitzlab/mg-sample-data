#!/usr/bin/env bash
#
# Script to run taxoner64
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

if [[ -d "$TAXONER_DIR" ]]; then
    echo "Continuing where you left off..."
else
    mkdir -p "$TAXONER_DIR"
fi

cd $DNA_DIR

export LIST="$PRJ_DIR/fa_list"

find ./ -type f -iname "*val_1.fq" | sed "s/^\.\///" | sort > $LIST

export TODO="$PRJ_DIR/files_todo"

if [ -e $TODO ]; then
    rm $TODO
fi

while read FASTQ; do

    OUT_DIR=$TAXONER_DIR/$FASTQ

    if [[ -d $OUT_DIR ]]; then
        if [[ -z $(find $OUT_DIR -iname Taxonomy.txt) ]]; then
            echo $FASTQ >> $TODO
        else
            echo "Output for $FASTQ already exists"
            continue
        fi
    else
        echo $FASTQ >> $TODO
    fi

done < $LIST

NUM_FILES=$(lc $TODO)

echo Found \"$NUM_FILES\" files in \"$DNA_DIR\" to work on

JOB=$(qsub -J 1-$NUM_FILES:$STEP_SIZE -V -N taxoner64 -j oe -o "$STDOUT_DIR" $WORKER_DIR/runTaxoner.sh)

if [ $? -eq 0 ]; then
  echo "Submitted job \"$JOB\" for you in steps of \"$STEP_SIZE.\"
  Deprive a mirror of its silver, and even the Czar won't see his face." 
else
  echo -e "\nError submitting job\n$JOB\n"
fi
echo done $(date)

