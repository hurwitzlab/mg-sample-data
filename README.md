# mg-sample-data
## Sample data for a metagenomic / metatranscriptomic workflow.

*The dna / rna is mouse cecal matter that contains mouse, mouse chow and microbial nucleotide sequences*

*The genomes and annotation are from [Patric](https://www.patricbrc.org/)*

## explanation of directories / files

* /dna

  Two samples of 2500 paired (R1,R2) 100bp reads (cancer and control)
  
* /rna

  Two samples of 2500 paired (R1,R2) 100bp reads (matched to dna)
  
* /annotation

  Annotation from Patric in tab-delimited and gff formats
  
* /genomes

  Two bacterial reference genomes from Patric
  
* /metadata
 
  Metadata of genomes including their taxonomic lineage
  
* /scripts

  Sample scripts to run on PBS scheduling system

* /scripts/workers

  "Worker" scripts that are launched by the jobs running on the HPC/HTC
  Can be modified to run interactively if needed
