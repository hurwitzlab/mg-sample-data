#Config.sh contains commonly used directories
#and functions if you need them

#singularity images to run programs
export SING_IMG="/rsgrps/bhurwitz/scottdaniel/singularity-images"

#main project directory and also where singularity images bind /work to
export BIND="/rsgrps/bhurwitz/scottdaniel/mg-sample-data"
export PRJ_DIR=$BIND

#dna and rna reads
export DNA_DIR="$PRJ_DIR/dna"
export RNA_DIR="$PRJ_DIR/rna"

#PATRIC bacterial genomes
export GENOME_DIR="$PRJ_DIR/genomes"

#PATRIC annotation for genomes
export GFF_DIR="$PRJ_DIR/annotation/gff"
export CDSTAB_DIR="$PRJ_DIR/annotation/cdsTab"

#PATRIC metadata (taxonomic lineage, genome_length, isolation_site, etc.)
export META_DIR="$PRJ_DIR/metadata"

#PATRIC bowtie2 directory (for bowtie2 genome indices)
export BT2_DIR="$PRJ_DIR/bt2_indces"

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
