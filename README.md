A typical TRegGA workflow involves:

- read, reference, and target preparation

- assembly (*de novo* and reference-guided)

These steps are documented in the aptly named sub-directories:

- `reads/`: contains NGS reads to be assembled; see reads/0README
   and instructions in ../TRegGA/reads

- `reference/`: contains subdirectories `rice_indica` and `rice_japonica`, with
  documented sequence retrieval and processing

- `targets/`: contains target sequences derived; typically, these targets would
  be derived from reference sequences by specifying a particular region (and
  transferring the annotation to the new coordinate system)

- `assembly/denovo/`: SOAPdenovo2 assemblies of reads to contigs and scaffolds,
  optionally gap-filled with GapFiller

- `assembly/rfguided/`: reference-guided assemblies of reads using the specified
  target as a template; this step involves AlignGraph, ABACAS, GapFiller, and
  RATT
