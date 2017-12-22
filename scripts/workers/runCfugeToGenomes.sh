#!/usr/bin/env bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l place=free:shared
#PBS -l select=1:ncpus=1:mem=1gb
#PBS -l walltime=12:00:00
#PBS -l cput=12:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea

module load singularity
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

mkdir -p $GENOME_DIR

cd $GENOME_DIR

#for REPORT in $(cat $TODO); do
#
#    echo Working on report $REPORT
#
#    python $WORKER_DIR/cfuge_report_to_genome.py -r $REPORT
#    
#    echo Unzipping gotten fastas and gffs
#
#    find ./ -iname "*.gz" | xargs -I file gunzip file
#
#done

#Not using the python script anymore
#Patric apparently has better function annotation of the refseq gffs!

export p3="singularity exec $SING_IMG/p3-tools.img"

for REPORT in $(cat $TODO); do

    echo Working on report $REPORT

    mkdir $(basename $REPORT)
    cd $(basename $REPORT)

    TEMPFILE=$(mktemp)

    python $WORKER_DIR/cfuge_report_filter.py -r $REPORT > $TEMPFILE

    while read LINE; do
       
        taxon_id=$(echo $LINE | cut -f 1 -d ';')
        name=$(echo $LINE | cut -f 2 -d ';')

        echo "Taxon ID is $taxon_id"
        echo "Species is $name"

#not using -e species,"$name" 
        while read patricID; do 

            echo "Getting PATRIC genome_id $patricID in fasta and Refseq gff formats"

            wget -nc -nd -r --no-parent -A '*.fna' \
                ftp://ftp.patricbrc.org/patric2/patric3/genomes/"$patricID"
            
            wget -nc -nd -r --no-parent -A '*.RefSeq.gff' \
                ftp://ftp.patricbrc.org/patric2/patric3/genomes/"$patricID"

            if [[ ! -e "$patricID".RefSeq.gff ]]; then
                
                wget -nc -nd -r --no-parent -A '*.PATRIC.gff' \
                    ftp://ftp.patricbrc.org/patric2/patric3/genomes/"$patricID"

            fi

        done < $($p3 p3-all-genomes -e taxon_id,"$taxon_id" -e genome_status,"Complete" | egrep -v "genome")

    done < $TEMPFILE

done

echo Done at $(date)
