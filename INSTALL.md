# TRegGA Installation

## Obtaining TRegGA

Stable releases of TRegGA can be obtained from the [releases page](https://github.com/BrendelGroup/TRegGA/releases).
If you're feeling a little more adventurous, the latest and greatest development version of TRegGA is always accessible from the development repository on GitHub.

```
git clone https://github.com/BrendelGroup/TRegGA.git
```

The TRegGA software itself is implemented primarily as a collection of shell scripts and Makefile-based workflows, so no compilation is needed.
However, TRegGA depends on several third-party programs and libraries, many of which do require compiling and/or additional configuration for your particular system.

**Note**: TRegGA has been tested and is supported on Linux, will *probably* work on Mac OS X and other UNIX systems, but is not supported on Windows.

The TRegGA workflow depends on several third-party programs and libraries, which are listed with sample installation instructions below.
These instructions may require minor adjustments depending on your operating system.

## Directory structure

All UNIX machines have one or more *installation directories*, such as `/usr` and `/usr/local`, where software is installed.
Within an installation directory, you will find subdirectories such as `bin` for executables, `include` for header files, `lib` for shared libraries, and so on.
For TRegGA installation, we recommend creating a dedicated installation directory within the root TRegGA directory, especially if you do not have administrative access to the machine.
The installation instructions below are written for this use case, although it should be fairly simple to adapt them to a different setup if needed.
In particular, if any of the prerequisite programs are already installed on your system, there should be no need to re-install them, assuming they are in your path (a couple of exceptions noted below).

In all of the examples below, the variable `$TRG_ROOT` refers to the TRegGA root directory, or the directory on your system that directly contains this file.

```
# Before proceeding, create installation directory
mkdir -p $TRG_ROOT/local

# Add the bin directory to your PATH.
# You may want to add this to your ~/.bashrc or ~/.bash_profile file, or
# include this in your launch script if you are executing TRegGA on a cluster.
export PATH=$TRG_ROOT/local/bin:$PATH
```

## Prerequisites

With a few exceptions, all prerequisites simply need to be placed in your `PATH` variable for TRegGA to work properly.
Here we provide details for the exceptions.

- KmerGenie must be executed using a full path to the program's source code distribution.
  Simply dropping it in your path won't work.
- Trimmomatic is distributed as a Java .jar file, and cannot be run without the full path to that .jar file.
- Artemis (optional; for visualization) must be executed using the full path to the program (is this correct?).
- Quast?

The user (you!) must provide the locations of these software components in a file named `TRegGA.config`, placed in the TRegGA root directory.
Use the file `TRegGA.config.example` as a template.

The script `check-prereqs.sh` is provided to facilitate troubleshooting.
Use it as a checklist while installing.

### AlignGraph

See https://github.com/baoe/AlignGraph.
Last update: July 5, 2015

```
cd $TRG_ROOT/local/src/
git clone https://github.com/baoe/AlignGraph.git
cd AlignGraph/
cp AlignGraph/AlignGraph Eval-AlignGraph/Eval-AlignGraph $TRG_ROOT/local/bin/

wget http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/blat/blat
chmod a+x blat
mv blat $TRG_ROOT/local/bin/
```

### Artemis

See https://www.sanger.ac.uk/resources/software/artemis.
Last update: July 13, 2015

```
cd $TRG_ROOT/local/src
wget ftp://ftp.sanger.ac.uk/pub/resources/software/artemis/artemis.tar.gz
tar -xzf artemis.tar.gz
cp act art dnaplotter $TRG_ROOT/local/bin/
# run as $TRG_ROOT/local/src/artemis/art
# This previous line confuses me. If we have to run it from the full path, why are we copying it to the bin dir?
```

### Bowtie

See http://bowtie-bio.sourceforge.net/index.shtml.
Last update: December 3, 2015

```
cd $TRG_ROOT/local/src/
wget https://github.com/BenLangmead/bowtie/archive/v1.1.2.tar.gz
tar xzf v1.1.2.tar.gz
cd bowtie-1.1.2/
make
make prefix=$TRG_ROOT/local/ install
```

### Bowtie2

See http://bowtie-bio.sourceforge.net/bowtie2/index.shtml.
Last update: December 3, 2015

```
cd $TRG_ROOT/local/src/
wget https://github.com/BenLangmead/bowtie2/archive/v2.2.5.tar.gz
tar xzf v2.2.5.tar.gz 
cd bowtie2-2.2.5/
make
cp bowtie2* $TRG_ROOT/local/bin/
```

### BWA

See http://bio-bwa.sourceforge.net.
Last update: December 3, 2015.

```
cd $TRG_ROOT/local/src/
wget https://github.com/lh3/bwa/archive/0.7.12.tar.gz
tar xzf 0.7.12.tar.gz 
cd bwa-0.7.12/
make
cp bwa $TRG_ROOT/local/bin/
```

### EMBOSS

See http://emboss.open-bio.org.
Last update: December 3, 2015.

```
cd $TRG_ROOT/local/src/
# Link is broken!
wget ftp://emboss.open-bio.org/pub/EMBOSS/EMBOSS-latest.tar.gz
tar -xzf EMBOSS-6.6.0.tar.gz
cd EMBOSS-6.6.0
./configure --prefix=$TRG_ROOT/local/
make
make install
```

### FASTQC

See http://www.bioinformatics.babraham.ac.uk/projects/fastqc.
Last update: July 5, 2015.

```
cd $TRG_ROOT/local/src/
wget http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.3.zip
unzip fastqc_v0.11.3.zip
chmod a+x FastQC/fastqc
ln -s $(pwd)/FastQC/fastqc $TRG_ROOT/local/bin/fastqc
```

### GapFiller

See http://www.baseclear.com/genomics/bioinformatics/basetools/gapfiller.
Last update: July 5, 2015

Note a license agreement (free for academics) is required.

A small patch must be applied to `GapFiller.pl`.
**DESCRIBE HERE**.

### GenomeThreader

See http://www.genomethreader.org/
Last update: December 3, 2015.

Note a license agreement (free for academics) is required.

```
# Obtain license file `gth.lic` before proceeding.
cd $TRG_ROOT/local/src/
wget http://genomethreader.org/distributions/gth-1.6.5-Linux_x86_64-64bit.tar.gz
tar -xzf gth-1.6.5-Linux_x86_64-64bit.tar.gz
cp -r gth-1.6.5-Linux_x86_64-64bit/bin/* $TRG_ROOT/local/bin/
cp /path/to/license/gth.lic $TRG_ROOT/local/bin/

# Set the following environmental variables.
export BSSMDIR=$TRG_ROOT/local/bin/bssm
export GTHDATADIR=$TRG_ROOT/local/bin/gthdata
```

### GenomeTools

See http://genometools.org.
Last update: December 3, 2015.

```
cd $TRG_ROOT/local/src/
wget http://genometools.org/pub/genometools-1.5.6.tar.gz
tar -xzf genometools-1.5.6.tar.gz
cd genometools-1.5.6
# Try` make errorcheck=no cairo=no prefix=$TRG_ROOT/local` if this fails
make cairo=no prefix=$TRG_ROOT/local
make cairo=no prefix=$TRG_ROOT/local install
```

### KmerGenie
See http://kmergenie.bx.psu.edu/
Last update: July 5, 2015.

```
cd $TRG_ROOT/local/src/
wget http://kmergenie.bx.psu.edu/kmergenie-1.6950.tar.gz
tar -xzf kmergenie-1.6950.tar.gz 
cd kmergenie-1.6950/
make
# invoke as /usr/local/src/NGS-DIR/KmerGenie/kmergenie-1.6950/kmergenie
```

### NGSUtils

See http://ngsutils.org.
Last update: July 5, 2015.

```
cd $TRG_ROOT/local/src/
wget https://github.com/ngsutils/ngsutils/archive/ngsutils-0.5.7.tar.gz
tar xzf ngsutils-0.5.7.tar.gz 
cd ngsutils-ngsutils-0.5.7/
make
cp bin/* $TRG_ROOT/local/bin/
```

### PAGIT

See from http://www.sanger.ac.uk/resources/software/pagit.
Last update: July 7, 2015.

```
cd $TRG_ROOT/local/src/
wget ftp://ftp.sanger.ac.uk/pub/resources/software/pagit/PAGIT.V1.64bit.tgz
tar -xzf PAGIT.V1.64bit.tgz 
bash ./installme.sh 
# (add to .bashrc:  source $TRG_ROOT/local/src/PAGIT/sourceme.pagit)
cd RATT
rm main.ratt.pl~ ratt_correction.pm~ start.ratt.sh~
cp RATT.config_euk RATT.config
```

### QUAST

See http://bioinf.spbau.ru/quast.
Last update: July 6, 2015.

```
pip install numpy scipy matplotlib ipython pandas nose

cd $TRG_ROOT/local/src/
wget http://sourceforge.net/projects/quast/files/quast-2.3.tar.gz/download
mv download quast-2.3.tar.gz
tar -xzf quast-2.3.tar.gz
# Please see 0README in /usr/local/src/NGS-DIR/QUAST for changes made to the code.
cd quast-2.3
# The following tests are more than tests: these runs also compile the code.
python quast.py --gage --test
python metaquast.py --test
```

Notes to clean up.

```
Two changes were made to the QUAST code distribution:

1) Installation should proceed with

        python quast.py --gage --test

instead of leaving out the "--gage" option.  The reason for this is that the code gets
compiled on first use, and this should be done by root at install to make gage.py work
for all users in future runs.

Change recorded in updated INSTALL file (compared to INSTALLorig).

2) Line 38 of libs/gage.py should have "return_code != 0:" instead of "return_code == 0:", I believe.
At least in all runs, return_code 0 gave error-free results that presumably should be logged as
'Done" rather than "Failed".

Original code saved as libs/gage.pyORIG.
```

```
	sudo yum install numpy scipy python-matplotlib ipython python-pandas sympy python-nose

	! The following notes re installation of packages would be specific to particular machines.
	python -c "import numpy; print numpy.__version__"
	updatedb
	locate numpy | more

	pip uninstall numpy
	pip install --upgrade numpy
	updatedb
	locate numpy | more
	python -c "import numpy; print numpy.__version__"

	! The following tests are more than tests: these runs also compile the code.
	python quast.py --gage --test
	python metaquast.py --test
```

### Samtools

See http://www.htslib.org.
Last update: December 3, 2015.

```
cd $TRG_ROOT/local/src/
wget https://github.com/samtools/samtools/releases/download/1.2/samtools-1.2.tar.bz2
tar xjf samtools-1.2.tar.bz2 
cd samtools-1.2/
make prefix=$TRG_ROOT/local
make prefix=$TRG_ROOT/local install
```

### SOAPdenovo2

See http://soap.genomics.org.cn/soapdenovo.html.
Last update: July 31, 2013.

```
cd $TRG_ROOT/local/src/
wget http://sourceforge.net/projects/soapdenovo2/files/SOAPdenovo2/bin/r240/SOAPdenovo2-bin-LINUX-generic-r240.tgz
tar -xzf SOAPdenovo2-bin-LINUX-generic-r240.tgz 
cd SOAPdenovo2-bin-LINUX-generic-r240/
chmod a+x *mer
cp *mer $TRG_ROOT/local/bin/
```

### SRAToolkit

See http://www.ncbi.nlm.nih.gov/books/NBK158900.
Last update: July 5, 2015.

```
cd $TRG_ROOT/local/src/
wget http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.5.2/sratoolkit.2.5.2-centos_linux64.tar.gz
tar -xzf sratoolkit.2.5.2-centos_linux64.tar.gz
cp sratoolkit.2.5.2-centos_linux64/bin/* $TRG_ROOT/local/bin/
```

### Trimmomatic

See http://www.usadellab.org/cms/index.php?page=trimmomatic.
Last update: July 5, 2015.

```
cd $TRG_ROOT/local/src/
wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.33.zip
unzip Trimmomatic-0.33.zip
```

