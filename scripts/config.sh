#Config.sh contains commonly used directories
#and functions if you need them

#singularity images to run programs
export SING_IMG="/rsgrps/bhurwitz/scottdaniel/singularity-images"
#singularity directories subject to change
#common to all
export SING_WD="/work"
#in taxoner.img and bowcuff.img
export SING_BT2="/bt2"
#in taxoner.img
export SING_META="/metadata"
export SING_PRJ="/scripts"

#main project directory and also where singularity images bind /work to
export BIND="/rsgrps/bhurwitz/scottdaniel/mg-sample-data"
export PRJ_DIR=$BIND

#scripts and such
export SCRIPT_DIR="$PRJ_DIR/scripts"
export WORKER_DIR="$SCRIPT_DIR/workers"

#dna and rna reads (this is also where reports and trimmed reads go)
export DNA_DIR="$PRJ_DIR/dna"
export RNA_DIR="$PRJ_DIR/rna"

#taxoner out dir
export TAXONER_DIR="$DNA_DIR/taxoner_out"

#Reference dir
export REF_DIR="/rsgrps/bhurwitz/hurwitzlab/data/reference"

#PATRIC bacterial genomes
export GENOME_DIR="$REF_DIR/patric_bacteria"

#PATRIC annotation for genomes
export GFF_DIR="$REF_DIR/patric_annot/gff"
export CDSTAB_DIR="$REF_DIR/patric_annot/cdsTab"

#PATRIC metadata (taxonomic lineage, genome_length, isolation_site, etc.)
export META_DIR="$REF_DIR/patric_metadata"

#PATRIC bowtie2 directory (for bowtie2 genome indices)
export BT2_DIR="$REF_DIR/patric_bowtie2_index"

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
