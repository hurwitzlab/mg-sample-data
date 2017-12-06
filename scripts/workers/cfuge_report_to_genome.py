#!/usr/bin/env python

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l place=free:shared
#PBS -l select=1:ncpus=1:mem=1gb
#PBS -l walltime=2:00:00
#PBS -l cput=2:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea

import ncbi_genome_download as ngd
import pandas as pd
from plumbum import local

#WIP

#TODO: stuff

report = pd.read_table('DNA_cancer_centrifuge_report.tsv',delimiter='\t')


for row in report.itertuples(index=True, name='Pandas'):
    if getattr(row, 'abundance') > 0:
        print getattr(row, 'taxID')

#example ncbi_genome_download
ngd.download(group='bacteria',taxid='235279',human_readable=True)
