#!/usr/bin/env bash

#
# This script is intended to run cuffnorm
#
unset module
source ./config.sh

CWD=$(pwd)
PROG=`basename $0 ".sh"`
STDOUT_DIR="$CWD/out/$PROG"

init_dir "$STDOUT_DIR"

mkdir -p $MY_TEMP_DIR

cd $ALN_DIR

export CXB_LIST="$MY_TEMP_DIR"/$sample-cxb_todo

find . -type f -regextype 'sed' -iregex "\.\/.*cxb" \
    > $CXB_LIST

sed -i "s-\.-$SING_WD-" $CXB_LIST

echo "Normalizing hits to \"real\" counts"

JOB=$(qsub -V -N cuffnorm -j oe -o "$STDOUT_DIR" $WORKER_DIR/runCuffnorm.sh)

if [ $? -eq 0 ]; then
    echo "Submitted job \"$JOB\" for you.
    What the hell, go ahead and put all your eggs in one basket."
else
    echo -e "\nError submitting job\n$JOB\n"
fi
