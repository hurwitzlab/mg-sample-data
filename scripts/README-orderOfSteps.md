# Order of operations
## Can pre-pend script names to 00, 01, etc. once finalized

* centrifuge.sh
* get-genomes.sh

* quick-rename-and-move.pbs
    * move "centrifuge_reports.tsv" to local directory
    * interactive_centrifuge_bubble.R
* get-read-from-cf.sh (optional, only needed if you need *specific* reads)
* cat-fastqs.sh (need to smash all the fastqs together before running deduplication, etc.)
* bbrepair.sh (to split back into /1 /2 and singletons)
* bbdedupe.sh
* khmer-count.sh
* khmer-trim.sh
* ~~~khmer-extract.pbs~~~
* bbrepair2.sh
* megahit.sh
* metaquest.sh? (or maybe metaquast after virsorter.pbs?)
* virsorter.sh? (or maybe do this via the cyVerse discovery environment?)
