#!/usr/bin/env bash

#
# This script is intended to make bams from sams and then sort
#

unset module
source ./config.sh

CWD=$(pwd)
PROG=`basename $0 ".sh"`
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR"

mkdir -p $MY_TEMP_DIR

cd $ALN_DIR

for sample in $SAMPLE_NAMES; do

    export SAMPLE=$sample
    export SAM_LIST="$MY_TEMP_DIR"/$sample-sam_todo

    find . -type f -regextype 'sed' -iregex "\.\/.*$sample.*sam" \
        > $SAM_LIST

    echo "Converting $sample sam(s) to bam format"

	JOB=$(qsub -V -N samtools -j oe -o "$STDOUT_DIR" $WORKER_DIR/make-bams.sh)

    if [ $? -eq 0 ]; then
        echo Submitted job \"$JOB\" for you. What me worry?
    else
        echo -e "\nError submitting job\n$JOB\n"
    fi

done

