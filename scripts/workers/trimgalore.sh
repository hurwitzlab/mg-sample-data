#!/usr/bin/env bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=1:ncpus=2:mem=4gb
#PBS -l walltime=24:00:00
#PBS -l cput=24:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m ea
#PBS -j oe

#
# runs singularity fastqc.img trim_galore to trim adapters and low quality bases
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

TMP_FILES=$(mktemp)

get_lines $TODO $TMP_FILES $PBS_ARRAY_INDEX $STEP_SIZE

NUM_FILES=$(lc $TMP_FILES)

if [[ $NUM_FILES -lt 1 ]]; then
    echo Something went wrong or no files to process
    exit 1
else
    echo Found \"$NUM_FILES\" files to process
fi

export trim_galore="singularity exec \
    -B $PRJ_DIR:$SING_WD \
    $SING_IMG/fastqc.img trim_galore" 

echo "Running trim_galore on dna files, if any"
for file in $(cat $TMP_FILES | grep "dna"); do
    OUT_DIR=$SING_WD/dna
    R1=$(basename $file)
    R2=$(basename $file R1.fastq)R2.fastq
    $trim_galore --paired --fastqc_args "-o $OUT_DIR" \
        -o $OUT_DIR $SING_WD/dna/$R1 $SING_WD/dna/$R2 
done

echo "Running trim_galore on rna files, if any"
for file in $(cat $TMP_FILES | grep "rna"); do
    OUT_DIR=$SING_WD/rna
    R1=$(basename $file)
    R2=$(basename $file R1.fastq)R2.fastq
    $trim_galore --paired --fastqc_args "-o $OUT_DIR" \
        -o $OUT_DIR $SING_WD/rna/$R1 $SING_WD/rna/$R2 
done

echo Finished $(date)

#EXampel:
#singularity exec -B $BIND:$SING_WD /rsgrps/bhurwitz/scottdaniel/singularity-images/fastqc.img trim_galore --paired --fastqc -o $SING_WD/dna $SING_WD/dna/DNA_cancer_R1.fastq $SING_WD/dna/DA_cancer_R2.fastq

#see https://github.com/FelixKrueger/TrimGalore/blob/master/Docs/Trim_Galore_User_Guide.md for full guide on trim_galore
