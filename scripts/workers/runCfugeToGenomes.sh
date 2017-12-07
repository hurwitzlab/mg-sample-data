#!/usr/bin/env bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l place=free:shared
#PBS -l select=1:ncpus=1:mem=1gb
#PBS -l walltime=12:00:00
#PBS -l cput=12:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea

unset module
set -u

cd $PBS_O_WORKDIR

if [[ -e $SCRIPT_DIR/config.sh ]]; then
    source $SCRIPT_DIR/config.sh
else
    echo no source file...quitting
    exit 1
fi

echo Host \"$(hostname)\"

echo Started $(date)

cd $GENOME_DIR

for REPORT in $(cat $TODO); do

    echo Working on report $REPORT

    python $WORKER_DIR/cfuge_report_to_genome.py -r $REPORT

done

echo Done at $(date)
