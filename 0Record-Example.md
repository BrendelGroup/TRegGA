### CHECKLIST prior to running TRegGA
- [ ] Install TRegGA: git clone https://github.com/BrendelGroup/TRegGA
- [ ] Install the required softwares as described in INSTALL.md
- [ ] Optional: setup the required modules to run in HPC environment such as Mason with xloadmodules
- [ ] Check for any missing softwares with check-prereqs.sh 
- [ ] Configure TRegGA.config for software locations that needs to be included into makefiles
- [ ] Install the requqired reference and datasets with setup.sh
- [ ] Check for any missing dataset with check-data.sh
- [ ] Optional: link reads and assemblies from other TRegGA repository to here with xlink
- [ ] Configure TRegGA.source for program locations that needs to be included into shell environment
- [ ] Setup TRegGA.sample as explained below
- [ ] Run TRegGA as explained in VIGNETTE.txt. 
- [ ] Alternatively, setup and run sub-scripts generated from the following script.  

### runTRegGA
* This script takes a list of `CULTIVAR|SYNONYM` of samples, and then generate sub-script, runTRegGA, for TRegGA job submitting.
* Input file: TRegGA.sample, formatted as: `CULTIVAR|SYNONYM`, one sample per row.
* Output: shell/qsub sub-script runTRegGA that are suitable for multi-sample job submission.
* The CULTIVAR argument must be in quotes (allowing spaces).
* The CULTIVAR can be the cultivar VARNAME such as `KOTO OURA S 5`, or less confusingly, the cultivar UNIQUE_ID such as `IRIS 313-10712`.
* The VARNAME and UNIQUE_ID to be parsed may be different from what you would find from literatures or online resources in terms of its format, such as `IRIS 313-10712` could be presented as `IRIS_313-10712`, `KOTO OURA S 5` could be presented as `KOTO-OURA-S-5`.
* User is advised to check/convert to the acceptable cultivar name prior to running TRegGA by validating it against this table `reads/rice_line_metadata_20140521.tsv`, or against the [Rice SNP-Seek Database from IRRI] (http://oryzasnp.org/iric-portal/_variety.zul) 
* The SYNONYM argument should be one word, with no space, hyphen or dot, such as KOTOOURAS5. Word with underscore is acceptable, such as KOTO_OURA_S_5. 
* The TARGET argument should uniquely identify the target specified by REFERENCE, FROM - TO range.
* If you want to change the range later, then use a different label or remove the existing TARGET.* files in subdirectory targets.

### Example for TRegGA
* Assembly of the SWEET13 locus using Zhengshan97 reads against the rice Japonica Nipponbare reference genome.
* CULTIVAR: Zhengshan97, SYNONYM: ZHENGSHAN97.
* Target source: http://plants.ensembl.org/Oryza_sativa/Gene/Summary?g=OS12G0476200;r=12:17302127-17305326;t=OS12T0476200-01
* SWEET13 (Xa25/xa25, Os12N3) gene ID in Oryza sativa Japonica: OS12G0476200, chromosome 12: 17,302,127-17,305,326 reverse strand.
* SWEET13 description: Bidirectional sugar transporter. Coding exons: 6. Transcript length: 1,653bp. Protein residues: 296aa.
* We recommed adding 10 Kb to the borders of the interested region as the final target to increase the specificity of the reference-guided assembly.
* We use chr12:17,292,001-17,315,000 as the target region for the following TRegGA example.
# Final makefile command looks like this:
```
make CHECKONLY=no NUMPROC=30 CULTIVAR='\"Zhengshan97\"' SYNONYM=ZHENGSHAN97 TARGET=OsjSWEET13 REFERENCE=OsjCHR12 FROM=17292001 TO=17315000 -f Makefile_TRegGA-orig >& err_ZHENGSHAN97-on-OsjSWEET13
```
### TRegGA setup
```
TRegGA_DIR=$(pwd)
SRCDIR=/usr/local/src/NGS-DIR
#SRCDIR=/N/dc2/projects/brendelgroup/TRegGA/src
```
- [ ] Configure TRegGA.config. Update TRegGA_DIR.
* IMPORTANT: TRegGA_DIR inside TRegGA.config should NOT be set using $(pwd) method, as TRegGA.config are to be included in different makefiles located in different directory, and using $(pwd) would result in different TRegGA_DIR. 
* Use "|" instead of "/" as separator for sed due to the "/" in TRegGA path
* sed command should be enclosed in "" for the variable ${TRegGA_DIR} to be substituted.
```
sed -e "s|YOUR_WORK_DIR|${TRegGA_DIR}|g" TRegGA.config.gnomic > TRegGA.config
sed -i "s|YOUR_SRC_DIR|${SRCDIR}|g" TRegGA.config
```
- [ ] Link other TRegGA repository with xlink
```
REPO=/home/huangcy/MYWORK/TRegGA
# REPO=/N/dc2/projects/brendelgroup/TRegGA/prj
# REPO=/N/dc2/scratch/vbrendel/TRegGA
sed -e "s|YOUR_REPO_DIR|${REPO}|g" xlink-orig > xlink
tcsh xlink
```
- [ ] Configure TRegGA.source. Update TRegGA_DIR.
```
sed -e "s|YOUR_WORK_DIR|${TRegGA_DIR}|g" TRegGA.source.gnomic > TRegGA.source
sed -i "s|YOUR_SRC_DIR|${SRCDIR}|g" TRegGA.source
```
- [ ] Setup TRegGA.sample.
```
echo "Biniapan|BINIAPAN
IRIS 313-10712|KOTOOURA
IRIS 313-11755|A2_257
CX140|NIPPONBARE
IRIS 313-11356|CR441" > TRegGA.sample
```
- [ ] TRegGA parameters
```
TRegGA_DIR=$(pwd)
source ${TRegGA_DIR}/TRegGA.source
EMAIL="youremail@indiana.edu"
WALLTIME=24
VMEM=500
PPN=30
CHECKONLY=no
NUMPROC=30
# CULTIVAR='\"Zhengshan97\"'
# SYNONYM="ZHENGSHAN97"
TARGET=OsjSWEET13
REFERENCE=OsjCHR12
FROM=17292001
TO=17315000
```
### Generate runTRegGA script for each sample in TRegGA.sample 
```
len=`awk 'END { print NR }' TRegGA.sample`
for ((k=1; k<=$len; k++))
do
head -$k TRegGA.sample | tail -1 > rec
CULTIVAR=`cut -d "|" -f1 rec`
SYNONYM=`cut -d "|" -f2 rec`
```
```
echo "
#!/bin/sh
set -eo pipefail
" > runTRegGA_${SYNONYM}-on-${TARGET}
```
```
echo "
#!/bin/bash
#PBS -m abe
#PBS -l nodes=1:ppn=${PPN},vmem=${VMEM}gb,walltime=${WALLTIME}:00:00
#PBS -M ${EMAIL}
#PBS -N TRegGA_${SYNONYM}-on-${TARGET}
#PBS -j oe

" > runTRegGA_${SYNONYM}-on-${TARGET}

cat ${TRegGA_DIR}/xloadmodules >> runTRegGA_${SYNONYM}-on-${TARGET}
```
```
echo "
TRegGA_DIR=${TRegGA_DIR}
source ${TRegGA_DIR}/TRegGA.source
source ${SRCDIR}/PAGIT/PAGIT/sourceme.pagit
cd ${TRegGA_DIR}

# For the read prep and no more.
# make CHECKONLY=${CHECKONLY} NUMPROC=${NUMPROC} CULTIVAR='\\\"${CULTIVAR}\\\"' SYNONYM=${SYNONYM} -f Makefile_TRegGA-orig ${TRegGA_DIR}/reads/${SYNONYM}/${SYNONYM}_1.fa >& err_${SYNONYM}-reads

# For the read prep and denovo assembly and no more.
# make CHECKONLY=${CHECKONLY} NUMPROC=${NUMPROC} CULTIVAR='\\\"${CULTIVAR}\\\"' SYNONYM=${SYNONYM} -f Makefile_TRegGA-orig ${TRegGA_DIR}/assembly/denovo/${SYNONYM}/${SYNONYM}-GF/${SYNONYM}-GF.gapfilled.final.fa >& err_${SYNONYM}-denovo

# For the target prep only
# make CHECKONLY=${CHECKONLY} NUMPROC=${NUMPROC} CULTIVAR='\\\"${CULTIVAR}\\\"' SYNONYM=${SYNONYM} TARGET=${TARGET} REFERENCE=${REFERENCE} FROM=${FROM} TO=${TO} -f Makefile_TRegGA-orig ${TRegGA_DIR}/targets/${TARGET}.embl >& err_${SYNONYM}-TargetPrep-${TARGET}

# For the entire workflow
make CHECKONLY=${CHECKONLY} NUMPROC=${NUMPROC} CULTIVAR='\\\"${CULTIVAR}\\\"' SYNONYM=${SYNONYM} TARGET=${TARGET} REFERENCE=${REFERENCE} FROM=${FROM} TO=${TO} -f Makefile_TRegGA-orig >& err_${SYNONYM}-on-${TARGET}

##---------------------------
# Traverse to ${TRegGA_DIR}/assembly/rfguided/${SYNONYM}-on-${TARGET}/EVALUATION for the assembly results.
# The assembly results can be visually evaluated against the target using the Artemis Comparson Tool (ACT):
# ${SRCDIR}/PAGIT/PAGIT/bin/act ${TARGET}.embl blastn.out ${SYNONYM}-${TARGET}.embl
# The gene structure predictions of the assembly by GenomeThreader can be found in the file gth.OsjPRT-on-${SYNONYM}-${TARGET}.

##---------------------------
## To clean up files after the job is done
# cd ${TRegGA_DIR}/reads/${SYNONYM}
# make -f Makefile_GPR_${SYNONYM} cleanup
# cd ${TRegGA_DIR}/assembly/denovo/${SYNONYM}
# make -f Makefile_denovo_${SYNONYM} cleanup
# cd ${TRegGA_DIR}/assembly/rfguided/${SYNONYM}-on-${TARGET}
# make -f Makefile_RGA_${SYNONYM}-on-${TARGET} cleanup

##-----------------------------
## To clean up files for all jobs under ${TRegGA_DIR}
# cd ${TRegGA_DIR}
# find . -path "*ALG/tmp" -type d | xargs -I {} \rm -r {}
# find . -path "*GF/alignoutput" -type d | xargs -I {} \rm -r {}
# find . -path "*GF/reads" -type d | xargs -I {} \rm -r {}

" >> runTRegGA_${SYNONYM}-on-${TARGET}
done
```

### runTRegGA
```
len=`awk 'END { print NR }' TRegGA.sample`
for ((k=1; k<=$len; k++))
do
head -$k TRegGA.sample | tail -1 > rec
SYNONYM=`cut -d "|" -f2 rec`
# qsub runTRegGA_${SYNONYM}-on-${TARGET}
# sh runTRegGA_${SYNONYM}-on-${TARGET}
done
```

