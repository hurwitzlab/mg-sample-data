#!/usr/bin/env bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l place=free:shared
#PBS -l select=1:ncpus=30:mem=1234gb:pcmem=42gb
#PBS -l walltime=24:00:00
#PBS -l cput=720:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m ea
#PBS -j oe

#
# runs repair.sh from bbtools to reconjigger crappily interleaved reads 
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

cd $SRA_DIR

echo Host \"$(hostname)\"

echo Started $(date)

TMP_FILES=$(mktemp)

get_lines $TODO $TMP_FILES $PBS_ARRAY_INDEX $STEP_SIZE

NUM_FILES=$(lc $TMP_FILES)

if [[ $NUM_FILES -lt 1 ]]; then
    echo Something went wrong or no files to process
    exit 1
else
    echo Found \"$NUM_FILES\" files to process
fi

cd $FIXED_DIR

export bbrepair="singularity exec \
    -B $SRA_DIR:$SING_WD -H $FIXED_DIR:$HOME \
    $SING_IMG/bbtools.img repair.sh" 

#-Xmx150g option for those large memory files

echo "Running repair.sh on dna"
for file in $(cat $TMP_FILES); do
    BASE=$(basename $file _1.fastq.gz)
    R1=$SING_WD/"$BASE"_1.fastq.gz
    R2=$SING_WD/"$BASE"_2.fastq.gz
    $bbrepair -Xmx1234g in=$R1 in2=$R2 \
        out=./"$BASE"_1_fixed.fq.gz \
        out2=./"$BASE"_2_fixed.fq.gz \
        outs=./"$BASE"_orphans.fq.gz
done

echo Finished $(date)
#
#singularity exec bbtools.img repair.sh -h
#
#Written by Brian Bushnell
#Last modified November 9, 2016
#
#Description:  Re-pairs reads that became disordered or had some mates eliminated.
#Please read bbmap/docs/guides/RepairGuide.txt for more information.
#
#Usage:  repair.sh in=<input file> out=<pair output> outs=<singleton output>
#
#Input may be fasta, fastq, or sam, compressed or uncompressed.
#
#Parameters:
#in=<file>       The 'in=' flag is needed if the input file is not the first
#                parameter.  'in=stdin' will pipe from standard in.
#in2=<file>      Use this if 2nd read of pairs are in a different file.
#out=<file>      The 'out=' flag is needed if the output file is not the second
#                parameter.  'out=stdout' will pipe to standard out.
#out2=<file>     Use this to write 2nd read of pairs to a different file.
#outs=<file>     (outsingle) Write singleton reads here.
#overwrite=t     (ow) Set to false to force the program to abort rather than
#                overwrite an existing file.
#showspeed=t     (ss) Set to 'f' to suppress display of processing speed.
#ziplevel=2      (zl) Set to 1 (lowest) through 9 (max) to change compression
#                level; lower compression is faster.
#fint=f          (fixinterleaving) Fixes corrupted interleaved files using read
#                names.  Only use on files with broken interleaving - correctly
#                interleaved files from which some reads were removed.
#repair=t        (rp) Fixes arbitrarily corrupted paired reads by using read
#                names.  Uses much more memory than 'fint' mode.
#ain=f           (allowidenticalnames) When detecting pair names, allows
#                identical names, instead of requiring /1 and /2 or 1: and 2:
#
#Java Parameters:
#-Xmx            This will be passed to Java to set memory usage, overriding the program's automatic memory detection.
#                -Xmx20g will specify 20 gigs of RAM, and -Xmx200m will specify 200 megs.  The max is typically 85% of physical memory.
#-eoom           This flag will cause the process to exit if an out-of-memory exception occurs.  Requires Java 8u92+.
#-da             Disable assertions.
#
#Please contact Brian Bushnell at bbushnell@lbl.gov if you encounter any problems.
