#Config.sh contains commonly used directories
#and functions if you need them
#main project directory and also where singularity images bind /work to
export BIND="/rsgrps/bhurwitz/scottdaniel/mg-sample-data"
export PRJ_DIR=$BIND

#scripts and such
export SCRIPT_DIR="$PRJ_DIR/scripts"
export WORKER_DIR="$SCRIPT_DIR/workers"


export SAMPLE_NAMES="cancer control"

# place to put temp stuff like lists of files
export MY_TEMP_DIR="$PRJ_DIR/lists_of_files"

#Centrifuge Database Name ... up to but not including the ".1.cf"
export CENT_DB="/rsgrps/bhurwitz/hurwitzlab/data/reference/cent_db/uncompressed/p+h+v"
export DB=$(basename $CENT_DB)

#what the name of the singularity centdb would be
export SING_CENT="/centdb"

#singularity images to run programs
export SING_IMG="/rsgrps/bhurwitz/scottdaniel/singularity-images"
#singularity directories subject to change
#common to all
export SING_WD="/work"
#in taxoner.img and bowcuff.img
export SING_BT2="/bt2"
#in bowcuff.img for bowtie2 output
export SING_OUT="/out"
#in taxoner.img
export SING_META="/metadata"
export SING_PRJ="/scripts"

#dna and rna reads (this is also where reports and trimmed reads go)
export DNA_DIR="$PRJ_DIR/dna"
export RNA_DIR="$PRJ_DIR/rna"

#krona out dir
#export KRONA_OUT_DIR="$DNA_DIR/krona_out"

#NCBI_REFSEQ bacterial genomes
export GENOME_DIR="$PRJ_DIR/genomes"


#NCBI_REFSEQ annotation for genomes
#*NOTE*: putting gffs with the genomes for simplicity (since there are so few)
#export GFF_DIR="$PRJ_DIR/annotation/gff"
#export CDSTAB_DIR="$PRJ_DIR/annotation/cdsTab"

#NCBI_REFSEQ metadata (taxonomic lineage, genome_length, isolation_site, etc.)
#export META_DIR="$PRJ_DIR/metadata"

#NCBI_REFSEQ bowtie2 directory (for bowtie2 genome indices)
export BT2_DIR="$PRJ_DIR/bt2_index"
export GENOME="all.fa"
export GFF="allCDS.gff"
export RRNAGFF="rRNA.gff"

#bowtie2 output ALN = alignments
export ALN_DIR="$PRJ_DIR/alignments"

#export TESTFILE="/rsgrps/bhurwitz/scottdaniel/mg-sample-data/dna/cfuge/DNA_control_centrifuge_report.tsv"

###CENTRIFUGE STUFF####
#######################

#centrifuge directory
export CFUGE_DIR="$DNA_DIR/cfuge"

#Single or Paired End Reads? (single || paired)
#IMPORTANT: For paired end files see README.md for additional information
export TYPE="paired"

#FASTA/Q File Extension (common extensions include fasta, fa, fastq, fastq)
#DO NOT INCLUDE the dot "."
#examples : SRR1592394_1_val_1.fq.gz, SRR1592394_2_val_2.fq.gz
export FILE_EXT="fastq"

#Plot file name and title (No spaces, use _)
#export PLOT_FILE="HumanCRCbacteria"
#export PLOT_TITLE="HumanCRCbacteria"

#File type (Fasta or Fastq | fasta = f; fastq = q)
export FILE_TYPE="q"

#Exclude hits by stating taxid in following format ("taxid1,taxid2")
#9606 is human
#32630 are synthetic contructs (e.g. random illumina hexamer primer)
#374840 common contaminant = Enterobacteria phage phiX174 sensu lato
export EXCLUDE="9606,32630,374840"


#
#
# --------------------------------------------------
function init_dir {
    for dir in $*; do
        if [ -d "$dir" ]; then
            rm -rf $dir/*
        else
            mkdir -p "$dir"
        fi
    done
}

# --------------------------------------------------
function lc() {
    wc -l $1 | cut -d ' ' -f 1
}

# --------------------------------------------------
function get_lines() {
  FILE=$1
  OUT_FILE=$2
  START=${3:-1}
  STEP=${4:-1}

  if [ -z $FILE ]; then
    echo No input file
    exit 1
  fi

  if [ -z $OUT_FILE ]; then
    echo No output file
    exit 1
  fi

  if [[ ! -e $FILE ]]; then
    echo Bad file \"$FILE\"
    exit 1
  fi

  awk "NR==$START,NR==$(($START + $STEP - 1))" $FILE > $OUT_FILE
}
