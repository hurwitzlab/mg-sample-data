#!/usr/bin/env bash

#
# This script is intended quantify reads using cuffquant from the tuxedo suite
#
#echo "Number of arguments is $#"
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
    export BAM_LIST="$MY_TEMP_DIR"/$sample-bam_todo

    find . -type f -regextype 'sed' -iregex "\.\/.*$sample.*bam" \
        > $BAM_LIST

    echo "Counting hits to genes in $sample sample"

	JOB=$(qsub -V -N cuffquant -j oe -o "$STDOUT_DIR" $WORKER_DIR/runCuffquant.sh)

    if [ $? -eq 0 ]; then
        echo "Submitted job \"$JOB\" for you.
        What the hell, go ahead and put all your eggs in one basket."
    else
        echo -e "\nError submitting job\n$JOB\n"
    fi

done

