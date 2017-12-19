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

module load singularity

for FILE in $(cat $TODO); do

    echo Working on report $(basename $FILE)
    #ex: /rsgrps/bhurwitz/scottdaniel/mg-sample-data/genomes/refseq/bacteria/GCF_002221665.1/GCF_002221665.1_ASM222166v1_genomic.gbff.gz

    DIR=$(dirname $FILE)
    BASE=$(basename $FILE .gbff.gz)

    togff="singularity exec \
        -B $DIR:$SING_WD \
        $SING_IMG/pythonFaves.img to-gff"

    gunzip $FILE

    $togff --getfasta $SING_WD/$BASE.gbff $SING_WD/$BASE.gff

done

echo Done at $(date)
#
#$ to-gff -h
#usage: to-gff [-h] [-v] [--embl] [--getfasta] in_file out_file
#
#to_gff v0.1 - Generate gff file from EMBL/Genbank for QUAST
#(http://github.com/mscook/to_gff)
#
#positional arguments:
#  in_file        Full path to the input .embl/.gbk
#  out_file       Full path to the output GFF
#
#optional arguments:
#  -h, --help     show this help message and exit
#  -v, --verbose  verbose output
#  --embl         Whether we have an EMBL or GenBank (default)
#  --getfasta     Get a FASTA file (default = no)
#
#Licence: ECL 2.0 by Mitchell Stanton-Cook <m.stantoncook@gmail.com>
