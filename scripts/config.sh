#Config.sh contains commonly used directories
#and functions if you need them

#sample genomes included in this:
#patric_id  genome-(genus.species)
#435591.13  parabacteroides.distasonis
#511145.12 escheria.coli str. K-12 substr. MG1655 (basically the most studied bacterium ever)
#1379858.3  mucispirillum.schaedleri
#1590.75 lactobacillus.plantarum 90sk
#397291.3 lachnospiraceae.bacterium A4

export patric_ids=('435591.13' '511145.12' '1379858.3' '1590.75' '397291.3') 

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

#krona out dir
export KRONA_OUT_DIR="$DNA_DIR/krona_out"

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
