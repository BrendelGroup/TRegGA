# TRegGA Installation and Setup

## Obtaining TRegGA

Stable releases of TRegGA can be obtained from the [releases page](https://github.com/BrendelGroup/TRegGA/releases).

```bash
# Of course, replace 'vX.Y.Z' with the actual version number
wget https://github.com/BrendelGroup/TRegGA/archive/vX.Y.Z.tar.gz
tar -xzf vX.Y.Z.tar.xzf
cd TRegGA-vX.Y.Z/
```

If you're feeling a bit more adventurous, the latest and greatest development version of TRegGA is always accessible from the development repository on GitHub.

```bash
git clone https://github.com/BrendelGroup/TRegGA.git
cd TRegGA/
```

## Configuring TRegGA

The TRegGA software itself is implemented primarily as a collection of shell scripts and Makefile-based workflows, so no compilation is needed.
However, TRegGA depends on several third-party programs and libraries, many of which do require compiling and/or additional configuration for your particular system (details below).

**Note**: TRegGA has been tested and is supported on Linux, will *probably* work on Mac OS X and other UNIX systems, but is not supported on Windows.

Most programs required by TRegGA will work fine as long as they are in the `$PATH`.
However, there are a few that require the full path to the software's installation directory.
You must provide a `TRegGA.config` file that specifies the location of these directories, as well as the absolute path of the TRegGA root directory.
Make a copy of the `TRegGA.config.example` file and edit the copy with the correct values for your spefific system and setup.

```bash
cp TRegGA.config.example TRegGA.config
# Now edit TRegGA.config
```

## Software Prerequisites

With a couple of exceptions (KmerGenie and Trimmomatic), all software prerequisites simply need to be placed in your `$PATH` for TRegGA to work properly.
For TRegGA installation, we recommend creating a dedicated installation directory within the root TRegGA directory and placing its `bin` directory in your `$PATH`, especially if you do not have administrative access to the machine.
All instructions below are written for this use case, although it should be fairly simple to adapt them to a different setup if needed.
In particular, if any of the prerequisite programs are already installed on your system, there should be no need to re-install them, assuming they are in your path.
The script `check-prereqs.sh` is provided to facilitate troubleshooting: use it as a checklist while installing.

In all of the examples below, the variable `$TRegGA_DIR` is a placeholder for the absolute path of the TRegGA root directory, or the directory on your system that directly contains this file.
Replace this value with the actual directory path (or set the variable) before you execute the commands below.

```bash
# Before proceeding, create the installation directory
mkdir -p $TRegGA_DIR/local/src
mkdir -p $TRegGA_DIR/local/bin

# Add the bin directory to your PATH.
# You may want to add this command to your ~/.bashrc or ~/.bash_profile file,
# or include it in your launch script if you are executing TRegGA on a cluster.
export PATH=$TRegGA_DIR/local/bin:$PATH
```

### AlignGraph

See https://github.com/baoe/AlignGraph.
Last update: July 5, 2015

```bash
cd $TRegGA_DIR/local/src/
git clone https://github.com/baoe/AlignGraph.git
cd AlignGraph/
cp AlignGraph/AlignGraph Eval-AlignGraph/Eval-AlignGraph $TRegGA_DIR/local/bin/

wget http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/blat/blat
chmod a+x blat
mv blat $TRegGA_DIR/local/bin/
```

### Artemis

See https://www.sanger.ac.uk/resources/software/artemis.
Last update: July 13, 2015

```bash
cd $TRegGA_DIR/local/src
wget ftp://ftp.sanger.ac.uk/pub/resources/software/artemis/artemis.tar.gz
tar -xzf artemis.tar.gz
cp act art dnaplotter $TRegGA_DIR/local/bin/
# run as $TRegGA_DIR/local/src/artemis/art
# This previous line confuses me. If we have to run it from the full path, why are we copying it to the bin dir?
```

### BioPython

See http://biopython.org/wiki/Main_Page.
Last update: December 7th, 2015.

If you have administrative privileges on the machine, use your [package manager](http://biopython.org/wiki/Download#Packages) for best results.
Otherwise, we recommend using virtualenv and pip.

```bash
pip install biopython
```

### BLAST

* See https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastDocs&DOC_TYPE=Download.
* Last update: Dec. 2015

```bash
cd $TRegGA_DIR/local/src/
mkdir blast
cd blast
wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.3.0/ncbi-blast-2.3.0+-x64-linux.tar.gz
tar -xzf ncbi-blast-2.3.0+-x64-linux.tar.gz
export PATH=$PATH:$TRegGA_DIR/local/src/blast//ncbi-blast-2.3.0+/bin
```

### Bowtie

See http://bowtie-bio.sourceforge.net/index.shtml.
Last update: December 3, 2015

```bash
cd $TRegGA_DIR/local/src/
wget https://github.com/BenLangmead/bowtie/archive/v1.1.2.tar.gz
tar -xzf v1.1.2.tar.gz
cd bowtie-1.1.2/
make
make prefix=$TRegGA_DIR/local/ install
```

### Bowtie2

See http://bowtie-bio.sourceforge.net/bowtie2/index.shtml.
Last update: December 3, 2015

```bash
cd $TRegGA_DIR/local/src/
wget https://github.com/BenLangmead/bowtie2/archive/v2.2.5.tar.gz
tar -xzf v2.2.5.tar.gz
cd bowtie2-2.2.5/
make
cp bowtie2* $TRegGA_DIR/local/bin/
```

### BWA

See http://bio-bwa.sourceforge.net.
Last update: December 3, 2015.

```bash
cd $TRegGA_DIR/local/src/
wget https://github.com/lh3/bwa/archive/0.7.12.tar.gz
tar -xzf 0.7.12.tar.gz
cd bwa-0.7.12/
make
cp bwa $TRegGA_DIR/local/bin/
```

### EMBOSS

See http://emboss.open-bio.org.
Last update: December 3, 2015.

```bash
cd $TRegGA_DIR/local/src/
# Link is broken!
wget ftp://emboss.open-bio.org/pub/EMBOSS/EMBOSS-latest.tar.gz
tar -xzf EMBOSS-6.6.0.tar.gz
cd EMBOSS-6.6.0
./configure --prefix=$TRegGA_DIR/local/
make
make install
```

### FASTQC

See http://www.bioinformatics.babraham.ac.uk/projects/fastqc.
Last update: July 5, 2015.

```bash
cd $TRegGA_DIR/local/src/
wget http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.3.zip
unzip fastqc_v0.11.3.zip
chmod a+x FastQC/fastqc
ln -s $(pwd)/FastQC/fastqc $TRegGA_DIR/local/bin/fastqc
```

### GapFiller

See http://www.baseclear.com/genomics/bioinformatics/basetools/gapfiller.
Last update: July 5, 2015

Note a license agreement (free for academics) is required.

```bash
cd $TRegGA_DIR/local/src
mv /path/to/gapfiller/GapFiller_v1-10_linux-x86_64.tar.gz .
tar -xzf GapFiller_v1-10_linux-x86_64.tar.gz

# We need to apply a small patch to the program so that it will work
# with modern versions of Perl.
cd GapFiller_v1-10_linux-x86_64
dos2unix GapFiller.pl
cp GapFiller.pl GapFiller.plORIG
patch GapFiller.plORIG -i $TRegGA_DIR/patches/gapfiller.patch -o GapFiller.pl
chmod 755 GapFiller.pl
cp GapFiller.pl $TRegGA_DIR/local/bin/
```

### GenomeThreader

See http://www.genomethreader.org/
Last update: December 3, 2015.

Note a license agreement (free for academics) is required.

```bash
# Obtain license file `gth.lic` before proceeding.
cd $TRegGA_DIR/local/src/
wget http://genomethreader.org/distributions/gth-1.6.5-Linux_x86_64-64bit.tar.gz
tar -xzf gth-1.6.5-Linux_x86_64-64bit.tar.gz
cp -r gth-1.6.5-Linux_x86_64-64bit/bin/* $TRegGA_DIR/local/bin/
cp /path/to/license/gth.lic $TRegGA_DIR/local/bin/

# Set the following environmental variables.
export BSSMDIR=$TRegGA_DIR/local/bin/bssm
export GTHDATADIR=$TRegGA_DIR/local/bin/gthdata
```

### GenomeTools

See http://genometools.org.
Last update: December 3, 2015.

```bash
cd $TRegGA_DIR/local/src/
wget http://genometools.org/pub/genometools-1.5.6.tar.gz
tar -xzf genometools-1.5.6.tar.gz
cd genometools-1.5.6
# Try` make errorcheck=no cairo=no prefix=$TRegGA_DIR/local` if this fails
make cairo=no prefix=$TRegGA_DIR/local
make cairo=no prefix=$TRegGA_DIR/local install
```

### KmerGenie
See http://kmergenie.bx.psu.edu/
Last update: July 5, 2015.

```bash
cd $TRegGA_DIR/local/src/
wget http://kmergenie.bx.psu.edu/kmergenie-1.6950.tar.gz
tar -xzf kmergenie-1.6950.tar.gz
cd kmergenie-1.6950/
make
```

**Note**: The path to the KmerGenie direcory must be placed in the `$TRegGA_DIR/TRegGA.config` file.
The program cannot simply be placed in the `$PATH`, it must be executed with its full file path.

### NGSUtils

See http://ngsutils.org.
Last update: July 5, 2015.

```bash
cd $TRegGA_DIR/local/src/
wget https://github.com/ngsutils/ngsutils/archive/ngsutils-0.5.7.tar.gz
tar -xzf ngsutils-0.5.7.tar.gz
cd ngsutils-ngsutils-0.5.7/
make
cp bin/* $TRegGA_DIR/local/bin/
```

### PAGIT

See http://www.sanger.ac.uk/science/tools/pagit.
Last update: July 7, 2015.

```bash
cd $TRegGA_DIR/local/src/
mkdir PAGIT
cd PAGIT/
wget ftp://ftp.sanger.ac.uk/pub/resources/software/pagit/PAGIT.V1.64bit.tgz
tar -xzf PAGIT.V1.64bit.tgz
bash ./installme.sh
# (add to .bashrc:  source $TRegGA_DIR/local/src/PAGIT/sourceme.pagit)
cd PAGIT/RATT/
rm main.ratt.pl~ ratt_correction.pm~ start.ratt.sh~
cp RATT.config_euk RATT.config
```

### QUAST

See http://bioinf.spbau.ru/quast.
Last update: July 6, 2015.

```bash
pip install matplotlib
# You may need to replace the previous command with one of the following
# OS-specific commands depending on your OS.
# sudo yum install python-matplotlib
# sudo apt-get install python-matplotlib

cd $TRegGA_DIR/local/src/
wget http://sourceforge.net/projects/quast/files/quast-2.3.tar.gz/download
mv download quast-2.3.tar.gz
tar -xzf quast-2.3.tar.gz
cd quast-2.3
cp libs/gage.py libs/gage.pyORIG
patch libs/gage.pyORIG -i $TRegGA_DIR/patches/quast.patch -o libs/gage.py
# The following tests are more than tests: these runs also compile the code.
python quast.py --gage --test
python metaquast.py --test
```

### R

For installation instructions, see https://www.r-project.org.

### Samtools

See http://www.htslib.org.
Last update: December 3, 2015.

```bash
cd $TRegGA_DIR/local/src/
wget https://github.com/samtools/samtools/releases/download/1.2/samtools-1.2.tar.bz2
tar -xjf samtools-1.2.tar.bz2
cd samtools-1.2/
make prefix=$TRegGA_DIR/local
make prefix=$TRegGA_DIR/local install
```

### SOAPdenovo2

See http://soap.genomics.org.cn/soapdenovo.html.
Last update: July 31, 2013.

```bash
cd $TRegGA_DIR/local/src/
wget http://sourceforge.net/projects/soapdenovo2/files/SOAPdenovo2/bin/r240/SOAPdenovo2-bin-LINUX-generic-r240.tgz
tar -xzf SOAPdenovo2-bin-LINUX-generic-r240.tgz
cd SOAPdenovo2-bin-LINUX-generic-r240/
chmod a+x *mer
cp *mer $TRegGA_DIR/local/bin/
```

### SRAToolkit

See http://www.ncbi.nlm.nih.gov/books/NBK158900.
Last update: July 5, 2015.

```bash
cd $TRegGA_DIR/local/src/
wget http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.5.2/sratoolkit.2.5.2-centos_linux64.tar.gz
tar -xzf sratoolkit.2.5.2-centos_linux64.tar.gz
cp sratoolkit.2.5.2-centos_linux64/bin/* $TRegGA_DIR/local/bin/
```

### Trimmomatic

See http://www.usadellab.org/cms/index.php?page=trimmomatic.
Last update: July 5, 2015.

```bash
cd $TRegGA_DIR/local/src/
wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.33.zip
unzip Trimmomatic-0.33.zip
```

**Note**: Trimmomatic is distributed as a Java .jar file.
The path of the .jar file must be placed in the `$TRegGA_DIR/TRegGA.config` file.
