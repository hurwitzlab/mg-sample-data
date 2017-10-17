# mg-sample-data
## Sample data for a metagenomic / metatranscriptomic workflow.

*The dna / rna is mouse cecal matter that contains mouse, mouse chow and microbial nucleotide sequences*

## explanation of directories / files

* /dna

  Two samples of paired (R1,R2) 100bp reads (cancer and control)
  
* /rna

  Two samples of paired (R1,R2) 100bp reads (matched to dna)
  
* /scripts

  Sample scripts to be run with a PBS scheduling system on HPCs/HTCs
  
* /scripts/workers

  "Worker" scripts that are launch by jobs on HPCs/HTCs. Can be modified to run interactively.
