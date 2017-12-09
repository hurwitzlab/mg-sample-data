#!/usr/bin/env bash

#script to extract the gzipped gbff's and then get gff and fasta from them

unset module
set -u
export CWD="$PWD"
CONFIG="./config.sh"

if [ -e $CONFIG ]; then
    . "$CONFIG"
else
    echo MIssing config \"$CONFIG\"
    exit 12385
fi

mkdir -p $TEMP_DIR
PROG=`basename $0 ".sh"`
#Just going to put stdout and stderr together into stdout
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR"

export TODO="$TEMP_DIR/gbff_todo"

find $GENOME_DIR -iname "*.gbff.gz" > $TODO

JOB=$(qsub -V -N extract -j oe -o "$STDOUT_DIR" $WORKER_DIR/runExtract.sh)

if [ $? -eq 0 ]; then
    echo Submitted job \"$JOB\" for you. Weeeeeeeeeeeee!
else
    echo -e "\nError submitting job\n$JOB\n"
fi

