#!/usr/bin/env bash

#
#This script is intended to take taxonomy.txt from each alignment, cat by sample
#and then simplify the text for easier processing (just have read_id,
#taxon_id, unique_id and score)
#

unset module
set -u
source ./config.sh
export CWD="$PWD"

echo Setting up log files...
PROG=`basename $0 ".sh"`
#Just going to put stdout and stderr together into stdout
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR"

echo Making output dir...
if [ ! -d $KRONA_OUT_DIR ]; then
    mkdir -p $KRONA_OUT_DIR
fi

export SAMPLE_LIST="$PRJ_DIR/sample_list"

echo \
"DNA_cancer
DNA_control" > $SAMPLE_LIST

while read SAMPLE; do
    echo "Doing "$SAMPLE" taxonomy file"

    export SAMPLE=$SAMPLE

    qsub -V -j oe -o "$STDOUT_DIR" $WORKER_DIR/fix_taxonomy.sh

done < $SAMPLE_LIST
