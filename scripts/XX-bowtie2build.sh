#!/usr/bin/env bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=1:ncpus=2:mem=4gb
#PBS -l walltime=00:10:00
#PBS -l cput=00:10:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m ea
#PBS -j oe

# need a script to cat all the genomes i think
# something like:
# find ./$GENOME_DIR -iname *.fna -print0 | xargs -I file -0 cat file > $TMP/bigun.fna
# split $TMP/bigun > ./ into like 4GB pieces with destination being bowtie2index dir
# make list of fna's to index in $bowtie2index_dir
# have check for *.bt2 to see if completed (for restarting)
# then spawn a pbs job for each *.fna to index
# tada!

set -u

cd $PBS_O_WORKDIR

CONFIG="./config.sh"

if [ -e $CONFIG ]; then
    . "$CONFIG"
else
    echo Missing config \"$CONFIG\" ermagod!
    exit 12345
fi

cd $BT2_DIR

for file in $(ls $BT2_DIR); do
    bowtie2-build $file $file
done

echo done $(date)

#Usage: bowtie2-build [options]* <reference_in> <bt2_index_base>
#    reference_in            comma-separated list of files with ref sequences
#    bt2_index_base          write bt2 data to files with this dir/basename
#*** Bowtie 2 indexes work only with v2 (not v1).  Likewise for v1 indexes. ***
#Options:
#    -f                      reference files are Fasta (default)
#    -c                      reference sequences given on cmd line (as
#                            <reference_in>)
#    --large-index           force generated index to be 'large', even if ref
#                            has fewer than 4 billion nucleotides
#    -a/--noauto             disable automatic -p/--bmax/--dcv memory-fitting
#    -p/--packed             use packed strings internally; slower, less memory
#    --bmax <int>            max bucket sz for blockwise suffix-array builder
#    --bmaxdivn <int>        max bucket sz as divisor of ref len (default: 4)
#    --dcv <int>             diff-cover period for blockwise (default: 1024)
#    --nodc                  disable diff-cover (algorithm becomes quadratic)
#    -r/--noref              don't build .3/.4 index files
#    -3/--justref            just build .3/.4 index files
#    -o/--offrate <int>      SA is sampled every 2^<int> BWT chars (default: 5)
#    -t/--ftabchars <int>    # of chars consumed in initial lookup (default: 10)
#    --seed <int>            seed for random number generator
#    -q/--quiet              verbose output (for debugging)
#    -h/--help               print detailed description of tool and its options
#    --usage                 print this usage message
#    --version               print version information and quit
