#!/usr/bin/python

import sys
from Bio import SeqIO

infile = sys.argv[1]
slabel = sys.argv[2]
frompos = sys.argv[3]
topos = sys.argv[4]

record = SeqIO.read(infile, "embl")
sub_record = record[int(frompos):int(topos)]

SeqIO.write(sub_record, slabel + ".embl", "embl")
SeqIO.write(sub_record, slabel + ".fasta", "fasta")
