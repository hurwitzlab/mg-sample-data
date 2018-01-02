#!/usr/bin/env bash

#script to cat all the genomes
#and then build a bowtie2-index from them for mapping

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

PROG=`basename $0 ".sh"`
#Just going to put stdout and stderr together into stdout
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR"

mkdir -p $BT2_DIR

echo Putting together all the fastas
find $GENOME_DIR -iname "*.fna" | xargs -I fasta cat fasta > $BT2_DIR/all.fa

echo Need to create a big gff file too
find $GENOME_DIR -iname "*.gff" | xargs -I gff cat gff > $BT2_DIR/gfftemp
grep -P "\tCDS\t" $BT2_DIR/gfftemp | sort -u > $BT2_DIR/allCDS.gff 
grep -P "\trRNA\t" $BT2_DIR/gfftemp | sort -u > $BT2_DIR/rRNA.gff #added sort -u because apparently there are duplicates
rm $BT2_DIR/gfftemp

JOB=$(qsub -V -N bowtie2-build -j oe -o "$STDOUT_DIR" $WORKER_DIR/run-bowtie2-build.sh)

if [ $? -eq 0 ]; then
    echo Submitted job \"$JOB\" for you. Weeeeeeeeeeeee!
else
    echo -e "\nError submitting job\n$JOB\n"
fi

