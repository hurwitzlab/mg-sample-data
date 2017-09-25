#!/usr/bin/env bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=1:ncpus=2:mem=12gb
#PBS -l walltime=00:30:00
#PBS -l cput=00:30:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m ea
#PBS -j oe

#
# runs bowtie2-build 
#

# --------------------------------------------------
# singularity is needed to run singularity images
module load singularity
# --------------------------------------------------

unset module
set -u

COMMON="$WORKER_DIR/common.sh"

if [ -e $COMMON ]; then
  . "$COMMON"
else
  echo Missing common \"$COMMON\"
  exit 1
fi

cd $PRJ_DIR

echo Host \"$(hostname)\"

echo Started $(date)

NUM_FILES=$(lc $TODO)

if [[ $NUM_FILES -lt 1 ]]; then
    echo Something went wrong or no files to process
    exit 1
else
    echo Found \"$NUM_FILES\" files to process
fi

export bt2build="singularity exec \
    -B $BT2_DIR:$SING_WD \
    $SING_IMG/bowcuff.img bowtie2-build" 

cd $BT2_DIR

echo "Running bowti2-build from within the singularity container"

for file in $(cat $PRJ_DIR/$TODO); do
    BASE=$(basename $file)
    $bt2build $SING_WD/$BASE $SING_WD/$BASE
done

echo Finished $(date)


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
