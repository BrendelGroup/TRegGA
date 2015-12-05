# TRegGA: Targeted Reference-guided Genome Assembly for Comparative Rice Genomics

TRegGA is a fully automated workflow designed for locus-scale analysis of rice genomes, especially those sequenced in the [3k Rice Genomes Project (3kRGP)](http://gigadb.org/dataset/200001).
It is free open-source software, and utilizes a variety of third-party software for retrieving, processing, and annotating genome data.
TRegGA offers a richer view of rice genome variation than SNP databases, as it uses genome assembly to capture the entire genomic context in a way that cannot be done with mapping against a reference.

## Getting Started

See **[INSTALL.md](INSTALL.md)** for a detailed installation manual.
Once TRegGA is configured and all software prerequisites are installed, complete the installation by executing `bash setup.sh` in your terminal.
This will download and preprare reference genomes and other ancillary data required by the TRegGA workflow.

We do not yet have a small automated test to verify that TRegGA is working properly.
In the mean time, see **[VIGNETTE.txt](VIGNETTE.txt)** for some examples that can be used for testing.

**Note**: TRegGA is not designed to run on a latop.
You'll want a machine with plenty of storage space and a fast Internet connection.

## Troubleshooting

If you have trouble installing or running TRegGA, feel free to open a ticket in our [issue tracker](https://github.com/BrendelGroup/TRegGA/issues).

## Synopsis

A typical TRegGA workflow involves the following.

- Illumina reads from a specific rice cultivar
- A reference genome (*indica* or *japonica*)
- A target locus of interest
- Assembly of the specified target in the given cultivar (*de novo* first, then reference-guided)

Data retrieval and workflow execution is implemented and documented in aptly named sub-directories.

- `reads/`: retrieval and storage of Illumina reads to be assembled;
  reads are retrieved for each cultivar as needed;
  see `reads/README.md`

- `reference/`: storage of reference genomes;
  contains subdirectories `rice_indica` and `rice_japonica`;
  data is retrieved and processed during the initial setup procedure

- `targets/`: storage of target sequences;
  typically, these targets would be derived from reference sequences by specifying a particular region (and transferring the annotation to the new coordinate system)

- `assembly/denovo/`: SOAPdenovo2 assemblies of reads to contigs and scaffolds, optionally gap-filled with GapFiller

- `assembly/rfguided/`: reference-guided assemblies of reads using the specified target as a template;
  this step involves AlignGraph, ABACAS, GapFiller, and RATT
