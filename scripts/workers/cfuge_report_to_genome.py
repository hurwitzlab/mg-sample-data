#!/usr/bin/env python

#script that takes a centrifuge report and downloads genomes from ncbi whose abundance's are higher than 0
from __future__ import print_function #python3 style printing
import sys
import argparse
import os
import errno
#import ncbi_genome_download as ngd
#using plumbum instead of ncbi_genome_download
#to just call the script
from plumbum import local
import pandas as pd

ngd = local["ncbi-genome-download"]

if __name__ == "__main__":
    parser = \
    argparse.ArgumentParser(description="Script to download specific genomes based on centrifuge report")
    
    parser.add_argument("-r", "--report", action="store", \
            help="Centrifuge report file, usually: centrifue_report.tsv")
        
    args = vars(parser.parse_args())

report = pd.read_table(args['report'],delimiter='\t')

for row in report.itertuples(index=True, name='Pandas'):
    if getattr(row, 'abundance') > 0:
        print("Downloading {:s} taxid {:d}".format(\
                getattr(row, 'name'), getattr(row, 'taxID')))
        ngd("--human-readable","--taxid",getattr(row, 'taxID'),"bacteria")
#        ngd.download(group='bacteria',taxid=getattr(row, 'taxID'), \
#                human_readable=True)

