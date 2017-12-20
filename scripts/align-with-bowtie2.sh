#!/usr/bin/env bash

#script to align rna reads to bowtie2 index $BT2_DIR/all.fa

unset module
source ./config.sh

CWD=$(pwd)
PROG=`basename $0 ".sh"`
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR"

mkdir -p $MY_TEMP_DIR

cd $RNA_DIR

for sample in $SAMPLE_NAMES; do

    export SAMPLE=$sample
    export FASTQ_LIST="$MY_TEMP_DIR"/$sample-fastq_todo
    export BT2="$BT2_DIR"/all
    export OUT="$ALN_DIR/$sample"

    mkdir -p $OUT

    find . -type f -regextype 'sed' -iregex "\.\/.*$sample.*R1.fastq" \
        > $FASTQ_LIST

    echo "Mapping $sample Fastq(s) to $BT2"

	JOB=$(qsub -V -N bowtie2map -j oe -o "$STDOUT_DIR" $WORKER_DIR/run-bowtie2.sh)

    if [ $? -eq 0 ]; then
        echo Submitted job \"$JOB\" for you. Weeeeeeeeeeeee!
    else
        echo -e "\nError submitting job\n$JOB\n"
    fi

done

